package controller;

import dao.*;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        UserDAO    userDAO    = new UserDAO();
        SessionDAO sessionDAO = new SessionDAO();
        AdminDAO   adminDAO   = new AdminDAO();

        switch (action) {
            case "users":
                request.setAttribute("users", userDAO.getAllUsers());
                request.getRequestDispatcher("/jsp/manageUsers.jsp").forward(request, response);
                return;

            case "sessions":
                request.setAttribute("allSessions", sessionDAO.getAllSessions());
                request.getRequestDispatcher("/jsp/adminSessions.jsp").forward(request, response);
                return;

            case "toggleUser":
                int uid = Integer.parseInt(request.getParameter("userId"));
                boolean activate = "true".equals(request.getParameter("activate"));
                userDAO.toggleUserStatus(uid, activate);
                response.sendRedirect(request.getContextPath() + "/admin?action=users");
                return;

            case "deleteUser":
                int delId = Integer.parseInt(request.getParameter("userId"));
                userDAO.deleteUser(delId);
                response.sendRedirect(request.getContextPath() + "/admin?action=users");
                return;

            default: // dashboard
                Map<String, Integer> analytics = adminDAO.getAnalytics();
                List<Map<String, String>> deptStats   = adminDAO.getDepartmentStats();
                List<Map<String, String>> popularSkills = adminDAO.getPopularSkills();
                List<Map<String, String>> monthlySessions = adminDAO.getMonthlySessionStats();

                request.setAttribute("analytics",       analytics);
                request.setAttribute("deptStats",        deptStats);
                request.setAttribute("popularSkills",    popularSkills);
                request.setAttribute("monthlySessions",  monthlySessions);
                request.getRequestDispatcher("/jsp/adminDashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
