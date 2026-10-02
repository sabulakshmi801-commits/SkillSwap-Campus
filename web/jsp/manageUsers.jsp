<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="utility.PhotoUtil" %>
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

request.setAttribute("pageTitle", "Manage Users");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Manage Users - Admin</title>

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
                        Registered Users
                    </span>

                </div>

                <div class="card-body"
                     style="padding:0;">

                    <div class="table-wrap">

                        <table class="table">

                            <thead>

                            <tr>

                                <th>Name</th>

                                <th>Email</th>

                                <th>Role</th>

                                <th>Department</th>

                                <th>Status</th>

                                <th>Actions</th>

                            </tr>

                            </thead>

                            <tbody>

                            <%
                            List<User> users =
                                    (List<User>) request.getAttribute("users");

                            if(users != null && !users.isEmpty()) {

                                for(User u : users) {
                            %>

                            <tr>

                                <td class="fw-600">

                                    <div class="d-flex align-center gap-1">

                                        <div class="user-avatar"
                                             style="
                                             width:28px;
                                             height:28px;
                                             font-size:12px;">

                                            <%
                                            String admImg =
                                                    PhotoUtil.getPhotoUrl(
                                                            request.getContextPath(),
                                                            u.getProfilePhoto());
                                            %>

                                            <% if(admImg != null) { %>

                                            <img src="<%= admImg %>" alt="">

                                            <% } else { %>

                                            <%= u.getName()
                                                    .substring(0,1)
                                                    .toUpperCase() %>

                                            <% } %>

                                        </div>

                                        <%= u.getName() %>

                                    </div>

                                </td>

                                <td>
                                    <%= u.getEmail() %>
                                </td>

                                <td>

                                    <span class="badge badge-gray"
                                          style="text-transform:capitalize;">

                                        <%= u.getRole() %>

                                    </span>

                                </td>

                                <td>
                                    <%= u.getDepartment() %>
                                </td>

                                <td>

                                    <% if(u.isActive()) { %>

                                    <span class="badge badge-success">
                                        Active
                                    </span>

                                    <% } else { %>

                                    <span class="badge badge-danger">
                                        Inactive
                                    </span>

                                    <% } %>

                                </td>

                                <td>

                                    <div class="d-flex gap-1">

                                        <% if(u.isActive()) { %>

                                        <a href="admin?action=toggleUser&userId=<%= u.getUserId() %>&activate=false"
                                           class="btn btn-warning btn-sm"
                                           title="Deactivate">

                                            <i class="fa-solid fa-ban"></i>

                                        </a>

                                        <% } else { %>

                                        <a href="admin?action=toggleUser&userId=<%= u.getUserId() %>&activate=true"
                                           class="btn btn-success btn-sm"
                                           title="Activate">

                                            <i class="fa-solid fa-check"></i>

                                        </a>

                                        <% } %>

                                        <a href="admin?action=deleteUser&userId=<%= u.getUserId() %>"
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Delete this user permanently?')"
                                           title="Delete">

                                            <i class="fa-solid fa-trash"></i>

                                        </a>

                                    </div>

                                </td>

                            </tr>

                            <%
                                }

                            } else {
                            %>

                            <tr>

                                <td colspan="6"
                                    class="text-center text-muted">

                                    No users found.

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