<%@ page import="model.LearningSession" %>
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

User me = (User) session.getAttribute("loggedUser");

request.setAttribute("pageTitle", "Leave Feedback");

LearningSession s =
        (LearningSession) request.getAttribute("sessionForFeedback");

if(s == null){
    response.sendRedirect(request.getContextPath() + "/session");
    return;
}

boolean amIMentor = (me.getUserId() == s.getMentorId());

int revieweeId =
        amIMentor ? s.getLearnerId() : s.getMentorId();

String revieweeName =
        amIMentor ? s.getLearnerName() : s.getMentorName();

String revieweePhoto =
        amIMentor ? s.getLearnerPhoto() : s.getMentorPhoto();
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Feedback - SkillSwap Campus</title>

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

            <div class="card"
                 style="max-width: 600px; margin: 0 auto;">

                <div class="card-header">

                    <span class="card-title">
                        Rate Your Session
                    </span>

                    <a href="${pageContext.request.contextPath}/session"
                       class="btn btn-outline btn-sm">

                        Cancel

                    </a>

                </div>

                <div class="card-body">

                    <div style="
                        background: var(--bg);
                        padding: 16px;
                        border-radius: 10px;
                        margin-bottom: 24px;
                        text-align:center;">

                        <div class="user-avatar"
                             style="
                             width:64px;
                             height:64px;
                             font-size:24px;
                             margin: 0 auto 10px;">

                            <% if(revieweePhoto != null &&
                                  !revieweePhoto.equals("default.png")) { %>

                            <img src="${pageContext.request.contextPath}/uploads/<%= revieweePhoto %>">

                            <% } else { %>

                            <%= revieweeName
                                    .substring(0,1)
                                    .toUpperCase() %>

                            <% } %>

                        </div>

                        <div style="font-size:16px; font-weight:700;">

                            <%= revieweeName %>

                        </div>

                        <div style="
                             font-size:13px;
                             color:var(--text-muted);">

                            Session:
                            <%= s.getSkillName() %>

                        </div>

                    </div>

                    <% if(request.getAttribute("error") != null) { %>

                    <div class="alert alert-danger">

                        <%= request.getAttribute("error") %>

                    </div>

                    <% } %>

                    <form action="${pageContext.request.contextPath}/feedback"
                          method="post">

                        <input type="hidden"
                               name="sessionId"
                               value="<%= s.getSessionId() %>">

                        <input type="hidden"
                               name="revieweeId"
                               value="<%= revieweeId %>">

                        <div class="form-group text-center">

                            <label class="form-label"
                                   style="font-size:16px;">

                                Overall Rating

                            </label>

                            <div class="rating-selector"
                                 style="
                                 font-size:32px;
                                 color:var(--card-border);
                                 cursor:pointer;
                                 display:flex;
                                 justify-content:center;
                                 gap:8px;
                                 margin: 10px 0;">

                                <i class="fa-solid fa-star star-btn"
                                   data-val="1"></i>

                                <i class="fa-solid fa-star star-btn"
                                   data-val="2"></i>

                                <i class="fa-solid fa-star star-btn"
                                   data-val="3"></i>

                                <i class="fa-solid fa-star star-btn"
                                   data-val="4"></i>

                                <i class="fa-solid fa-star star-btn"
                                   data-val="5"></i>

                            </div>

                            <input type="hidden"
                                   name="rating"
                                   id="ratingInput"
                                   value="5"
                                   required>

                            <div id="ratingText"
                                 class="text-accent fw-600">

                                Excellent

                            </div>

                        </div>

                        <div class="form-group">

                            <label class="form-label">
                                Review / Comments
                            </label>

                            <textarea name="comments"
                                      class="form-control"
                                      placeholder="How was your experience? Was the session helpful?"></textarea>

                        </div>

                        <button type="submit"
                                class="btn btn-primary btn-block btn-lg mt-2">

                            Submit Feedback

                        </button>

                    </form>

                </div>

            </div>

        </div>

    </div>

</div>

<script>

    const stars =
            document.querySelectorAll('.star-btn');

    const rInput =
            document.getElementById('ratingInput');

    const rText =
            document.getElementById('ratingText');

    const texts = [
        'Poor',
        'Fair',
        'Good',
        'Very Good',
        'Excellent'
    ];

    function updateStars(val) {

        stars.forEach((s, idx) => {

            if(idx < val) {

                s.style.color = '#f59e0b';

            } else {

                s.style.color = 'var(--card-border)';
            }
        });

        rInput.value = val;

        rText.innerText = texts[val - 1];
    }

    stars.forEach(s => {

        s.addEventListener('click', () => {

            updateStars(parseInt(s.dataset.val));

        });

    });

    updateStars(5);

</script>

<script src="${pageContext.request.contextPath}/js/app.js"></script>

</body>
</html>