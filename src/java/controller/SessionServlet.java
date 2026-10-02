package controller;

import dao.*;
import model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class SessionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession(false);
        if (httpSession == null || httpSession.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) httpSession.getAttribute("loggedUser");
        String action = request.getParameter("action");
        SessionDAO sessionDAO = new SessionDAO();

        if ("request".equals(action)) {
            String skillIdStr = request.getParameter("skillId");
            if (skillIdStr != null && !skillIdStr.isEmpty()) {
                SkillDAO skillDAO = new SkillDAO();
                Skill skill = skillDAO.getSkillById(Integer.parseInt(skillIdStr));
                request.setAttribute("skill", skill);
            }
            request.getRequestDispatcher("/jsp/requestSession.jsp").forward(request, response);
            return;
        }

        if ("details".equals(action)) {
            int sessionId = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("sessionDetail", sessionDAO.getSessionById(sessionId));
            request.getRequestDispatcher("/jsp/sessionDetails.jsp").forward(request, response);
            return;
        }

        // Accept / Reject / Complete / Cancel
        if ("accept".equals(action) || "reject".equals(action)
                || "complete".equals(action) || "cancel".equals(action)) {
            int sessionId = Integer.parseInt(request.getParameter("id"));
            String status;
            switch (action) {
                case "accept":   status = "Accepted";  break;
                case "reject":   status = "Rejected";  break;
                case "complete": status = "Completed"; break;
                default:         status = "Cancelled"; break;
            }
            LearningSession s = sessionDAO.getSessionById(sessionId);
            if (s != null) {
                sessionDAO.updateStatus(sessionId, status);
                NotificationDAO notifDAO = new NotificationDAO();
                int notifyUser = (user.getUserId() == s.getMentorId())
                               ? s.getLearnerId() : s.getMentorId();
                notifDAO.addNotification(notifyUser,
                    "Session " + status,
                    "Your session for \"" + s.getSkillName() + "\" has been " + status.toLowerCase() + ".",
                    "session",
                    sessionId);
            }
            response.sendRedirect(request.getContextPath() + "/session");
            return;
        }

        List<LearningSession> sessions = sessionDAO.getSessionsByUser(user.getUserId());
        request.setAttribute("sessions", sessions);
        request.getRequestDispatcher("/jsp/mySessions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession(false);
        if (httpSession == null || httpSession.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) httpSession.getAttribute("loggedUser");
        LearningSession session = new LearningSession();
        session.setLearnerId(user.getUserId());
        session.setMentorId(Integer.parseInt(request.getParameter("mentorId")));
        try { session.setSkillId(Integer.parseInt(request.getParameter("skillId"))); }
        catch (NumberFormatException e) { session.setSkillId(0); }
        session.setSkillName(request.getParameter("skillName"));
        session.setSessionDate(request.getParameter("sessionDate"));
        session.setSessionTime(request.getParameter("sessionTime"));
        session.setSessionType(request.getParameter("sessionType"));
        session.setSessionMode(request.getParameter("sessionMode"));
        session.setNotes(request.getParameter("notes"));

        SessionDAO sessionDAO = new SessionDAO();
        int newSessionId = sessionDAO.requestSession(session);
        if (newSessionId > 0) {
            NotificationDAO notifDAO = new NotificationDAO();
            notifDAO.addNotification(session.getMentorId(),
                "Peer Session Request",
                user.getName() + " requested a peer learning session for \"" + session.getSkillName() + "\".",
                "session",
                newSessionId);
            response.sendRedirect(request.getContextPath() + "/session?success=Session+requested+successfully");
        } else {
            request.setAttribute("error", "Failed to request session. Please try again.");
            request.getRequestDispatcher("/jsp/requestSession.jsp").forward(request, response);
        }
    }
}
