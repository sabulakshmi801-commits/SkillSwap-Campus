package controller;

import dao.ResourceDAO;
import dao.SkillDAO;
import model.Resource;
import model.Skill;
import model.User;
import utility.FileUploadUtil;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;

@MultipartConfig(maxFileSize = 52428800, maxRequestSize = 52428800)
public class UploadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        ResourceDAO resourceDAO = new ResourceDAO();
        SkillDAO skillDAO = new SkillDAO();
        request.setAttribute("resources", resourceDAO.getAllResources());
        String view = request.getParameter("view");
        if ("upload".equals(view)) {
            List<Skill> userSkills = skillDAO.getSkillsByUser(user.getUserId());
            request.setAttribute("userSkills", userSkills);
            request.getRequestDispatcher("/jsp/uploadResource.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/jsp/resources.jsp").forward(request, response);
        }
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

        String title       = request.getParameter("title");
        String description = request.getParameter("description");
        int skillId = 0;
        try { skillId = Integer.parseInt(request.getParameter("skillId")); }
        catch (NumberFormatException ignored) {}

        SkillDAO skillDAO = new SkillDAO();
        Skill selectedSkill = skillDAO.getSkillById(skillId);
        if (selectedSkill == null || selectedSkill.getUserId() != user.getUserId()) {
            request.setAttribute("error", "Please select one of your profile skills.");
            request.setAttribute("userSkills", skillDAO.getSkillsByUser(user.getUserId()));
            request.getRequestDispatcher("/jsp/uploadResource.jsp").forward(request, response);
            return;
        }
        String category = selectedSkill.getSkillName();

        Part filePart = request.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Please select a file to upload.");
            request.setAttribute("userSkills", skillDAO.getSkillsByUser(user.getUserId()));
            request.getRequestDispatcher("/jsp/uploadResource.jsp").forward(request, response);
            return;
        }

        File uploadRoot = FileUploadUtil.getUploadRoot(getServletContext());
        String origName  = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileName  = System.currentTimeMillis() + "_" + origName;
        File destFile    = new File(uploadRoot, fileName);

        try (InputStream in = filePart.getInputStream();
             OutputStream out = new FileOutputStream(destFile)) {
            byte[] buf = new byte[4096]; int r;
            while ((r = in.read(buf)) != -1) out.write(buf, 0, r);
        }

        String ext = origName.lastIndexOf('.') >= 0
                   ? origName.substring(origName.lastIndexOf('.') + 1).toUpperCase() : "FILE";

        Resource resource = new Resource();
        resource.setUserId(user.getUserId());
        resource.setSkillId(skillId);
        resource.setTitle(title);
        resource.setFileName(fileName);
        resource.setFileType(ext);
        resource.setFilePath(fileName);
        resource.setDescription(description != null ? description.trim() : "");
        resource.setCategory(category);

        ResourceDAO resourceDAO = new ResourceDAO();
        if (resourceDAO.uploadResource(resource)) {
            response.sendRedirect(request.getContextPath() + "/upload?success=File+uploaded+successfully");
        } else {
            request.setAttribute("error", "Upload failed. Please try again.");
            request.setAttribute("userSkills", skillDAO.getSkillsByUser(user.getUserId()));
            request.getRequestDispatcher("/jsp/uploadResource.jsp").forward(request, response);
        }
    }
}
