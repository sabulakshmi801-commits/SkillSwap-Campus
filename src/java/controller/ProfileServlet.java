package controller;

import dao.*;
import model.User;
import utility.FileUploadUtil;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;

@MultipartConfig(maxFileSize = 5242880, maxRequestSize = 10485760)
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession(false);
        if (httpSession == null || httpSession.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User loggedUser = (User) httpSession.getAttribute("loggedUser");
        String viewIdStr = request.getParameter("id");
        int viewId = (viewIdStr != null && !viewIdStr.isEmpty())
                   ? Integer.parseInt(viewIdStr) : loggedUser.getUserId();

        UserDAO     userDAO     = new UserDAO();
        SkillDAO    skillDAO    = new SkillDAO();
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        SessionDAO  sessionDAO  = new SessionDAO();

        User profileUser = userDAO.getUserById(viewId);
        if (profileUser == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.setAttribute("profileUser",     profileUser);
        request.setAttribute("profileSkills",   skillDAO.getSkillsByUser(viewId));
        request.setAttribute("profileFeedback", feedbackDAO.getFeedbackForUser(viewId));
        request.setAttribute("profileSessions", sessionDAO.getSessionsByUser(viewId));
        request.setAttribute("isOwn",           viewId == loggedUser.getUserId());

        request.getRequestDispatcher("/jsp/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession(false);
        if (httpSession == null || httpSession.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDAO userDAO = new UserDAO();
        User dbUser = userDAO.getUserById(((User) httpSession.getAttribute("loggedUser")).getUserId());
        if (dbUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        dbUser.setName(request.getParameter("name"));
        dbUser.setDepartment(request.getParameter("department"));
        dbUser.setBio(request.getParameter("bio"));

        Part photoPart = null;
        try { photoPart = request.getPart("profilePhoto"); } catch (Exception ignored) {}

        if (photoPart != null && photoPart.getSize() > 0) {
            String originalName = Paths.get(photoPart.getSubmittedFileName()).getFileName().toString();
            int dot = originalName.lastIndexOf('.');
            String ext = dot >= 0 ? originalName.substring(dot) : ".jpg";
            String newName = "user_" + dbUser.getUserId() + "_" + System.currentTimeMillis() + ext;

            File profileDir = new File(FileUploadUtil.getUploadRoot(getServletContext()), "profile");
            if (!profileDir.exists()) profileDir.mkdirs();

            File dest = new File(profileDir, newName);
            try (InputStream in = photoPart.getInputStream();
                 OutputStream out = new FileOutputStream(dest)) {
                byte[] buf = new byte[4096];
                int r;
                while ((r = in.read(buf)) != -1) out.write(buf, 0, r);
            }
            String photoPath = "profile/" + newName;
            userDAO.updateProfilePhoto(dbUser.getUserId(), photoPath);
            dbUser.setProfilePhoto(photoPath);
        }

        if (dbUser.getProfilePhoto() != null) {
            dbUser.setProfilePhoto(normalizePhotoPath(dbUser.getProfilePhoto()));
        }
        userDAO.updateProfileInfo(dbUser);

        User refreshed = userDAO.getUserById(dbUser.getUserId());
        httpSession.setAttribute("loggedUser", refreshed);
        httpSession.setAttribute("userName",   refreshed.getName());

        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private String normalizePhotoPath(String photo) {
        if (photo == null) return "default.png";
        String p = photo.replace('\\', '/').trim();
        while (p.startsWith("uploads/")) {
            p = p.substring("uploads/".length());
        }
        return p.isEmpty() ? "default.png" : p;
    }
}
