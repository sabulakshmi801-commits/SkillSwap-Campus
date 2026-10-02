<%@ page import="java.util.List" %>
<%@ page import="model.Skill" %>
<%@ page import="utility.PhotoUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("pageTitle", "Explore Skills"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Skills - SkillSwap Campus</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-wrapper">
        <jsp:include page="sidebar.jsp"/>
        
        <div class="main-content">
            <jsp:include page="topbar.jsp"/>
            
            <div class="content-area">
                
                <div class="card">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/skills" method="GET" style="display:flex; gap:14px; flex-wrap:wrap;">
                            <div style="flex:1; min-width:200px;">
                                <input type="text" name="keyword" class="form-control" placeholder="Search skills, topics, or names..." value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
                            </div>
                            <div style="width:200px;">
                                <select name="category" class="form-control">
                                    <option value="">All Categories</option>
                                    <option value="Programming">Programming</option>
                                    <option value="Web Development">Web Development</option>
                                    <option value="AI & Data Science">AI & Data Science</option>
                                    <option value="Design">Design & UI/UX</option>
                                    <option value="Hardware">Hardware & IoT</option>
                                    <option value="Business">Business</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fa-solid fa-search"></i> Search</button>
                        </form>
                    </div>
                </div>

                <div class="grid grid-auto">
                    <% 
                    List<Skill> skills = (List<Skill>) request.getAttribute("skills");
                    model.User u = (model.User) session.getAttribute("loggedUser");
                    int shown = 0;
                    if(skills != null && !skills.isEmpty()) {
                        for(Skill s : skills) {
                            if(s.getUserId() == u.getUserId()) continue;
                            shown++;
                    %>
                        <div class="skill-card">
                            <div class="skill-header">
                                <a href="${pageContext.request.contextPath}/profile?id=<%= s.getUserId() %>" class="skill-avatar" style="text-decoration:none; color:#fff;">
                                    <% String sImg = PhotoUtil.getPhotoUrl(request.getContextPath(), s.getProfilePhoto()); %>
                                    <% if(sImg != null) { %>
                                        <img src="<%= sImg %>" alt="">
                                    <% } else { %>
                                        <%= s.getUserName().substring(0,1).toUpperCase() %>
                                    <% } %>
                                </a>
                                <div>
                                    <div class="skill-name"><%= s.getSkillName() %></div>
                                    <div class="skill-user">
                                        <a href="${pageContext.request.contextPath}/profile?id=<%= s.getUserId() %>" style="color:var(--text); font-weight:600;"><%= s.getUserName() %></a>
                                    </div>
                                    <div style="font-size:10.5px; color:var(--text-muted);"><i class="fa-solid fa-star text-warning"></i> <%= String.format("%.1f", s.getAvgRating()) %> • <%= s.getCategory() %></div>
                                </div>
                            </div>
                            <div class="skill-desc"><%= s.getDescription() %></div>
                            <div class="skill-footer mt-1">
                                <span class="badge badge-purple"><%= s.getExperienceLevel() %></span>
                                <span class="badge badge-gray"><i class="fa-regular fa-clock"></i> <%= s.getAvailability() %></span>
                                <a href="${pageContext.request.contextPath}/session?action=request&skillId=<%= s.getSkillId() %>" class="btn btn-primary btn-sm ml-auto" style="margin-left:auto; width:100%; margin-top:10px; justify-content:center;">Request Session</a>
                            </div>
                        </div>
                    <%  }
                        if (shown == 0) { %>
                        <div class="card" style="grid-column: 1 / -1; text-align:center; padding: 40px;">
                            <h3>No Other Skills Yet</h3>
                            <p class="text-muted">Skills from other campus members will appear here. Add yours on My Profile.</p>
                        </div>
                    <%  }
                    } else { %>
                        <div class="card" style="grid-column: 1 / -1; text-align:center; padding: 40px;">
                            <div style="font-size:40px; color:var(--card-border); margin-bottom:14px;"><i class="fa-solid fa-folder-open"></i></div>
                            <h3>No Skills Found</h3>
                            <p class="text-muted">Try adjusting your search criteria.</p>
                        </div>
                    <% } %>
                </div>

            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
