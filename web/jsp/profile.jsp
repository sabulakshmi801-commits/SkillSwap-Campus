<%@ page import="java.util.List" %>
<%@ page import="model.*" %>
<%@ page import="utility.PhotoUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if (session == null || session.getAttribute("loggedUser") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

User loggedUser = (User) session.getAttribute("loggedUser");
request.setAttribute("pageTitle", "User Profile");

User pUser = (User) request.getAttribute("profileUser");
boolean isOwn = (Boolean) request.getAttribute("isOwn");

String pwdError = (String) session.getAttribute("pwdError");
String pwdSuccess = (String) session.getAttribute("pwdSuccess");

if (pwdError != null) session.removeAttribute("pwdError");
if (pwdSuccess != null) session.removeAttribute("pwdSuccess");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<title>Profile - SkillSwap Campus</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>

/* ===== OLD PROFILE UI ===== */

.profile-card-old{
    background:#fff;
    border:1px solid var(--card-border);
    border-radius:20px;
    overflow:hidden;
    box-shadow:0 2px 12px rgba(0,0,0,0.04);
    margin-bottom:24px;
}

.profile-cover-old{
    height:140px;
    background:linear-gradient(90deg,#ecebff,#e7e5ff,#f2f1ff);
}

.profile-body-old{
    padding:0 30px 30px;
    position:relative;
}

.profile-top-old{
    display:flex;
    justify-content:space-between;
    align-items:flex-start;
    gap:20px;
    flex-wrap:wrap;
    position:relative;
    z-index:5;
}

.profile-avatar-old{
    width:120px;
    height:120px;
    border-radius:50%;
    border:5px solid #fff;
    background:#6c4df6;
    overflow:hidden;
    margin-top:-60px;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:42px;
    font-weight:700;
    color:#fff;
}

.profile-avatar-old img{
    width:100%;
    height:100%;
    object-fit:cover;
}

.profile-name-old{
    font-size:22px;
    font-weight:800;
    color:var(--text);
    margin-top:14px;
}

.profile-dept-old{
    color:var(--text-muted);
    font-size:15px;
    margin-top:4px;
}

.profile-stats-old{
    display:flex;
    gap:40px;
    margin-top:24px;
}

.profile-stat-number{
    font-size:32px;
    font-weight:800;
    color:#111827;
}

.profile-stat-label{
    color:var(--text-muted);
    font-size:13px;
}

.about-section{
    margin-top:26px;
}

.about-title{
    font-size:16px;
    font-weight:700;
    margin-bottom:8px;
}

.about-text{
    color:var(--text-muted);
    line-height:1.7;
    max-width:700px;
}

.profile-action-buttons{
    display:flex;
    gap:12px;
    margin-top:16px;
    flex-wrap:wrap;
    position:relative;
    z-index:1000;
}

.profile-action-buttons button{
    pointer-events:auto !important;
    cursor:pointer;
}

.skill-item,
.review-item{
    border-bottom:1px solid var(--card-border);
    padding-bottom:14px;
    margin-bottom:14px;
}

.skill-item:last-child,
.review-item:last-child{
    border-bottom:none;
    margin-bottom:0;
    padding-bottom:0;
}

/* ===== MODALS ===== */

.modal-overlay{
    position:fixed;
    inset:0;
    background:rgba(0,0,0,0.5);
    display:none;
    align-items:center;
    justify-content:center;
    z-index:99999;
    padding:20px;
}

.modal-box{
    background:#fff;
    width:100%;
    max-width:500px;
    border-radius:18px;
    padding:24px;
    max-height:90vh;
    overflow-y:auto;
}

.modal-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:20px;
}

.modal-title{
    font-size:20px;
    font-weight:700;
}

.modal-close{
    border:none;
    background:none;
    font-size:20px;
    cursor:pointer;
}

.form-group{
    margin-bottom:16px;
}

.form-label{
    display:block;
    margin-bottom:6px;
    font-weight:600;
}

.form-control{
    width:100%;
    padding:12px;
    border:1px solid #d1d5db;
    border-radius:10px;
    font-size:14px;
}

textarea.form-control{
    min-height:100px;
    resize:vertical;
}

</style>

</head>

<body>

<div class="app-wrapper">

<jsp:include page="sidebar.jsp"/>

<div class="main-content">

<jsp:include page="topbar.jsp"/>

<div class="content-area">

<% if (pwdSuccess != null) { %>

<div class="alert alert-success">
    <i class="fa-solid fa-circle-check"></i>
    <%= pwdSuccess %>
</div>

<% } %>

<% if (pwdError != null) { %>

<div class="alert alert-danger">
    <%= pwdError %>
</div>

<% } %>

<!-- PROFILE CARD -->

<div class="profile-card-old">

<div class="profile-cover-old"></div>

<div class="profile-body-old">

<div class="profile-top-old">

<div>

<div class="profile-avatar-old">

<%
String profileImg = PhotoUtil.getPhotoUrl(
        request.getContextPath(),
        pUser.getProfilePhoto());

