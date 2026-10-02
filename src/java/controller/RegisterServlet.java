package controller;

import dao.UserDAO;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name            = request.getParameter("name");
        String email           = request.getParameter("email");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role            = request.getParameter("role");
        String department      = request.getParameter("department");
        String bio             = request.getParameter("bio");

        // Validation
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Name is required.");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        if (userDAO.getUserByEmail(email) != null) {
            request.setAttribute("error", "Email already registered. Please login.");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim());
        user.setPassword(password);
        user.setRole(role != null ? role : "student");
        user.setDepartment(department);
        user.setBio(bio);
        user.setProfilePhoto("default.png");

        if (userDAO.registerUser(user)) {
            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
        }
    }
}
