<%@ page import="model.Skill" %>
<%@ page import="utility.PhotoUtil" %>
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

    request.setAttribute("pageTitle", "Request Session");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Request Session - SkillSwap Campus</title>

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

                <%
                    Skill skill = (Skill) request.getAttribute("skill");

                    if(skill == null){
                        response.sendRedirect(request.getContextPath() + "/skills");
                        return;
                    }
                %>

                <div class="card" style="max-width: 600px; margin: 0 auto;">

                    <div class="card-header">
                        <span class="card-title">Request Session</span>
                    </div>

                    <div class="card-body">

                        <!-- Skill Info -->
                        <div style="
                            background: var(--bg);
                            padding: 14px;
                            border-radius: 10px;
                            margin-bottom: 24px;
                            display:flex;
                            align-items:center;
                            gap:14px;
                        ">

                            <div class="user-avatar"
                                 style="width:46px; height:46px; font-size:18px;">

                                <%
                                    String mentorImg =
                                            PhotoUtil.getPhotoUrl(
                                                    request.getContextPath(),
                                                    skill.getProfilePhoto()
                                            );

                                    if(mentorImg != null){
                                %>

                                    <img src="<%= mentorImg %>" alt="">

                                <%
                                    } else {
                                %>

                                    <%= skill.getUserName()
                                            .substring(0,1)
                                            .toUpperCase() %>

                                <%
                                    }
                                %>

                            </div>

                            <div>
                                <div style="
                                    font-size:15px;
                                    font-weight:700;
                                    color:var(--text);
                                ">
                                    <%= skill.getSkillName() %>
                                </div>

                                <div style="
                                    font-size:12px;
                                    color:var(--text-muted);
                                ">
                                    Mentor:
                                    <%= skill.getUserName() %>
                                    (<%= skill.getAvailability() %>)
                                </div>
                            </div>
                        </div>

                        <!-- Error Message -->
                        <% if(request.getAttribute("error") != null){ %>

                            <div class="alert alert-danger">
                                <%= request.getAttribute("error") %>
                            </div>

                        <% } %>

                        <!-- Request Form -->
                        <form action="${pageContext.request.contextPath}/session"
                              method="post">

                            <input type="hidden"
                                   name="mentorId"
                                   value="<%= skill.getUserId() %>">

                            <input type="hidden"
                                   name="skillId"
                                   value="<%= skill.getSkillId() %>">

                            <input type="hidden"
                                   name="skillName"
                                   value="<%= skill.getSkillName() %>">

                            <!-- Date and Time -->
                            <div class="grid grid-2">

                                <div class="form-group">
                                    <label class="form-label">
                                        Preferred Date
                                    </label>

                                    <input type="date"
                                           name="sessionDate"
                                           class="form-control"
                                           required
                                           min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd")
                                                   .format(new java.util.Date()) %>">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        Preferred Time
                                    </label>

                                    <input type="time"
                                           name="sessionTime"
                                           class="form-control"
                                           required>
                                </div>

                            </div>

                            <!-- Session Type -->
                            <div class="grid grid-2">

                                <div class="form-group">

                                    <label class="form-label">
                                        Session Type
                                    </label>

                                    <select name="sessionType"
                                            class="form-control">

                                        <option value="One-to-One">
                                            One-to-One
                                        </option>

                                        <option value="Mentorship">
                                            Mentorship Guidance
                                        </option>

                                    </select>

                                </div>

                                <div class="form-group">

                                    <label class="form-label">
                                        Mode
                                    </label>

                                    <select name="sessionMode"
                                            class="form-control">

                                        <option value="Online">
                                            Online (Virtual)
                                        </option>

                                        <option value="Offline">
                                            Offline (Campus)
                                        </option>

                                    </select>

                                </div>

                            </div>

                            <!-- Notes -->
                            <div class="form-group">

                                <label class="form-label">
                                    What do you want to learn?
                                    (Notes for Mentor)
                                </label>

                                <textarea name="notes"
                                          class="form-control"
                                          placeholder="E.g. I need help understanding React Hooks..."></textarea>

                            </div>

                            <!-- Buttons -->
                            <div class="d-flex justify-between mt-3">

                                <a href="javascript:history.back()"
                                   class="btn btn-outline">
                                    Cancel
                                </a>

                                <button type="submit"
                                        class="btn btn-primary">

                                    Send Request

                                    <i class="fa-solid fa-paper-plane"
                                       style="margin-left:6px;"></i>

                                </button>

                            </div>

                        </form>

                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>

</body>
</html>