if(profileImg != null){
%>

<img src="<%= profileImg %>" alt="">

<% } else { %>

<%= pUser.getName().substring(0,1).toUpperCase() %>

<% } %>

</div>

<div class="profile-name-old">
<%= pUser.getName() %>
</div>

<div class="profile-dept-old">
<%= pUser.getDepartment() != null ?
        pUser.getDepartment() :
        pUser.getRole() %>
</div>

<div class="profile-stats-old">

<div>
<div class="profile-stat-number">
<i class="fa-solid fa-star text-warning"
   style="font-size:22px;"></i>

<%= String.format("%.1f",
        pUser.getAvgRating()) %>
</div>

<div class="profile-stat-label">
Rating
</div>
</div>

<div>
<div class="profile-stat-number">
<%= pUser.getTotalSessions() %>
</div>

<div class="profile-stat-label">
Sessions
</div>
</div>

</div>

<div class="about-section">

<div class="about-title">
About
</div>

<div class="about-text">

<%= (pUser.getBio() != null &&
        !pUser.getBio().isEmpty())
        ? pUser.getBio()
        : "No bio provided." %>

</div>

</div>

</div>

<div class="profile-action-buttons">

<% if(isOwn){ %>

<button type="button"
        id="btnEditProfile"
        class="btn btn-outline">

<i class="fa-solid fa-pen"></i>
Edit Profile

</button>

<button type="button"
        id="btnChangePassword"
        class="btn btn-outline">

<i class="fa-solid fa-key"></i>
Change Password

</button>

<% } else { %>

<a href="${pageContext.request.contextPath}/chat?with=<%= pUser.getUserId() %>"
   class="btn btn-primary">

<i class="fa-regular fa-comment"></i>
Message

</a>

<% } %>

</div>

</div>

</div>

</div>

<!-- SKILLS + REVIEWS -->

<div class="grid grid-2">

<!-- SKILLS -->

<div class="card">

<div class="card-header">

<span class="card-title">
Skills Offered
</span>

<% if(isOwn){ %>

<button type="button"
        id="btnAddSkill"
        class="btn btn-primary btn-sm">

<i class="fa-solid fa-plus"></i>
Add

</button>

<% } %>

</div>

<div class="card-body">

<%
List<Skill> skills =
        (List<Skill>) request.getAttribute("profileSkills");

if(skills != null && !skills.isEmpty()){

for(Skill s : skills){
%>

<div class="skill-item">

<div class="d-flex justify-between align-center mb-1">

<div class="fw-700">
<%= s.getSkillName() %>
</div>

<span class="badge badge-purple">
<%= s.getExperienceLevel() %>
</span>

</div>

<div class="text-muted"
     style="font-size:13px; margin-bottom:8px;">

<%= s.getDescription() %>

</div>

<div class="d-flex justify-between align-center">

<span class="badge badge-gray">

<i class="fa-regular fa-clock"></i>

<%= s.getAvailability() %>

</span>

<% if(isOwn){ %>

<form action="${pageContext.request.contextPath}/add-skill"
      method="post">

<input type="hidden"
       name="action"
       value="delete">

<input type="hidden"
       name="skillId"
       value="<%= s.getSkillId() %>">

<button type="submit"
        class="btn btn-danger btn-sm">

<i class="fa-solid fa-trash"></i>

</button>

</form>

<% } else { %>

<a href="${pageContext.request.contextPath}/session?action=request&skillId=<%= s.getSkillId() %>"
   class="btn btn-primary btn-sm">

Request Session

</a>

<% } %>

</div>

</div>

<% } } else { %>

<p class="text-muted">
No skills listed yet.
</p>

<% } %>

</div>

</div>

<!-- REVIEWS -->

<div class="card">

<div class="card-header">

<span class="card-title">
Reviews & Feedback
</span>

</div>

<div class="card-body">

<%
List<Feedback> feedback =
        (List<Feedback>) request.getAttribute("profileFeedback");

if(feedback != null && !feedback.isEmpty()){

for(Feedback f : feedback){
%>

<div class="review-item">

<div class="d-flex justify-between mb-1">

<div class="fw-700">
<%= f.getReviewerName() %>
</div>

<div class="stars-sm">

<% for(int i=0;i<5;i++){ %>

<i class="fa-<%= i < f.getRating() ?
        "solid" : "regular" %> fa-star"></i>

<% } %>

</div>

</div>

<div class="text-muted"
     style="font-size:12px; margin-bottom:8px;">

<%= f.getCreatedAt().substring(0,10) %>

</div>

<p style="font-size:13px; line-height:1.6;">

<%= f.getComments() %>

</p>

</div>

<% } } else { %>

<p class="text-muted">
No reviews yet.
</p>

<% } %>

</div>

</div>

</div>

</div>

</div>

</div>

<!-- EDIT PROFILE MODAL -->

