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

request.setAttribute("pageTitle", "Dashboard");

User user = (User) session.getAttribute("loggedUser");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - SkillSwap Campus</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<div class="app-wrapper">

    <jsp:include page="sidebar.jsp"/>

    <div class="main-content">

        <jsp:include page="topbar.jsp"/>

        <div class="content-area">

            <h2 style="font-size:22px; font-weight:800; margin-bottom:24px;">
                Welcome back,
                <%= user.getName().split(" ")[0] %>! 👋
            </h2>

            <div class="grid grid-3 mb-3">

                <div class="stat-card">
                    <div class="stat-icon blue">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>

                    <div>
                        <div class="stat-value">
                            <%= user.getTotalSessions() %>
                        </div>

                        <div class="stat-label">
                            Completed Sessions
                        </div>
                    </div>
                </div>

                <div class="stat-card">

                    <div class="stat-icon orange">
                        <i class="fa-solid fa-star"></i>
                    </div>

                    <div>
                        <div class="stat-value">
                            <%= String.format("%.1f", user.getAvgRating()) %>
                        </div>

                        <div class="stat-label">
                            Average Rating
                        </div>
                    </div>
                </div>

                <div class="stat-card">

                    <div class="stat-icon pink">
                        <i class="fa-solid fa-bolt"></i>
                    </div>

                    <div>
                        <div class="stat-value">
                            Top
                        </div>

                        <div class="stat-label">
                            Contributor Tier
                        </div>
                    </div>
                </div>

            </div>

            <div class="grid"
                 style="grid-template-columns: 2fr 1fr; gap:20px;">

                <!-- LEFT COLUMN -->

                <div>

                    <div class="card">

                        <div class="card-header">

                            <span class="card-title">
                                Explore Skills
                            </span>

                            <a href="${pageContext.request.contextPath}/skills"
                               class="btn btn-outline btn-sm">
                                View All
                            </a>

                        </div>

                        <div class="card-body">

                            <div class="grid grid-2">

                                <%
                                List<Skill> allSkills =
                                        (List<Skill>) request.getAttribute("allSkills");

                                if(allSkills != null && !allSkills.isEmpty()) {

                                    int count = 0;

                                    for(Skill s : allSkills) {

                                        if(count >= 4) break;
                                %>

                                <div class="skill-card">

                                    <div class="skill-header">

                                        <div class="skill-avatar">

                                            <%
                                            String skImg =
                                                    PhotoUtil.getPhotoUrl(
                                                            request.getContextPath(),
                                                            s.getProfilePhoto());
                                            %>

                                            <% if(skImg != null) { %>

                                            <img src="<%= skImg %>" alt="">

                                            <% } else { %>

                                            <%= s.getUserName()
                                                    .substring(0,1)
                                                    .toUpperCase() %>

                                            <% } %>

                                        </div>

                                        <div>

                                            <div class="skill-name">
                                                <%= s.getSkillName() %>
                                            </div>

                                            <div class="skill-user">
                                                <%= s.getUserName() %>
                                                •
                                                <%= s.getCategory() %>
                                            </div>

                                        </div>

                                    </div>

                                    <div class="skill-desc">
                                        <%= s.getDescription() %>
                                    </div>

                                    <div class="skill-footer mt-1">

                                        <span class="badge badge-purple">
                                            <%= s.getExperienceLevel() %>
                                        </span>

                                        <a href="${pageContext.request.contextPath}/session?action=request&skillId=<%= s.getSkillId() %>"
                                           class="btn btn-primary btn-sm ml-auto"
                                           style="margin-left:auto;">
                                            Request
                                        </a>

                                    </div>

                                </div>

                                <%
                                        count++;
                                    }

                                } else {
                                %>

                                <p class="text-muted">
                                    No skills available to explore yet.
                                </p>

                                <% } %>

                            </div>

                        </div>

                    </div>

                </div>

                <!-- RIGHT COLUMN -->

                <div>

                    <div class="card">

                        <div class="card-header">

                            <span class="card-title">
                                Trending Now
                            </span>

                        </div>

                        <div class="card-body">

                            <%
                            List<String> trending =
                                    (List<String>) request.getAttribute("trendingSkills");

                            if(trending != null && !trending.isEmpty()) {

                                for(String t : trending) {
                            %>

                            <a href="${pageContext.request.contextPath}/skills?keyword=<%= t %>"
                               class="d-flex align-center justify-between mb-2 p-1"
                               style="border-bottom:1px solid var(--card-border);">

                                <span class="fw-600">

                                    <i class="fa-solid fa-arrow-trend-up text-accent"
                                       style="margin-right:8px;"></i>

                                    <%= t %>

                                </span>

                            </a>

                            <%
                                }

                            } else {
                            %>

                            <p class="text-muted">
                                No trending data.
                            </p>

                            <% } %>

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