<%@ page import="java.util.List" %>
<%@ page import="model.Resource" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // SESSION CHECK
    if(session == null || session.getAttribute("loggedUser") == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // CACHE CONTROL
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    request.setAttribute("pageTitle", "Study Resources");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <title>Resources - SkillSwap Campus</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

    <div class="app-wrapper">

        <jsp:include page="sidebar.jsp"/>

        <div class="main-content">

            <jsp:include page="topbar.jsp"/>

            <div class="content-area">

                <!-- Header -->
                <div class="d-flex justify-between align-center mb-3">

                    <h2 style="font-size:18px; font-weight:800;">
                        Campus Resources
                    </h2>

                    <a href="${pageContext.request.contextPath}/upload?view=upload"
                       class="btn btn-primary">

                        <i class="fa-solid fa-cloud-arrow-up"></i>

                        Upload Resource

                    </a>

                </div>

                <!-- Resource Cards -->
                <div class="grid grid-3">

                    <%
                        List<Resource> res =
                                (List<Resource>) request.getAttribute("resources");

                        if(res != null && !res.isEmpty()) {

                            for(Resource r : res) {

                                String icon = "fa-file";

                                String type =
                                        r.getFileType() != null
                                                ? r.getFileType().toLowerCase()
                                                : "";

                                if(type.contains("pdf"))
                                    icon = "fa-file-pdf text-danger";

                                else if(type.contains("doc")
                                        || type.contains("word"))
                                    icon = "fa-file-word text-info";

                                else if(type.contains("ppt")
                                        || type.contains("powerpoint"))
                                    icon = "fa-file-powerpoint text-warning";

                                else if(type.contains("zip")
                                        || type.contains("rar"))
                                    icon = "fa-file-zipper text-muted";

                                else if(type.contains("jpg")
                                        || type.contains("png")
                                        || type.contains("jpeg")
                                        || type.contains("gif")
                                        || type.contains("webp"))
                                    icon = "fa-file-image text-success";

                                else if(type.contains("mp4")
                                        || type.contains("mov")
                                        || type.contains("avi")
                                        || type.contains("mkv")
                                        || type.contains("webm")
                                        || type.contains("video"))
                                    icon = "fa-file-video text-primary";
                    %>

                    <!-- Single Resource -->
                    <div class="card" style="margin-bottom:0;">

                        <div class="card-body">

                            <div class="d-flex gap-2 mb-2">

                                <div style="font-size:32px;">

                                    <i class="fa-solid <%= icon %>"></i>

                                </div>

                                <div>

                                    <div class="fw-700"
                                         style="font-size:14px; color:var(--text);">

                                        <%= r.getTitle() %>

                                    </div>

                                    <div class="text-muted"
                                         style="font-size:11.5px;">

                                        By <%= r.getUploaderName() %>

                                        •

                                        <%= r.getCategory() %>

                                    </div>

                                </div>

                            </div>

                            <!-- Description -->
                            <p class="text-muted"
                               style="
                                    font-size:13px;
                                    margin-bottom:14px;
                                    line-height:1.5;
                                    display:-webkit-box;
                                    -webkit-line-clamp:2;
                                    -webkit-box-orient:vertical;
                                    overflow:hidden;
                               ">

                                <%= r.getDescription() %>

                            </p>

                            <!-- Download Button -->
                            <a href="${pageContext.request.contextPath}/download?id=<%= r.getResourceId() %>"
                               class="btn btn-outline btn-block btn-sm">

                                <i class="fa-solid fa-download"></i>

                                Download

                            </a>

                        </div>

                    </div>

                    <%
                            }

                        } else {
                    %>

                    <!-- Empty State -->
                    <div class="card"
                         style="
                            grid-column: 1 / -1;
                            text-align:center;
                            padding: 40px;
                         ">

                        <div style="
                            font-size:40px;
                            color:var(--card-border);
                            margin-bottom:14px;
                        ">

                            <i class="fa-solid fa-box-open"></i>

                        </div>

                        <h3>No Resources Yet</h3>

                        <p class="text-muted">
                            Be the first to share study materials with the campus.
                        </p>

                    </div>

                    <% } %>

                </div>

            </div>

        </div>

    </div>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>

</body>
</html>