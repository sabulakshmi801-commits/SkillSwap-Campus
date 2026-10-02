<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillSwap Campus - Peer Learning Network</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="landing-page">

    <nav class="landing-nav">
        <div class="landing-container landing-nav-inner">
            <div class="landing-brand">
                <div class="brand-icon"><i class="fa-solid fa-graduation-cap"></i></div>
                <div>
                    <div class="brand-name">SkillSwap</div>
                    <div class="brand-sub">Campus</div>
                </div>
            </div>
            <div class="landing-nav-actions">
                <% if(session.getAttribute("loggedUser") == null) { %>
                    <a href="login" class="btn btn-outline">Sign In</a>
                    <a href="register" class="btn btn-primary">Create Account</a>
                <% } else { %>
                    <a href="dashboard" class="btn btn-primary">Go to Dashboard</a>
                <% } %>
            </div>
        </div>
    </nav>

    <section class="landing-hero">
        <div class="landing-container landing-hero-grid">
            <div class="landing-hero-inner">
                <div class="hero-badge">
                    <i class="fa-solid fa-star"></i> The #1 Campus Learning Network
                </div>
                <h1 class="hero-title">Learn from <span>peers.</span> Teach what you <span>know.</span></h1>
                <p class="hero-desc">
                    SkillSwap Campus connects students and faculty to share knowledge, skills, and resources on one platform.
                </p>
                <div class="hero-btns">
                    <a href="register" class="btn btn-primary btn-lg">Join the Network</a>
                    <a href="#features" class="btn btn-outline btn-lg">Explore Features</a>
                </div>
                <div class="hero-skills">
                    <span class="skill-pill">Machine Learning</span>
                    <span class="skill-pill">React.js</span>
                    <span class="skill-pill">UI/UX Design</span>
                    <span class="skill-pill">Robotics</span>
                </div>
            </div>
            <div class="landing-hero-panel">
                <div class="hero-panel-card">
                    <div class="hero-panel-icon"><i class="fa-solid fa-users"></i></div>
                    <div class="hero-panel-val">Peer Learning</div>
                    <div class="hero-panel-lbl">Request sessions with campus experts</div>
                </div>
                <div class="hero-panel-card">
                    <div class="hero-panel-icon"><i class="fa-solid fa-comments"></i></div>
                    <div class="hero-panel-val">Live Chat</div>
                    <div class="hero-panel-lbl">Message mentors and learners instantly</div>
                </div>
                <div class="hero-panel-card">
                    <div class="hero-panel-icon"><i class="fa-solid fa-folder-open"></i></div>
                    <div class="hero-panel-val">Resources</div>
                    <div class="hero-panel-lbl">Share notes and study materials securely</div>
                </div>
            </div>
        </div>
    </section>

    <section class="landing-stats">
        <div class="landing-container landing-stats-grid">
            <div class="landing-stat-item">
                <i class="fa-solid fa-graduation-cap"></i>
                <span>Students &amp; Faculty</span>
            </div>
            <div class="landing-stat-item">
                <i class="fa-solid fa-calendar-check"></i>
                <span>1-on-1 Sessions</span>
            </div>
            <div class="landing-stat-item">
                <i class="fa-solid fa-shield-halved"></i>
                <span>Campus-Safe Network</span>
            </div>
            <div class="landing-stat-item">
                <i class="fa-solid fa-bolt"></i>
                <span>Free to Join</span>
            </div>
        </div>
    </section>

    <section id="features" class="features-section">
        <div class="landing-container">
            <div class="text-center features-intro">
                <div class="section-badge">Platform Features</div>
                <h2 class="section-title">Everything you need to grow</h2>
                <p class="section-desc features-desc">A complete ecosystem designed to foster collaboration and continuous learning inside your campus.</p>
            </div>
            <div class="grid grid-3 features-grid">
                <div class="feature-card">
                    <div class="feature-icon" style="background: #e0e7ff; color: #4f46e5;">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <h3 class="feature-title">Peer-to-Peer Sessions</h3>
                    <p class="feature-desc">Schedule 1-on-1 or group mentorship sessions with experts in your college.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon" style="background: #fdf2f8; color: #db2777;">
                        <i class="fa-solid fa-comments"></i>
                    </div>
                    <h3 class="feature-title">Real-time Chat</h3>
                    <p class="feature-desc">Communicate instantly with peers using our messaging interface.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon" style="background: #f0fdf4; color: #16a34a;">
                        <i class="fa-solid fa-folder-open"></i>
                    </div>
                    <h3 class="feature-title">Resource Sharing</h3>
                    <p class="feature-desc">Upload and download study materials, cheat sheets, and lecture notes securely.</p>
                </div>
            </div>
        </div>
    </section>

    <footer class="landing-footer">
        <p class="text-muted" style="font-size:13px;">&copy; 2026 SkillSwap Campus. All rights reserved.</p>
    </footer>

</body>
</html>