<% if(isOwn){ %>

<div class="modal-overlay" id="editProfileModal">

<div class="modal-box">

<div class="modal-header">

<h3 class="modal-title">
Edit Profile
</h3>

<button type="button"
        class="modal-close">

<i class="fa-solid fa-xmark"></i>

</button>

</div>

<form action="${pageContext.request.contextPath}/profile"
      method="post"
      enctype="multipart/form-data">

<div class="form-group">
<label class="form-label">Profile Photo</label>

<input type="file"
       name="profilePhoto"
       class="form-control">
</div>

<div class="form-group">
<label class="form-label">Name</label>

<input type="text"
       name="name"
       class="form-control"
       value="<%= pUser.getName() %>">
</div>

<div class="form-group">
<label class="form-label">Department</label>

<input type="text"
       name="department"
       class="form-control"
       value="<%= pUser.getDepartment() != null ? pUser.getDepartment() : "" %>">
</div>

<div class="form-group">
<label class="form-label">Bio</label>

<textarea name="bio"
          class="form-control"><%= pUser.getBio() != null ? pUser.getBio() : "" %></textarea>
</div>

<button type="submit"
        class="btn btn-primary btn-block">

Save Changes

</button>

</form>

</div>

</div>

<!-- CHANGE PASSWORD MODAL -->

<div class="modal-overlay" id="changePasswordModal">

<div class="modal-box">

<div class="modal-header">

<h3 class="modal-title">
Change Password
</h3>

<button type="button"
        class="modal-close">

<i class="fa-solid fa-xmark"></i>

</button>

</div>

<form action="${pageContext.request.contextPath}/change-password"
      method="post">

<div class="form-group">
<label class="form-label">Current Password</label>

<input type="password"
       name="currentPassword"
       class="form-control">
</div>

<div class="form-group">
<label class="form-label">New Password</label>

<input type="password"
       name="newPassword"
       class="form-control">
</div>

<div class="form-group">
<label class="form-label">Confirm Password</label>

<input type="password"
       name="confirmPassword"
       class="form-control">
</div>

<button type="submit"
        class="btn btn-primary btn-block">

Change Password

</button>

</form>

</div>

</div>

<!-- ADD SKILL MODAL -->

<div class="modal-overlay" id="addSkillModal">

<div class="modal-box">

<div class="modal-header">

<h3 class="modal-title">
Add Skill
</h3>

<button type="button"
        class="modal-close">

<i class="fa-solid fa-xmark"></i>

</button>

</div>

<form action="${pageContext.request.contextPath}/add-skill"
      method="post">

<div class="form-group">

<label class="form-label">
Skill Name
</label>

<input type="text"
       name="skillName"
       class="form-control"
       required>

</div>

<div class="form-group">

<label class="form-label">
Category
</label>

<select name="category"
        class="form-control">

<option value="Programming">Programming</option>
<option value="Web Development">Web Development</option>
<option value="AI & Data Science">AI & Data Science</option>
<option value="Design">Design</option>
<option value="Business">Business</option>

</select>

</div>

<div class="form-group">

<label class="form-label">
Experience Level
</label>

<select name="experienceLevel"
        class="form-control">

<option value="Beginner">Beginner</option>
<option value="Intermediate">Intermediate</option>
<option value="Advanced">Advanced</option>

</select>

</div>

<div class="form-group">

<label class="form-label">
Availability
</label>

<input type="text"
       name="availability"
       class="form-control">

</div>

<div class="form-group">

<label class="form-label">
Description
</label>

<textarea name="description"
          class="form-control"></textarea>

</div>

<button type="submit"
        class="btn btn-primary btn-block">

Add Skill

</button>

</form>

</div>

</div>

<% } %>

<script src="${pageContext.request.contextPath}/js/app.js"></script>

<script>

document.addEventListener("DOMContentLoaded", function () {

    const editBtn = document.getElementById("btnEditProfile");
    const pwdBtn = document.getElementById("btnChangePassword");
    const addBtn = document.getElementById("btnAddSkill");

    const editModal = document.getElementById("editProfileModal");
    const pwdModal = document.getElementById("changePasswordModal");
    const addModal = document.getElementById("addSkillModal");

    function openModal(modal){

        if(modal){

            modal.style.display = "flex";
            document.body.style.overflow = "hidden";

        }

    }

    function closeModal(modal){

        if(modal){

            modal.style.display = "none";
            document.body.style.overflow = "auto";

        }

    }

    if(editBtn){

        editBtn.onclick = function(e){

            e.preventDefault();
            e.stopPropagation();

            openModal(editModal);

        };

    }

    if(pwdBtn){

        pwdBtn.onclick = function(e){

            e.preventDefault();
            e.stopPropagation();

            openModal(pwdModal);

        };

    }

    if(addBtn){

        addBtn.onclick = function(e){

            e.preventDefault();
            e.stopPropagation();

            openModal(addModal);

        };

    }

    const closeBtns = document.querySelectorAll(".modal-close");

    closeBtns.forEach(function(btn){

        btn.onclick = function(){

            const modal = btn.closest(".modal-overlay");

            closeModal(modal);

        };

    });

    const overlays = document.querySelectorAll(".modal-overlay");

    overlays.forEach(function(overlay){

        overlay.addEventListener("click", function(e){

            if(e.target === overlay){

                closeModal(overlay);

            }

        });

    });

});

</script>

</body>
</html>