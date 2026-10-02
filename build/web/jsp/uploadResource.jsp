<%@ page import="java.util.List" %>
<%@ page import="model.Skill" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("pageTitle", "Upload Resource"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Upload Resource - SkillSwap Campus</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-wrapper">
        <jsp:include page="sidebar.jsp"/>
        
        <div class="main-content">
            <jsp:include page="topbar.jsp"/>
            
            <div class="content-area">
                <%
                    List<Skill> userSkills = (List<Skill>) request.getAttribute("userSkills");
                    boolean hasSkills = userSkills != null && !userSkills.isEmpty();
                %>
                
                <div class="card" style="max-width: 600px; margin: 0 auto;">
                    <div class="card-header">
                        <span class="card-title">Share Study Material</span>
                        <a href="${pageContext.request.contextPath}/upload" class="btn btn-outline btn-sm">Back to Resources</a>
                    </div>
                    <div class="card-body">
                        <% if(request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                        <% } %>
                        <% if(request.getParameter("success") != null) { %>
                            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <%= request.getParameter("success") %></div>
                        <% } %>

                        <% if (!hasSkills) { %>
                            <div class="alert alert-warning">
                                <i class="fa-solid fa-circle-info"></i>
                                Add at least one skill on your <a href="${pageContext.request.contextPath}/profile">profile</a> before uploading resources.
                            </div>
                        <% } else { %>
                        <form action="${pageContext.request.contextPath}/upload" method="post" enctype="multipart/form-data">
                            
                            <div class="form-group">
                                <label class="form-label">Resource Title</label>
                                <input type="text" name="title" class="form-control" required placeholder="E.g. Data Structures Notes">
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Related Skill <span class="text-muted" style="font-weight:400;">(from your profile only)</span></label>
                                <select name="skillId" class="form-control" required>
                                    <% for (Skill s : userSkills) { %>
                                        <option value="<%= s.getSkillId() %>"><%= s.getSkillName() %></option>
                                    <% } %>
                                </select>
                                <p class="form-hint">Only skills you added on your profile are listed here.</p>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Description</label>
                                <textarea name="description" class="form-control" placeholder="Brief description of the content..."></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Select File (PDF, DOC, PPT, ZIP, Images, Video)</label>
                                <div style="border: 2px dashed var(--card-border); padding: 30px; text-align: center; border-radius: 10px; background: var(--bg);">
                                    <i class="fa-solid fa-cloud-arrow-up text-muted" style="font-size:32px; margin-bottom:10px;"></i>
                                    <input type="file" name="file" class="form-control" required style="border:none; background:transparent;"
                                           accept=".pdf,.doc,.docx,.ppt,.pptx,.zip,.rar,.jpg,.jpeg,.png,.gif,.webp,.mp4,.mov,.avi,.mkv,.webm,image/*,video/*">
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-primary btn-block btn-lg mt-2"><i class="fa-solid fa-upload"></i> Upload File</button>
                        </form>
                        <% } %>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
