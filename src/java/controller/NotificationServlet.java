package controller;

import dao.NotificationDAO;
import dao.SessionDAO;
import model.LearningSession;
import model.Notification;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");

        SessionDAO sessionDAO = new SessionDAO();
        NotificationDAO notifDAO = new NotificationDAO();

        request.setAttribute("sessionRequests", sessionDAO.getPendingRequestsForMentor(user.getUserId()));
        request.setAttribute("chatNotifications", notifDAO.getNotificationsByType(user.getUserId(), "message"));
        request.getRequestDispatcher("/jsp/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        String action = request.getParameter("action");

        if ("acceptSession".equals(action) || "rejectSession".equals(action)) {
            handleSessionAction(request, response, user, action);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/notifications");
    }

    private void handleSessionAction(HttpServletRequest request, HttpServletResponse response,
            User user, String action) throws IOException {
        int sessionId;
        try {
            sessionId = Integer.parseInt(request.getParameter("sessionId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/notifications?error=Invalid+session");
            return;
        }

        SessionDAO sessionDAO = new SessionDAO();
        LearningSession s = sessionDAO.getSessionById(sessionId);
        if (s == null || s.getMentorId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/notifications?error=Session+not+found");
            return;
        }

        String responseReason = request.getParameter("responseReason");
        if (responseReason != null) responseReason = responseReason.trim();
        else responseReason = "";

        if ("rejectSession".equals(action) && responseReason.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/notifications?error=Please+enter+a+reason+for+rejecting");
            return;
        }

        String status = "acceptSession".equals(action) ? "Accepted" : "Rejected";
        sessionDAO.updateStatus(sessionId, status);

        StringBuilder msg = new StringBuilder();
        msg.append("Your peer session request for \"").append(s.getSkillName()).append("\" was ")
           .append(status.toLowerCase()).append(" by ").append(user.getName()).append(".");
        if (!responseReason.isEmpty()) {
            msg.append("\n\nResponse: ").append(responseReason);
        }

        NotificationDAO notifDAO = new NotificationDAO();
        notifDAO.addNotification(s.getLearnerId(),
                "Session " + status,
                msg.toString(),
                "session",
                sessionId);

        response.sendRedirect(request.getContextPath() + "/notifications?success=Session+" + status.toLowerCase());
    }
}
