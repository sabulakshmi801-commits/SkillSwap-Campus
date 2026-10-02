<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String step = (String) request.getAttribute("step");
    if (step == null) step = "email";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forgot Password - SkillSwap</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-logo">
                <div class="brand-icon" style="background:var(--card-border); color:var(--text);"><i class="fa-solid fa-key"></i></div>
                <h2 class="auth-title">Reset Password</h2>
                <% if ("verify".equals(step)) { %>
                    <p class="auth-sub">Enter the code sent to <%= request.getAttribute("maskedEmail") %></p>
                <% } else { %>
                    <p class="auth-sub">We'll send a verification code to your registered email</p>
                <% } %>
            </div>

            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if(request.getAttribute("info") != null) { %>
                <div class="alert alert-info"><i class="fa-solid fa-envelope"></i> <%= request.getAttribute("info") %></div>
            <% } %>

            <% if ("verify".equals(step)) { %>
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                <input type="hidden" name="step" value="verify">
                <div class="form-group">
                    <label class="form-label">Verification Code</label>
                    <input type="text" name="verificationCode" class="form-control" required
                           placeholder="6-digit code" maxlength="6" pattern="[0-9]{6}">
                </div>
                <div class="form-group">
                    <label class="form-label">New Password</label>
                    <input type="password" name="newPassword" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Confirm Password</label>
                    <input type="password" name="confirmPassword" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block btn-lg mt-2">Set New Password</button>
            </form>
            <% } else { %>
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                <input type="hidden" name="step" value="email">
                <div class="form-group">
                    <label class="form-label">Registered Email Address</label>
                    <input type="email" name="email" class="form-control" required
                           placeholder="Use the email you signed up with">
                </div>
                <button type="submit" class="btn btn-primary btn-block btn-lg mt-2">Send Verification Code</button>
            </form>
            <% } %>

            <div class="mt-3 text-center">
                <a href="${pageContext.request.contextPath}/login" class="text-muted" style="font-size:13.5px; font-weight:600;"><i class="fa-solid fa-arrow-left"></i> Back to Login</a>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
