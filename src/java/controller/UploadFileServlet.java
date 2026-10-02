package controller;

import utility.FileUploadUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Files;

/** Serves profile photos and resource files from the persistent upload directory. */
public class UploadFileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        String relative = pathInfo.substring(1).replace('\\', '/');
        if (relative.contains("..")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        File file = FileUploadUtil.resolveStoredFile(getServletContext(), relative);
        if (file == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String name = file.getName().toLowerCase();
        if (name.endsWith(".png")) response.setContentType("image/png");
        else if (name.endsWith(".jpg") || name.endsWith(".jpeg")) response.setContentType("image/jpeg");
        else if (name.endsWith(".gif")) response.setContentType("image/gif");
        else if (name.endsWith(".webp")) response.setContentType("image/webp");
        else if (name.endsWith(".pdf")) response.setContentType("application/pdf");
        else response.setContentType("application/octet-stream");

        response.setHeader("Cache-Control", "private, max-age=86400");
        Files.copy(file.toPath(), response.getOutputStream());
    }
}
