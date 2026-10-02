package dao;

import model.LearningSession;
import utility.DBConnection;
import java.sql.*;
import java.util.*;

public class SessionDAO {

    private static final String JOIN_SQL =
        "SELECT s.*, m.name AS mentor_name, l.name AS learner_name, "
      + "m.profile_photo AS mentor_photo, l.profile_photo AS learner_photo "
      + "FROM sessions s "
      + "JOIN users m ON s.mentor_id=m.user_id "
      + "JOIN users l ON s.learner_id=l.user_id ";

    public int requestSession(LearningSession session) {
        String sql = "INSERT INTO sessions (mentor_id,learner_id,skill_id,skill_name,session_date,session_time,session_type,session_mode,notes) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, session.getMentorId());
            ps.setInt(2, session.getLearnerId());
            ps.setInt(3, session.getSkillId());
            ps.setString(4, session.getSkillName());
            ps.setString(5, session.getSessionDate());
            ps.setString(6, session.getSessionTime());
            ps.setString(7, session.getSessionType());
            ps.setString(8, session.getSessionMode());
            ps.setString(9, session.getNotes());
            if (ps.executeUpdate() > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<LearningSession> getPendingRequestsForMentor(int mentorId) {
        List<LearningSession> list = new ArrayList<>();
        String sql = JOIN_SQL + "WHERE s.mentor_id=? AND s.status='Pending' ORDER BY s.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, mentorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapSession(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<LearningSession> getSessionsByUser(int userId) {
        List<LearningSession> list = new ArrayList<>();
        String sql = JOIN_SQL + "WHERE s.mentor_id=? OR s.learner_id=? ORDER BY s.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapSession(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public LearningSession getSessionById(int sessionId) {
        String sql = JOIN_SQL + "WHERE s.session_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapSession(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateStatus(int sessionId, String status) {
        String sql = "UPDATE sessions SET status=? WHERE session_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, sessionId);
            if (ps.executeUpdate() > 0) {
                if ("Completed".equals(status)) incrementSessionCounts(sessionId);
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private void incrementSessionCounts(int sessionId) {
        try (Connection con = DBConnection.getConnection()) {
            // Fetch mentor and learner IDs
            PreparedStatement ps = con.prepareStatement("SELECT mentor_id, learner_id FROM sessions WHERE session_id=?");
            ps.setInt(1, sessionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int mentorId  = rs.getInt("mentor_id");
                int learnerId = rs.getInt("learner_id");
                PreparedStatement upd = con.prepareStatement(
                    "UPDATE users SET total_sessions=total_sessions+1 WHERE user_id=?");
                upd.setInt(1, mentorId);  upd.executeUpdate();
                upd.setInt(1, learnerId); upd.executeUpdate();
            }
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public List<LearningSession> getAllSessions() {
        List<LearningSession> list = new ArrayList<>();
        String sql = JOIN_SQL + "ORDER BY s.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapSession(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalSessions() {
        String sql = "SELECT COUNT(*) FROM sessions";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getCompletedSessions() {
        String sql = "SELECT COUNT(*) FROM sessions WHERE status='Completed'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private LearningSession mapSession(ResultSet rs) throws SQLException {
        LearningSession s = new LearningSession();
        s.setSessionId(rs.getInt("session_id"));
        s.setMentorId(rs.getInt("mentor_id"));
        s.setLearnerId(rs.getInt("learner_id"));
        s.setSkillId(rs.getInt("skill_id"));
        s.setSkillName(rs.getString("skill_name"));
        s.setSessionDate(rs.getString("session_date"));
        s.setSessionTime(rs.getString("session_time"));
        s.setSessionType(rs.getString("session_type"));
        s.setSessionMode(rs.getString("session_mode"));
        s.setStatus(rs.getString("status"));
        s.setNotes(rs.getString("notes"));
        s.setCreatedAt(rs.getString("created_at"));
        s.setMentorName(rs.getString("mentor_name"));
        s.setLearnerName(rs.getString("learner_name"));
        s.setMentorPhoto(rs.getString("mentor_photo"));
        s.setLearnerPhoto(rs.getString("learner_photo"));
        return s;
    }
}
