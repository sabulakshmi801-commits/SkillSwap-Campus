<%@ page import="java.util.List" %>
<%@ page import="model.LearningSession" %>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if(session == null || session.getAttribute("loggedUser") == null){
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

User loggedUser = (User) session.getAttribute("loggedUser");

if(!"admin".equals(loggedUser.getRole())){
    response.sendRedirect(request.getContextPath() + "/dashboard");
    return;
}

request.setAttribute("pageTitle", "All Sessions (Admin)");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>All Sessions - Admin</title>

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

            <div class="card">

                <div class="card-header">

                    <span class="card-title">
                        Platform Learning Sessions
                    </span>

                </div>

                <div class="card-body" style="padding:0;">

                    <div class="table-wrap">

                        <table class="table">

                            <thead>

                            <tr>

                                <th>Skill / Topic</th>

                                <th>Mentor</th>

                                <th>Learner</th>

                                <th>Date & Time</th>

                                <th>Mode</th>

                                <th>Status</th>

                            </tr>

                            </thead>

                            <tbody>

                            <%
                            List<LearningSession> sessions =
                                    (List<LearningSession>) request.getAttribute("allSessions");

                            if(sessions != null && !sessions.isEmpty()) {

                                for(LearningSession s : sessions) {
                            %>

                            <tr>

                                <td class="fw-600">
                                    <%= s.getSkillName() %>
                                </td>

                                <td>
                                    <%= s.getMentorName() %>
                                </td>

                                <td>
                                    <%= s.getLearnerName() %>
                                </td>

                                <td>

                                    <%= s.getSessionDate() %>

                                    <span class="text-muted"
                                          style="font-size:12px;">

                                        <%= s.getSessionTime() %>

                                    </span>

                                </td>

                                <td>

                                    <span class="badge badge-gray">
                                        <%= s.getSessionMode() %>
                                    </span>

                                </td>

                                <td class="status-<%= s.getStatus().toLowerCase() %>">

                                    <%= s.getStatus() %>

                                </td>

                            </tr>

                            <%
                                }

                            } else {
                            %>

                            <tr>

                                <td colspan="6"
                                    class="text-center text-muted">

                                    No sessions recorded yet.

                                </td>

                            </tr>

                            <% } %>

                            </tbody>

                        </table>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>

</body>
</html>