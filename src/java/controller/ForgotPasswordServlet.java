package controller;

import dao.UserDAO;
import model.User;
import utility.EmailUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Random;

public class ForgotPasswordServlet extends HttpServlet {

    private static final int CODE_EXPIRY_MS = 15 * 60 * 1000;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String step = request.getParameter("step");
        if (step == null || "email".equals(step)) {
            handleSendCode(request, response);
        } else {
            handleReset(request, response);
        }
    }

    private void handleSendCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your email.");
            request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email.trim());
        if (user == null) {
            request.setAttribute("error", "No account found with that email.");
            request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
            return;
        }

        String code = String.format("%06d", new Random().nextInt(999999));
        HttpSession session = request.getSession(true);
        session.setAttribute("fpResetEmail", user.getEmail());
        session.setAttribute("fpResetCode", code);
        session.setAttribute("fpResetExpiry", System.currentTimeMillis() + CODE_EXPIRY_MS);

        String body = "Hello " + user.getName() + ",\n\n"
                + "Your SkillSwap Campus password reset code is:\n\n"
                + code + "\n\n"
                + "This code expires in 15 minutes.\n\n— SkillSwap Campus";

        if (!EmailUtil.isConfigured(getServletContext())) {
            session.removeAttribute("fpResetCode");
            session.removeAttribute("fpResetExpiry");
            session.removeAttribute("fpResetEmail");
            request.setAttribute("error",
                    "Email is not set up. Edit web/WEB-INF/email.properties with your Gmail and App Password, then Clean and Build. See EMAIL_SETUP.txt.");
            request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
            return;
        }

        boolean sent = EmailUtil.send(getServletContext(), user.getEmail(),
                "SkillSwap Campus – Password Reset Code", body);

        if (!sent) {
            session.removeAttribute("fpResetCode");
            session.removeAttribute("fpResetExpiry");
            session.removeAttribute("fpResetEmail");
            request.setAttribute("error",
                    "Could not send email. Check your SMTP settings in WEB-INF/email.properties and Tomcat Output.");
            request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
            return;
        }

        request.setAttribute("step", "verify");
        request.setAttribute("email", user.getEmail());
        request.setAttribute("maskedEmail", EmailUtil.maskEmail(user.getEmail()));
        request.setAttribute("info",
                "A verification code was sent to " + EmailUtil.maskEmail(user.getEmail()) + ". Check your inbox and spam folder.");
        request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
    }

    private void handleReset(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String newPassword = request.getParameter("newPassword");
        String confirm     = request.getParameter("confirmPassword");
        String code        = request.getParameter("verificationCode");

        if (session == null) {
            request.setAttribute("error", "Session expired. Start again.");
            request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
            return;
        }

        String stored = (String) session.getAttribute("fpResetCode");
        Long expiry   = (Long) session.getAttribute("fpResetExpiry");
        String email    = (String) session.getAttribute("fpResetEmail");

        if (stored == null || expiry == null || email == null) {
            request.setAttribute("error", "Session expired. Enter your email again.");
            request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
            return;
        }
        if (System.currentTimeMillis() > expiry) {
            request.setAttribute("error", "Code expired. Request a new one.");
            request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
            return;
        }
        if (code == null || !code.trim().equals(stored)) {
            request.setAttribute("error", "Invalid verification code.");
            request.setAttribute("step", "verify");
            request.setAttribute("email", email);
            request.setAttribute("maskedEmail", EmailUtil.maskEmail(email));
            request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
            return;
        }
        if (newPassword == null || !newPassword.equals(confirm)) {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("step", "verify");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);
        if (user != null && userDAO.updatePassword(user.getUserId(), newPassword)) {
            session.removeAttribute("fpResetCode");
            session.removeAttribute("fpResetExpiry");
            session.removeAttribute("fpResetEmail");
            request.setAttribute("success", "Password reset successful! Please login.");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to reset password. Try again.");
            request.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(request, response);
        }
    }
}
