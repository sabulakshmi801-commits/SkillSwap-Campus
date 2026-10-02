<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - SkillSwap Campus</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-logo">
                <div class="brand-icon"><i class="fa-solid fa-graduation-cap"></i></div>
                <h2 class="auth-title">Welcome Back</h2>
                <p class="auth-sub">Sign in to continue to SkillSwap</p>
            </div>

            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("error") %></div>
            <% } %>
            <% if(request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("success") %></div>
            <% } %>

            <form action="login" method="POST" autocomplete="off">
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" id="loginEmail" class="form-control" required
                           placeholder="Enter your email" value="" autocomplete="off" autocapitalize="off">
                </div>
                <div class="form-group">
                    <label class="form-label" style="display:flex; justify-content:space-between;">
                        Password
                        <a href="forgot-password" style="font-size:11.5px; color:var(--accent); font-weight:600;">Forgot?</a>
                    </label>
                    <input type="password" name="password" id="loginPassword" class="form-control" required
                           placeholder="Enter your password" value="" autocomplete="new-password">
                </div>
                
                <button type="submit" class="btn btn-primary btn-block btn-lg mt-2">Sign In</button>
            </form>
            
            <div class="auth-divider">OR</div>
            
            <p class="text-center text-muted" style="font-size:13.5px;">
                Don't have an account? <a href="register" style="color:var(--accent); font-weight:700;">Create Account</a>
            </p>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>