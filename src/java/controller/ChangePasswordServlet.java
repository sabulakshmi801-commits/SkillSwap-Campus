package controller;

import dao.UserDAO;
import model.User;
import utility.EmailUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Random;

public class ChangePasswordServlet extends HttpServlet {

    private static final int CODE_EXPIRY_MS = 15 * 60 * 1000;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedUser = (User) session.getAttribute("loggedUser");
        UserDAO userDAO = new UserDAO();
        User dbUser = userDAO.getUserById(loggedUser.getUserId());
        String action = request.getParameter("action");

        if ("sendCode".equals(action)) {
            handleSendCode(request, response, session, dbUser, userDAO);
        } else if ("confirm".equals(action)) {
            handleConfirm(request, response, session, dbUser, userDAO);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    private void handleSendCode(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, User dbUser, UserDAO userDAO) throws IOException, ServletException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || !dbUser.getPassword().trim().equals(currentPassword.trim())) {
            session.setAttribute("pwdError", "Current password is incorrect.");
            response.sendRedirect(request.getContextPath() + "/profile?pwd=1");
            return;
        }
        if (newPassword == null || newPassword.length() < 4) {
            session.setAttribute("pwdError", "New password must be at least 4 characters.");
            response.sendRedirect(request.getContextPath() + "/profile?pwd=1");
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("pwdError", "New passwords do not match.");
            response.sendRedirect(request.getContextPath() + "/profile?pwd=1");
            return;
        }

        String code = String.format("%06d", new Random().nextInt(999999));
        session.setAttribute("pwdResetCode", code);
        session.setAttribute("pwdResetExpiry", System.currentTimeMillis() + CODE_EXPIRY_MS);
        session.setAttribute("pwdPendingNew", newPassword);

        String body = "Hello " + dbUser.getName() + ",\n\n"
                + "Your SkillSwap Campus password change verification code is:\n\n"
                + code + "\n\n"
                + "This code expires in 15 minutes. If you did not request this, ignore this email.\n\n"
                + "— SkillSwap Campus";

        if (!EmailUtil.isConfigured(getServletContext())) {
            session.setAttribute("pwdError",
                    "Email is not set up. Edit web/WEB-INF/email.properties (see EMAIL_SETUP.txt), then Clean and Build.");
            response.sendRedirect(request.getContextPath() + "/profile?pwd=1");
            return;
        }

        boolean sent = EmailUtil.send(getServletContext(), dbUser.getEmail(),
                "SkillSwap Campus – Password Change Code", body);

        if (!sent) {
            session.setAttribute("pwdError",
                    "Could not send email. Check WEB-INF/email.properties and Tomcat Output.");
            response.sendRedirect(request.getContextPath() + "/profile?pwd=1");
            return;
        }

        session.setAttribute("pwdStep", "verify");
        session.setAttribute("pwdMaskedEmail", EmailUtil.maskEmail(dbUser.getEmail()));
        session.setAttribute("pwdInfo",
                "A verification code was sent to " + EmailUtil.maskEmail(dbUser.getEmail()) + ". Check your inbox and spam folder.");
        response.sendRedirect(request.getContextPath() + "/profile?pwd=1");
    }

    private void handleConfirm(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, User dbUser, UserDAO userDAO) throws IOException {
        String entered = request.getParameter("verificationCode");
        String stored  = (String) session.getAttribute("pwdResetCode");
        Long expiry    = (Long) session.getAttribute("pwdResetExpiry");
        String newPwd    = (String) session.getAttribute("pwdPendingNew");

        if (stored == null || expiry == null || newPwd == null) {
            session.setAttribute("pwdError", "Session expired. Please start again.");
            clearPwdSession(session);
            response.sendRedirect(request.getContextPath() + "/profile?pwd=1");
            return;
        }
        if (System.currentTimeMillis() > expiry) {
            session.setAttribute("pwdError", "Verification code expired. Request a new one.");
            clearPwdSession(session);
            response.sendRedirect(request.getContextPath() + "/profile?pwd=1");
            return;
        }
        if (entered == null || !entered.trim().equals(stored)) {
            session.setAttribute("pwdError", "Invalid verification code.");
            session.setAttribute("pwdStep", "verify");
            response.sendRedirect(request.getContextPath() + "/profile?pwd=1");
            return;
        }

        if (userDAO.updatePassword(dbUser.getUserId(), newPwd)) {
            clearPwdSession(session);
            session.setAttribute("pwdSuccess", "Password updated successfully.");
            User refreshed = userDAO.getUserById(dbUser.getUserId());
            refreshed.setPassword(newPwd);
            session.setAttribute("loggedUser", refreshed);
        } else {
            session.setAttribute("pwdError", "Could not update password. Try again.");
        }
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private void clearPwdSession(HttpSession session) {
        session.removeAttribute("pwdResetCode");
        session.removeAttribute("pwdResetExpiry");
        session.removeAttribute("pwdPendingNew");
        session.removeAttribute("pwdStep");
        session.removeAttribute("pwdMaskedEmail");
        session.removeAttribute("pwdInfo");
    }
}
