<%@ page import="java.util.List" %>
<%@ page import="model.*" %>
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

request.setAttribute("pageTitle", "Notifications");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Notifications - SkillSwap Campus</title>

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

            <% String ctx = request.getContextPath(); %>

            <% if(request.getParameter("success") != null) { %>

            <div class="alert alert-success">

                <i class="fa-solid fa-circle-check"></i>

                <%= request.getParameter("success") %>

            </div>

            <% } %>

            <% if(request.getParameter("error") != null) { %>

            <div class="alert alert-danger">

                <%= request.getParameter("error") %>

            </div>

            <% } %>

            <div class="notif-page-grid">

                <!-- PEER SESSION REQUESTS -->

                <div class="card notif-section-card">

                    <div class="card-header">

                        <span class="card-title">

                            <i class="fa-solid fa-calendar-check"
                               style="color:var(--success);
                               margin-right:6px;"></i>

                            Peer Session Requests

                        </span>

                    </div>

                    <div class="card-body notif-section-body">

                        <%
                        List<LearningSession> sessionRequests =
                                (List<LearningSession>)
                                        request.getAttribute("sessionRequests");

                        if(sessionRequests != null &&
                                !sessionRequests.isEmpty()) {

                            for(LearningSession s : sessionRequests) {

                                String learnerPhotoUrl =
                                        PhotoUtil.getPhotoUrl(
                                                ctx,
                                                s.getLearnerPhoto());
                        %>

                        <div class="session-req-card">

                            <div class="session-req-header">

                                <div class="user-avatar"
                                     style="width:44px; height:44px;">

                                    <% if(learnerPhotoUrl != null) { %>

                                    <img src="<%= learnerPhotoUrl %>" alt="">

                                    <% } else { %>

                                    <%= s.getLearnerName()
                                            .substring(0,1)
                                            .toUpperCase() %>

                                    <% } %>

                                </div>

                                <div>

                                    <div class="fw-700"
                                         style="font-size:14px;">

                                        <%= s.getLearnerName() %>

                                    </div>

                                    <div class="text-muted"
                                         style="font-size:12px;">

                                        wants to learn:

                                        <strong>
                                            <%= s.getSkillName() %>
                                        </strong>

                                    </div>

                                </div>

                            </div>

                            <div class="session-req-meta">

                                <span class="badge badge-purple">

                                    <i class="fa-solid fa-book"></i>

                                    <%= s.getSkillName() %>

                                </span>

                                <span class="badge badge-gray">

                                    <i class="fa-regular fa-calendar"></i>

                                    <%= s.getSessionDate() %>

                                    <%= s.getSessionTime() != null
                                            ? s.getSessionTime()
                                            : "" %>

                                </span>

                                <span class="badge badge-gray">

                                    <%= s.getSessionMode() %>

                                    •

                                    <%= s.getSessionType() %>

                                </span>

                            </div>

                            <div class="form-group"
                                 style="margin-bottom:14px;">

                                <label class="form-label">

                                    Learner's message / description

                                </label>

                                <div class="session-desc-box">

                                    <%= s.getNotes() != null &&
                                            !s.getNotes().isEmpty()
                                            ? s.getNotes()
                                            : "No additional notes provided." %>

                                </div>

                            </div>

                            <form action="<%= ctx %>/notifications"
                                  method="post"
                                  class="session-response-form">

                                <input type="hidden"
                                       name="sessionId"
                                       value="<%= s.getSessionId() %>">

                                <div class="form-group"
                                     style="margin-bottom:12px;">

                                    <label class="form-label">

                                        Your response to learner

                                    </label>

                                    <textarea name="responseReason"
                                              class="form-control"
                                              rows="2"
                                              placeholder="Message sent to the requester when you accept or reject"></textarea>

                                </div>

                                <div class="d-flex gap-1">

                                    <button type="submit"
                                            name="action"
                                            value="acceptSession"
                                            class="btn btn-primary"
                                            style="flex:1;">

                                        <i class="fa-solid fa-check"></i>

                                        Accept Session

                                    </button>

                                    <button type="submit"
                                            name="action"
                                            value="rejectSession"
                                            class="btn btn-outline"
                                            style="flex:1;"
                                            onclick="return confirmReject(this.form);">

                                        <i class="fa-solid fa-xmark"></i>

                                        Reject

                                    </button>

                                </div>

                            </form>

                        </div>

                        <%
                            }

                        } else {
                        %>

                        <div class="notif-empty">

                            <i class="fa-regular fa-calendar"></i>

                            <p>No pending session requests.</p>

                        </div>

                        <% } %>

                    </div>

                </div>

                <!-- CHAT NOTIFICATIONS -->

                <div class="card notif-section-card">

                    <div class="card-header">

                        <span class="card-title">

                            <i class="fa-solid fa-comment-dots"
                               style="color:var(--accent);
                               margin-right:6px;"></i>

                            Chat Alerts

                        </span>

                    </div>

                    <div class="card-body notif-section-body">

                        <%
                        List<Notification> chatNotifs =
                                (List<Notification>)
                                        request.getAttribute("chatNotifications");

                        if(chatNotifs != null &&
                                !chatNotifs.isEmpty()) {

                            for(Notification n : chatNotifs) {

                                int senderId =
                                        n.getReferenceId();

                                String chatLink =
                                        senderId > 0
                                                ? ctx + "/chat?with=" + senderId
                                                : ctx + "/chat";

                                String displayMsg =
                                        n.getMessage();

                                if(displayMsg != null &&
                                        displayMsg.startsWith("REF:")) {

                                    int pipe =
                                            displayMsg.indexOf('|');

                                    if(pipe > 0) {

                                        displayMsg =
                                                displayMsg.substring(pipe + 1);
                                    }
                                }
                        %>

                        <a href="<%= chatLink %>"
                           class="chat-notif-item">

                            <div class="notif-type-icon">

                                <i class="fa-solid fa-comment text-primary"></i>

                            </div>

                            <div class="notif-content">

                                <div class="fw-700"
                                     style="font-size:14px;">

                                    <%= n.getTitle() %>

                                </div>

                                <div class="notif-msg">

                                    <%= displayMsg %>

                                </div>

                                <div class="notif-time">

                                    <%= n.getCreatedAt() %>

                                    <span class="text-accent"
                                          style="font-weight:600;">

                                        Tap to open chat →

                                    </span>

                                </div>

                            </div>

                            <i class="fa-solid fa-chevron-right"
                               style="
                               color:var(--text-muted);
                               font-size:12px;"></i>

                        </a>

                        <%
                            }

                        } else {
                        %>

                        <div class="notif-empty">

                            <i class="fa-regular fa-comment"></i>

                            <p>No chat notifications yet.</p>

                        </div>

                        <% } %>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>

<script>

function confirmReject(form) {

    var reason =
            form.responseReason.value.trim();

    if(!reason) {

        alert('Please enter a reason for the learner before rejecting.');

        form.responseReason.focus();

        return false;
    }

    return confirm('Reject this session request?');
}

</script>

</body>
</html>