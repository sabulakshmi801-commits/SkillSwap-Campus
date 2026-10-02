<%@ page import="java.util.*" %>
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

request.setAttribute("pageTitle", "Admin Dashboard");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Admin Dashboard - SkillSwap Campus</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

</head>

<body>

<div class="app-wrapper">

    <jsp:include page="sidebar.jsp"/>

    <div class="main-content">

        <jsp:include page="topbar.jsp"/>

        <div class="content-area">

            <%
            Map<String, Integer> stats =
                    (Map<String, Integer>) request.getAttribute("analytics");
            %>

            <h2 style="font-size:20px;
                       font-weight:800;
                       margin-bottom:20px;">

                System Overview

            </h2>

            <div class="grid grid-4 mb-3">

                <div class="stat-card">

                    <div class="stat-icon blue">
                        <i class="fa-solid fa-users"></i>
                    </div>

                    <div>

                        <div class="stat-value">
                            <%= stats.get("totalUsers") %>
                        </div>

                        <div class="stat-label">
                            Total Users
                        </div>

                    </div>

                </div>

                <div class="stat-card">

                    <div class="stat-icon purple">
                        <i class="fa-solid fa-graduation-cap"></i>
                    </div>

                    <div>

                        <div class="stat-value">
                            <%= stats.get("totalSkills") %>
                        </div>

                        <div class="stat-label">
                            Skills Offered
                        </div>

                    </div>

                </div>

                <div class="stat-card">

                    <div class="stat-icon green">
                        <i class="fa-solid fa-handshake"></i>
                    </div>

                    <div>

                        <div class="stat-value">
                            <%= stats.get("completedSessions") %>
                        </div>

                        <div class="stat-label">
                            Completed Sessions
                        </div>

                    </div>

                </div>

                <div class="stat-card">

                    <div class="stat-icon cyan">
                        <i class="fa-solid fa-book"></i>
                    </div>

                    <div>

                        <div class="stat-value">
                            <%= stats.get("totalResources") %>
                        </div>

                        <div class="stat-label">
                            Resources Shared
                        </div>

                    </div>

                </div>

            </div>

            <div class="grid grid-2">

                <div class="card">

                    <div class="card-header">

                        <span class="card-title">
                            User Demographics (Departments)
                        </span>

                    </div>

                    <div class="card-body">

                        <div class="chart-container">
                            <canvas id="deptChart"></canvas>
                        </div>

                    </div>

                </div>

                <div class="card">

                    <div class="card-header">

                        <span class="card-title">
                            Popular Skills (Requested)
                        </span>

                    </div>

                    <div class="card-body">

                        <div class="chart-container">
                            <canvas id="skillChart"></canvas>
                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>

<%
List<Map<String, String>> depts =
        (List<Map<String, String>>) request.getAttribute("deptStats");

List<Map<String, String>> skills =
        (List<Map<String, String>>) request.getAttribute("popularSkills");

StringBuilder dLabels = new StringBuilder();
StringBuilder dData = new StringBuilder();

if(depts != null){

    for(Map<String, String> m : depts){

        dLabels.append("'")
               .append(m.get("department"))
               .append("',");

        dData.append(m.get("count"))
             .append(",");
    }
}

StringBuilder sLabels = new StringBuilder();
StringBuilder sData = new StringBuilder();

if(skills != null){

    for(Map<String, String> m : skills){

        sLabels.append("'")
               .append(m.get("skill"))
               .append("',");

        sData.append(m.get("count"))
             .append(",");
    }
}
%>

<script>

    // Department Chart

    new Chart(document.getElementById('deptChart'), {

        type: 'doughnut',

        data: {

            labels: [<%= dLabels.toString() %>],

            datasets: [{

                data: [<%= dData.toString() %>],

                backgroundColor: [
                    '#4f46e5',
                    '#ec4899',
                    '#06b6d4',
                    '#f59e0b',
                    '#10b981',
                    '#8b5cf6'
                ]

            }]
        },

        options: {

            responsive: true,

            maintainAspectRatio: false,

            plugins: {

                legend: {

                    position: 'right'

                }
            }
        }
    });

    // Skills Chart

    new Chart(document.getElementById('skillChart'), {

        type: 'bar',

        data: {

            labels: [<%= sLabels.toString() %>],

            datasets: [{

                label: 'Session Requests',

                data: [<%= sData.toString() %>],

                backgroundColor: '#4f46e5',

                borderRadius: 6

            }]
        },

        options: {

            responsive: true,

            maintainAspectRatio: false,

            scales: {

                y: {

                    beginAtZero: true

                }
            }
        }
    });

</script>

<script src="${pageContext.request.contextPath}/js/app.js"></script>

</body>
</html>