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

User me = (User) session.getAttribute("loggedUser");

request.setAttribute("pageTitle", "Messages");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Chat - SkillSwap Campus</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

</head>

<body data-userid="<%= me.getUserId() %>">

<div class="app-wrapper">

    <jsp:include page="sidebar.jsp"/>

    <div class="main-content"
         style="height: 100vh; overflow: hidden;">

        <jsp:include page="topbar.jsp"/>

        <div class="content-area"
             style="padding: 20px;">

            <div class="chat-layout">

                <!-- CONTACTS PANEL -->

                <div class="chat-contacts">

                    <div class="chat-contacts-header">

                        <h4 style="display:flex;
                                   justify-content:space-between;
                                   align-items:center;">

                            Conversations

                            <button id="btnBackContacts"
                                    class="btn btn-outline btn-sm hidden"
                                    style="border:none;">

                                <i class="fa-solid fa-xmark"></i>

                            </button>

                        </h4>

                        <select id="newChatSelect"
                                class="new-chat-select">

                            <option value="">
                                + Start new chat...
                            </option>

                            <%
                            List<User> allU =
                                    (List<User>) request.getAttribute("allUsers");

                            if(allU != null) {

                                for(User u : allU) {

                                    if(u.getUserId() == me.getUserId())
                                        continue;
                            %>

                            <option value="<%= u.getUserId() %>">

                                <%= u.getName() %>
                                (<%= u.getRole() %>)

                            </option>

                            <%
                                }
                            }
                            %>

                        </select>

                    </div>

                    <div class="contacts-list">

                        <%
                        List<User> contacts =
                                (List<User>) request.getAttribute("contacts");

                        User chatWith =
                                (User) request.getAttribute("chatWith");

                        if(contacts != null) {

                            for(User c : contacts) {

                                boolean isActive =
                                        (chatWith != null &&
                                         chatWith.getUserId() == c.getUserId());
                        %>

                        <div class="contact-item <%= isActive ? "active" : "" %>"
                             onclick="window.location.href='chat?with=<%= c.getUserId() %>'">

                            <div class="user-avatar">

                                <%
                                String cImg =
                                        PhotoUtil.getPhotoUrl(
                                                request.getContextPath(),
                                                c.getProfilePhoto());
                                %>

                                <% if(cImg != null) { %>

                                <img src="<%= cImg %>" alt="">

                                <% } else { %>

                                <%= c.getName()
                                        .substring(0,1)
                                        .toUpperCase() %>

                                <% } %>

                            </div>

                            <div>

                                <div class="contact-name">
                                    <%= c.getName() %>
                                </div>

                                <div class="contact-role">
                                    <%= c.getRole() %>
                                </div>

                            </div>

                        </div>

                        <% } } %>

                    </div>

                </div>

                <!-- CHAT AREA -->

                <div class="chat-main">

                    <% if(chatWith != null) { %>

                    <div class="chat-header">

                        <button id="btnShowContacts"
                                class="btn btn-outline hidden mr-2"
                                style="border:none;">

                            <i class="fa-solid fa-bars"></i>

                        </button>

                        <div class="user-avatar">

                            <%
                            String cwImg =
                                    PhotoUtil.getPhotoUrl(
                                            request.getContextPath(),
                                            chatWith.getProfilePhoto());
                            %>

                            <% if(cwImg != null) { %>

                            <img src="<%= cwImg %>" alt="">

                            <% } else { %>

                            <%= chatWith.getName()
                                    .substring(0,1)
                                    .toUpperCase() %>

                            <% } %>

                        </div>

                        <div class="chat-header-info">

                            <h4>
                                <%= chatWith.getName() %>
                            </h4>

                            <p>

                                <%= chatWith.getDepartment() != null
                                        ? chatWith.getDepartment()
                                        : chatWith.getRole() %>

                            </p>

                        </div>

                        <a href="${pageContext.request.contextPath}/profile?id=<%= chatWith.getUserId() %>"
                           class="btn btn-outline btn-sm ml-auto"
                           style="margin-left:auto;">

                            <i class="fa-solid fa-user"></i>

                            View Profile

                        </a>

                    </div>

                    <div class="chat-messages"
                         id="chatMessages">

                        <!-- Messages injected by app.js -->

                    </div>

                    <form id="chatForm"
                          class="chat-input-area">

                        <input type="hidden"
                               id="currentReceiverId"
                               value="<%= chatWith.getUserId() %>">

                        <input type="text"
                               id="msgInput"
                               class="form-control"
                               placeholder="Type a message..."
                               required
                               autocomplete="off">

                        <button type="submit"
                                class="send-btn">

                            <i class="fa-solid fa-paper-plane"></i>

                        </button>

                    </form>

                    <% } else { %>

                    <div class="chat-empty">

                        <div class="chat-empty-icon"
                             style="color:var(--accent);">

                            <i class="fa-regular fa-comments"></i>

                        </div>

                        <h3>Your Messages</h3>

                        <p>
                            Select a conversation from the left
                            to start chatting.
                        </p>

                    </div>

                    <% } %>

                </div>

            </div>

        </div>

    </div>

</div>

<style>

    /* MOBILE FIXES */

    @media (max-width: 768px) {

        #btnShowContacts {

            display: inline-flex;

        }

        #btnBackContacts {

            display: inline-flex !important;

        }
    }

</style>

<script>

    document.getElementById('btnShowContacts')
        ?.addEventListener('click', function() {

        document.querySelector('.chat-contacts')
            .classList.add('mobile-show');

    });

</script>

<script src="${pageContext.request.contextPath}/js/app.js"></script>

</body>
</html>