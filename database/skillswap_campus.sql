-- ============================================================
--  SkillSwap Campus - Complete Database Script
--  Database  : skillswap_campus
--  Server    : MySQL 8.x
--  Run this script ONCE before launching the application
-- ============================================================

DROP DATABASE IF EXISTS skillswap_campus;
CREATE DATABASE skillswap_campus CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE skillswap_campus;

-- ============================================================
-- TABLE: users
-- ============================================================
CREATE TABLE users (
    user_id        INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(100)  NOT NULL,
    email          VARCHAR(150)  NOT NULL UNIQUE,
    password       VARCHAR(255)  NOT NULL,
    role           ENUM('student','faculty','admin') DEFAULT 'student',
    department     VARCHAR(100),
    bio            TEXT,
    profile_photo  VARCHAR(255)  DEFAULT 'default.png',
    skills_offered TEXT,
    skills_needed  TEXT,
    avg_rating     DECIMAL(3,2)  DEFAULT 0.00,
    total_sessions INT           DEFAULT 0,
    is_active      TINYINT(1)    DEFAULT 1,
    created_at     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: skills
-- ============================================================
CREATE TABLE skills (
    skill_id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT           NOT NULL,
    skill_name       VARCHAR(150)  NOT NULL,
    category         VARCHAR(100),
    description      TEXT,
    experience_level ENUM('Beginner','Intermediate','Advanced','Expert') DEFAULT 'Beginner',
    availability     VARCHAR(100)  DEFAULT 'Flexible',
    is_active        TINYINT(1)    DEFAULT 1,
    created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: sessions
-- ============================================================
CREATE TABLE sessions (
    session_id   INT AUTO_INCREMENT PRIMARY KEY,
    mentor_id    INT           NOT NULL,
    learner_id   INT           NOT NULL,
    skill_id     INT,
    skill_name   VARCHAR(150),
    session_date DATE,
    session_time TIME,
    session_type ENUM('One-to-One','Group Learning','Workshop','Mentorship') DEFAULT 'One-to-One',
    session_mode ENUM('Online','Offline') DEFAULT 'Online',
    status       ENUM('Pending','Accepted','Rejected','Completed','Cancelled') DEFAULT 'Pending',
    notes        TEXT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mentor_id)  REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (learner_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: messages
-- ============================================================
CREATE TABLE messages (
    message_id  INT AUTO_INCREMENT PRIMARY KEY,
    sender_id   INT   NOT NULL,
    receiver_id INT   NOT NULL,
    message     TEXT  NOT NULL,
    is_read     TINYINT(1) DEFAULT 0,
    sent_time   TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id)   REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: feedback
-- ============================================================
CREATE TABLE feedback (
    feedback_id   INT AUTO_INCREMENT PRIMARY KEY,
    session_id    INT NOT NULL,
    reviewer_id   INT NOT NULL,
    reviewee_id   INT NOT NULL,
    rating        INT CHECK (rating BETWEEN 1 AND 5),
    comments      TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id)  REFERENCES sessions(session_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewee_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: resources
-- ============================================================
CREATE TABLE resources (
    resource_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT           NOT NULL,
    skill_id       INT           DEFAULT 0,
    title          VARCHAR(200),
    file_name      VARCHAR(255),
    file_type      VARCHAR(50),
    file_size      BIGINT        DEFAULT 0,
    file_path      VARCHAR(500),
    description    TEXT,
    category       VARCHAR(100),
    download_count INT           DEFAULT 0,
    upload_date    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: notifications
-- ============================================================
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT          NOT NULL,
    title           VARCHAR(200) DEFAULT 'Notification',
    message         TEXT,
    type            ENUM('session','message','feedback','system','resource') DEFAULT 'system',
    reference_id    INT          DEFAULT NULL,
    is_read         TINYINT(1)   DEFAULT 0,
    created_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: reports
-- ============================================================
CREATE TABLE reports (
    report_id        INT AUTO_INCREMENT PRIMARY KEY,
    reporter_id      INT NOT NULL,
    reported_user_id INT NOT NULL,
    reason           TEXT,
    status           ENUM('Pending','Reviewed','Resolved','Dismissed') DEFAULT 'Pending',
    admin_notes      TEXT,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reporter_id)      REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reported_user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX idx_skills_user      ON skills(user_id);
CREATE INDEX idx_sessions_mentor  ON sessions(mentor_id);
CREATE INDEX idx_sessions_learner ON sessions(learner_id);
CREATE INDEX idx_messages_sender  ON messages(sender_id);
CREATE INDEX idx_messages_recv    ON messages(receiver_id);
CREATE INDEX idx_notif_user       ON notifications(user_id);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Admin  (password: Admin@123)
INSERT INTO users (name,email,password,role,department,bio) VALUES
('Admin User','admin@skillswap.edu','Admin@123','admin','Administration','Platform administrator.');

-- Faculty  (password: Faculty@123)
INSERT INTO users (name,email,password,role,department,bio,skills_offered,skills_needed) VALUES
('Dr. Priya Sharma','priya@skillswap.edu','Faculty@123','faculty','Computer Science',
 'Professor with 10+ years in Data Science and AI.','Machine Learning,Python,Data Science','Blockchain'),
('Prof. Arjun Mehta','arjun@skillswap.edu','Faculty@123','faculty','Electronics',
 'Expert in Embedded Systems and IoT.','IoT,Arduino,C Programming','Web Development');

-- Students  (password: Student@123)
INSERT INTO users (name,email,password,role,department,bio,skills_offered,skills_needed) VALUES
('Rahul Kumar','rahul@skillswap.edu','Student@123','student','Computer Science',
 'Passionate about web development and open source.','HTML,CSS,JavaScript,React','Machine Learning,Python'),
('Sneha Patel','sneha@skillswap.edu','Student@123','student','Information Technology',
 'Full stack developer and UI/UX enthusiast.','Java,Spring Boot,MySQL','Cloud Computing'),
('Vikram Singh','vikram@skillswap.edu','Student@123','student','Computer Science',
 'Algorithm enthusiast and competitive programmer.','C++,Algorithms,Data Structures','Web Development'),
('Ananya Reddy','ananya@skillswap.edu','Student@123','student','Information Technology',
 'Mobile app developer.','Android,Kotlin,Flutter','Machine Learning'),
('Rohit Joshi','rohit@skillswap.edu','Student@123','student','Electronics',
 'Hardware and software integration specialist.','Python,Raspberry Pi,Linux','Data Science');

-- Skills
INSERT INTO skills (user_id,skill_name,category,description,experience_level,availability) VALUES
(2,'Machine Learning','AI & Data Science','Supervised and unsupervised learning, neural networks.','Expert','Weekdays 10AM-5PM'),
(2,'Python Programming','Programming','Advanced Python including pandas and numpy.','Expert','Flexible'),
(3,'IoT Development','Hardware','Smart IoT solutions with sensors and microcontrollers.','Expert','Weekends'),
(4,'React Development','Web Development','Modern SPAs with React hooks and state management.','Intermediate','Evenings'),
(4,'JavaScript','Web Development','ES6+, async/await, DOM manipulation.','Advanced','Flexible'),
(5,'Java Development','Programming','Core Java, OOP, Collections, Spring basics.','Advanced','Flexible'),
(5,'MySQL Database','Database','Database design, optimization, stored procedures.','Advanced','Weekdays'),
(6,'Competitive Programming','Algorithms','Solving algorithmic problems on Codeforces and LeetCode.','Expert','Weekends'),
(7,'Android Development','Mobile','Native Android apps with Kotlin and Jetpack Compose.','Advanced','Evenings'),
(8,'Raspberry Pi Projects','Hardware','Projects using Raspberry Pi and Python.','Intermediate','Flexible');

-- Sessions
INSERT INTO sessions (mentor_id,learner_id,skill_id,skill_name,session_date,session_time,session_type,session_mode,status,notes) VALUES
(2,4,1,'Machine Learning','2026-06-01','10:00:00','One-to-One','Online','Accepted','Introduction to ML'),
(2,7,1,'Machine Learning','2026-06-03','14:00:00','One-to-One','Online','Pending','Basics of neural networks'),
(5,4,6,'Java Development','2026-05-20','11:00:00','Mentorship','Offline','Completed','Core Java fundamentals'),
(4,6,4,'React Development','2026-06-05','15:00:00','One-to-One','Online','Accepted','React hooks tutorial'),
(6,4,8,'Competitive Programming','2026-05-15','09:00:00','Workshop','Online','Completed','Dynamic programming');

-- Update total_sessions
UPDATE users SET total_sessions=2 WHERE user_id=4;
UPDATE users SET total_sessions=1 WHERE user_id=5;
UPDATE users SET total_sessions=1 WHERE user_id=6;

-- Messages
INSERT INTO messages (sender_id,receiver_id,message,is_read) VALUES
(4,2,'Hello Dr. Priya! I am interested in learning Machine Learning. Can we schedule a session?',1),
(2,4,'Hi Rahul! Sure, I have slots available next week. What time works for you?',1),
(4,2,'How about Monday at 10 AM?',1),
(2,4,'Perfect! Monday 10 AM it is. I will send you the session details.',1),
(5,4,'Hi Rahul! How is the Java session going?',0),
(4,5,'It was great! Learned a lot about Collections.',0);

-- Feedback
INSERT INTO feedback (session_id,reviewer_id,reviewee_id,rating,comments) VALUES
(3,4,5,5,'Excellent session! Sneha explained everything clearly and patiently.'),
(5,4,6,4,'Very good workshop on Dynamic Programming. Well organized.');

-- Update ratings
UPDATE users SET avg_rating=5.00 WHERE user_id=5;
UPDATE users SET avg_rating=4.00 WHERE user_id=6;

-- Resources
INSERT INTO resources (user_id,skill_id,title,file_name,file_type,description,category,file_path) VALUES
(2,1,'Introduction to ML Slides','ml_intro.pdf','PDF','Comprehensive introduction to ML algorithms','AI & Data Science','uploads/ml_intro.pdf'),
(5,6,'Java Collections Guide','java_collections.pdf','PDF','Complete guide to Java Collections framework','Programming','uploads/java_collections.pdf'),
(4,4,'React Hooks Cheatsheet','react_hooks.pdf','PDF','Quick reference for all React hooks','Web Development','uploads/react_hooks.pdf');

-- Notifications
INSERT INTO notifications (user_id,title,message,type) VALUES
(4,'Session Accepted!','Dr. Priya Sharma accepted your Machine Learning session for June 1.','session'),
(4,'New Message','You have a new message from Sneha Patel.','message'),
(2,'New Session Request','Ananya Reddy requested a Machine Learning session.','session'),
(5,'Feedback Received','You received a 5-star rating from Rahul Kumar.','feedback');

-- ============================================================
-- END OF SCRIPT
-- ============================================================
