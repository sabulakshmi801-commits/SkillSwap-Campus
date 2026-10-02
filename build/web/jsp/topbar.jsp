<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="topbar">
    <button class="btn btn-outline" id="sidebarToggle" style="border:none; font-size:18px; padding:4px 8px; display:none;">
        <i class="fa-solid fa-bars"></i>
    </button>
    <div class="topbar-title">
        <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "SkillSwap" %>
    </div>
    <div class="topbar-actions">
        <% if(!"admin".equals(session.getAttribute("userRole"))) { %>
            <a href="${pageContext.request.contextPath}/notifications" class="btn btn-outline" style="border:none; font-size:18px; position:relative; padding:6px 10px;">
                <i class="fa-regular fa-bell"></i>
                <% Integer unread = (Integer) request.getAttribute("unreadNotif"); 
                   if(unread != null && unread > 0) { %>
                    <span style="position:absolute; top:2px; right:4px; background:var(--danger); color:#fff; font-size:9px; font-weight:bold; padding:2px 5px; border-radius:10px;">
                        <%= unread %>
                    </span>
                <% } %>
            </a>
        <% } %>
    </div>
</div>
