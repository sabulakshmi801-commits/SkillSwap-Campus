<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - SkillSwap Campus</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="auth-wrapper" style="padding: 60px 20px;">
        <div class="auth-card" style="max-width: 550px;">
            <div class="auth-logo">
                <div class="brand-icon"><i class="fa-solid fa-user-plus"></i></div>
                <h2 class="auth-title">Create Account</h2>
                <p class="auth-sub">Join the campus learning network</p>
            </div>

            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("error") %></div>
            <% } %>

            <form action="register" method="POST" autocomplete="off">
                <div class="grid grid-2">
                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="name" class="form-control" required placeholder="John Doe">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Role</label>
                        <select name="role" class="form-control" required>
                            <option value="student">Student</option>
                            <option value="faculty">Faculty Member</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">University Email</label>
                    <input type="email" name="email" class="form-control" required placeholder="john@skillswap.edu">
                </div>

                <div class="form-group">
                    <label class="form-label">Department / Major</label>
                    <input type="text" name="department" class="form-control" required placeholder="Computer Science">
                </div>

                <div class="grid grid-2">
                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required placeholder="••••••••">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Confirm Password</label>
                        <input type="password" name="confirmPassword" class="form-control" required placeholder="••••••••">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Short Bio</label>
                    <textarea name="bio" class="form-control" placeholder="Tell us a little about your interests..."></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block btn-lg mt-2">Sign Up</button>
            </form>
            
            <div class="auth-divider">OR</div>
            
            <p class="text-center text-muted" style="font-size:13.5px;">
                Already have an account? <a href="login" style="color:var(--accent); font-weight:700;">Sign In</a>
            </p>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
