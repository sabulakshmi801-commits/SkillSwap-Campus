package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("loggedUser") != null) {

            User u = (User) session.getAttribute("loggedUser");

            response.sendRedirect(
                    request.getContextPath() +
                    ("admin".equals(u.getRole()) ? "/admin" : "/dashboard")
            );

        } else {

            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("ENTERED EMAIL: [" + email + "]");
        System.out.println("ENTERED PASSWORD: [" + password + "]");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);

        if (user == null) {

            System.out.println("USER NOT FOUND");

        } else {

            System.out.println("USER FOUND");
            System.out.println("DATABASE PASSWORD: [" + user.getPassword() + "]");
            System.out.println("ACCOUNT ACTIVE: " + user.isActive());

        }

        if (user != null &&
                user.getPassword().trim().equals(password.trim()) &&
                user.isActive()) {

            HttpSession session = request.getSession(true);

            User fresh = userDAO.getUserById(user.getUserId());
            if (fresh != null) user = fresh;

            session.setAttribute("loggedUser", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());

            session.setMaxInactiveInterval(60 * 60);

            System.out.println("LOGIN SUCCESS");

            if ("admin".equals(user.getRole())) {

                response.sendRedirect(request.getContextPath() + "/admin");

            } else {

                response.sendRedirect(request.getContextPath() + "/dashboard");

            }

        } else if (user != null && !user.isActive()) {

            System.out.println("ACCOUNT DEACTIVATED");

            request.setAttribute("error",
                    "Your account has been deactivated. Contact admin.");

            request.getRequestDispatcher("/jsp/login.jsp")
                    .forward(request, response);

        } else {

            System.out.println("INVALID LOGIN");

            request.setAttribute("error",
                    "Invalid email or password. Please try again.");

            request.getRequestDispatcher("/jsp/login.jsp")
                    .forward(request, response);
        }
    }
}
