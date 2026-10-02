package controller;

import dao.ResourceDAO;
import model.Resource;
import utility.FileUploadUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Files;

public class ResourceDownloadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int resourceId;
        try {
            resourceId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/upload?error=Invalid+resource");
            return;
        }

        ResourceDAO dao = new ResourceDAO();
        Resource res = dao.getResourceById(resourceId);
        if (res == null) {
            response.sendRedirect(request.getContextPath() + "/upload?error=Resource+not+found");
            return;
        }

        File file = resolveResourceFile(request.getServletContext(), res);
        if (file == null || !file.isFile()) {
            response.sendRedirect(request.getContextPath() + "/upload?error=File+not+available.+Ask+uploader+to+re-upload.");
            return;
        }

        String downloadName = res.getFileName() != null ? res.getFileName() : file.getName();
        String contentType = getServletContext().getMimeType(downloadName);
        if (contentType == null) contentType = "application/octet-stream";

        response.setContentType(contentType);
        response.setHeader("Content-Disposition", "attachment; filename=\"" + downloadName.replace("\"", "") + "\"");
        response.setContentLengthLong(file.length());

        Files.copy(file.toPath(), response.getOutputStream());
        dao.incrementDownloadCount(resourceId);
    }

    private File resolveResourceFile(ServletContext ctx, Resource res) {
        if (res.getFileName() != null) {
            File f = FileUploadUtil.resolveStoredFile(ctx, res.getFileName());
            if (f != null) return f;
        }
        if (res.getFilePath() != null) {
            String p = res.getFilePath().replace('\\', '/');
            if (p.startsWith("uploads/")) p = p.substring("uploads/".length());
            File f = FileUploadUtil.resolveStoredFile(ctx, p);
            if (f != null) return f;
        }
        return null;
    }
}
