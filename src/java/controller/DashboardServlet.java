package controller;

import dao.*;
import model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession(false);
        if (httpSession == null || httpSession.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) httpSession.getAttribute("loggedUser");

        SkillDAO   skillDAO   = new SkillDAO();
        SessionDAO sessionDAO = new SessionDAO();
        NotificationDAO notifDAO = new NotificationDAO();
        UserDAO    userDAO    = new UserDAO();

        // Refresh user from DB (ensures latest photo etc.)
        User fresh = userDAO.getUserById(user.getUserId());
        if (fresh != null) {
            httpSession.setAttribute("loggedUser", fresh);
        }

        List<Skill>           allSkills  = skillDAO.getAllSkillsExceptUser(user.getUserId());
        List<LearningSession> mySessions = sessionDAO.getSessionsByUser(user.getUserId());
        List<String>          trending   = skillDAO.getTrendingSkills();
        int unreadNotif = notifDAO.getUnreadCount(user.getUserId());

        request.setAttribute("allSkills",     allSkills);
        request.setAttribute("mySessions",    mySessions);
        request.setAttribute("trendingSkills",trending);
        request.setAttribute("unreadNotif",   unreadNotif);

        request.getRequestDispatcher("/jsp/dashboard.jsp").forward(request, response);
    }
}
