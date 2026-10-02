<%@ page import="java.util.List" %>
<%@ page import="model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if(session == null || session.getAttribute("loggedUser") == null){
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

User me = (User) session.getAttribute("loggedUser");

request.setAttribute("pageTitle", "My Sessions");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>My Sessions - SkillSwap Campus</title>

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

            <% if(request.getParameter("success") != null) { %>

            <div class="alert alert-success">

                <i class="fa-solid fa-circle-check"></i>

                <%= request.getParameter("success") %>

            </div>

            <% } %>

            <div class="card">

                <div class="card-body">

                    <div class="tab-nav">

                        <button class="tab-btn active"
                                data-target="asLearner">

                            Learning Sessions

                        </button>

                        <button class="tab-btn"
                                data-target="asMentor">

                            Mentoring Sessions

                        </button>

                    </div>

                    <%
                    List<LearningSession> sessions =
                            (List<LearningSession>)
                                    request.getAttribute("sessions");
                    %>

                    <!-- LEARNING SESSIONS -->

                    <div id="asLearner"
                         class="tab-content active">

                        <div class="table-wrap">

                            <table class="table">

                                <thead>

                                <tr>

                                    <th>Skill / Topic</th>

                                    <th>Mentor</th>

                                    <th>Date & Time</th>

                                    <th>Mode</th>

                                    <th>Status</th>

                                    <th>Action</th>

                                </tr>

                                </thead>

                                <tbody>

                                <%
                                boolean hasL = false;

                                if(sessions != null) {

                                    for(LearningSession s : sessions) {

                                        if(s.getLearnerId()
                                                == me.getUserId()) {

                                            hasL = true;
                                %>

                                <tr>

                                    <td class="fw-600">

                                        <%= s.getSkillName() %>

                                    </td>

                                    <td>

                                        <a href="${pageContext.request.contextPath}/profile?id=<%= s.getMentorId() %>"
                                           style="color:var(--accent);
                                           font-weight:600;">

                                            <%= s.getMentorName() %>

                                        </a>

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

                                    <td>

                                        <div class="d-flex gap-1">

                                            <% if("Accepted".equals(s.getStatus())) { %>

                                            <a href="session?action=complete&id=<%= s.getSessionId() %>"
                                               class="btn btn-success btn-sm"
                                               title="Mark Completed">

                                                <i class="fa-solid fa-check-double"></i>

                                            </a>

                                            <% } else if("Pending".equals(s.getStatus())) { %>

                                            <a href="session?action=cancel&id=<%= s.getSessionId() %>"
                                               class="btn btn-danger btn-sm"
                                               onclick="return confirm('Cancel request?')"
                                               title="Cancel">

                                                <i class="fa-solid fa-xmark"></i>

                                            </a>

                                            <% } else if("Completed".equals(s.getStatus())) { %>

                                            <a href="feedback?sessionId=<%= s.getSessionId() %>"
                                               class="btn btn-outline btn-sm">

                                                Rate Mentor

                                            </a>

                                            <% } %>

                                            <a href="chat?with=<%= s.getMentorId() %>"
                                               class="btn btn-outline btn-sm"
                                               title="Message">

                                                <i class="fa-regular fa-comment"></i>

                                            </a>

                                        </div>

                                    </td>

                                </tr>

                                <%
                                        }
                                    }
                                }

                                if(!hasL) {
                                    out.print("<tr><td colspan='6' class='text-center text-muted'>No learning sessions found.</td></tr>");
                                }
                                %>

                                </tbody>

                            </table>

                        </div>

                    </div>

                    <!-- MENTORING SESSIONS -->

                    <div id="asMentor"
                         class="tab-content">

                        <div class="table-wrap">

                            <table class="table">

                                <thead>

                                <tr>

                                    <th>Skill / Topic</th>

                                    <th>Learner</th>

                                    <th>Date & Time</th>

                                    <th>Mode</th>

                                    <th>Status</th>

                                    <th>Action</th>

                                </tr>

                                </thead>

                                <tbody>

                                <%
                                boolean hasM = false;

                                if(sessions != null) {

                                    for(LearningSession s : sessions) {

                                        if(s.getMentorId()
                                                == me.getUserId()) {

                                            hasM = true;
                                %>

                                <tr>

                                    <td class="fw-600">

                                        <%= s.getSkillName() %>

                                    </td>

                                    <td>

                                        <a href="${pageContext.request.contextPath}/profile?id=<%= s.getLearnerId() %>"
                                           style="color:var(--accent);
                                           font-weight:600;">

                                            <%= s.getLearnerName() %>

                                        </a>

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

                                    <td>

                                        <div class="d-flex gap-1">

                                            <% if("Pending".equals(s.getStatus())) { %>

                                            <a href="session?action=accept&id=<%= s.getSessionId() %>"
                                               class="btn btn-success btn-sm">

                                                <i class="fa-solid fa-check"></i>

                                                Accept

                                            </a>

                                            <a href="session?action=reject&id=<%= s.getSessionId() %>"
                                               class="btn btn-danger btn-sm">

                                                <i class="fa-solid fa-xmark"></i>

                                            </a>

                                            <% } else if("Accepted".equals(s.getStatus())) { %>

                                            <a href="session?action=complete&id=<%= s.getSessionId() %>"
                                               class="btn btn-primary btn-sm">

                                                <i class="fa-solid fa-flag-checkered"></i>

                                                Complete

                                            </a>

                                            <% } else if("Completed".equals(s.getStatus())) { %>

                                            <a href="feedback?sessionId=<%= s.getSessionId() %>"
                                               class="btn btn-outline btn-sm">

                                                Rate Learner

                                            </a>

                                            <% } %>

                                            <a href="chat?with=<%= s.getLearnerId() %>"
                                               class="btn btn-outline btn-sm"
                                               title="Message">

                                                <i class="fa-regular fa-comment"></i>

                                            </a>

                                        </div>

                                    </td>

                                </tr>

                                <%
                                        }
                                    }
                                }

                                if(!hasM) {
                                    out.print("<tr><td colspan='6' class='text-center text-muted'>No mentoring sessions found.</td></tr>");
                                }
                                %>

                                </tbody>

                            </table>

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>

</body>
</html>