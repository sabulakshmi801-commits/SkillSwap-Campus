<%@ page import="utility.PhotoUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="fa-solid fa-graduation-cap"></i></div>
        <div>
            <div class="brand-name">SkillSwap</div>
            <div class="brand-sub">Campus</div>
        </div>
    </div>
    
    <div class="sidebar-nav">
        <% String r = (String) session.getAttribute("userRole"); %>
        
        <div class="nav-section">
            <div class="nav-section-title">Menu</div>
            <% if("admin".equals(r)) { %>
                <a href="${pageContext.request.contextPath}/admin" class="nav-item">
                    <i class="fa-solid fa-chart-pie nav-icon"></i> Admin Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin?action=users" class="nav-item">
                    <i class="fa-solid fa-users-gear nav-icon"></i> Manage Users
                </a>
                <a href="${pageContext.request.contextPath}/admin?action=sessions" class="nav-item">
                    <i class="fa-solid fa-calendar-check nav-icon"></i> All Sessions
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="nav-item">
                    <i class="fa-solid fa-user nav-icon"></i> My Profile
                </a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/dashboard" class="nav-item">
                    <i class="fa-solid fa-house nav-icon"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/skills" class="nav-item">
                    <i class="fa-solid fa-magnifying-glass nav-icon"></i> Explore Skills
                </a>
                <a href="${pageContext.request.contextPath}/session" class="nav-item">
                    <i class="fa-solid fa-calendar-day nav-icon"></i> My Sessions
                </a>
                <a href="${pageContext.request.contextPath}/upload" class="nav-item">
                    <i class="fa-solid fa-folder-open nav-icon"></i> Resources
                </a>
                <a href="${pageContext.request.contextPath}/chat" class="nav-item">
                    <i class="fa-solid fa-message nav-icon"></i> Chat
                </a>
                <a href="${pageContext.request.contextPath}/notifications" class="nav-item">
                    <i class="fa-solid fa-bell nav-icon"></i> Notifications
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="nav-item">
                    <i class="fa-solid fa-user nav-icon"></i> My Profile
                </a>
            <% } %>
        </div>
    </div>
    
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="user-avatar" style="width:34px; height:34px; font-size:12px;">
                <% model.User s_usr = (model.User) session.getAttribute("loggedUser"); %>
                <% String sideImg = PhotoUtil.getPhotoUrl(request.getContextPath(), s_usr.getProfilePhoto()); %>
                <% if(sideImg != null) { %>
                    <img src="<%= sideImg %>" alt="User">
                <% } else { %>
                    <%= s_usr.getName().substring(0,1).toUpperCase() %>
                <% } %>
            </div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name"><%= s_usr.getName() %></div>
                <div class="sidebar-user-role"><%= s_usr.getRole() %></div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" style="color:var(--danger);" title="Logout">
                <i class="fa-solid fa-right-from-bracket"></i>
            </a>
        </div>
    </div>
</div>
