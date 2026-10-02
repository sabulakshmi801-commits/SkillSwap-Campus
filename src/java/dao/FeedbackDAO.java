package dao;

import model.Feedback;
import utility.DBConnection;
import java.sql.*;
import java.util.*;

public class FeedbackDAO {

    public boolean addFeedback(Feedback fb) {
        String sql = "INSERT INTO feedback (session_id,reviewer_id,reviewee_id,rating,comments) VALUES (?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, fb.getSessionId());
            ps.setInt(2, fb.getReviewerId());
            ps.setInt(3, fb.getRevieweeId());
            ps.setInt(4, fb.getRating());
            ps.setString(5, fb.getComments());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Feedback> getFeedbackForUser(int userId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.name AS reviewer_name, u.profile_photo AS reviewer_photo "
                   + "FROM feedback f JOIN users u ON f.reviewer_id=u.user_id "
                   + "WHERE f.reviewee_id=? ORDER BY f.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapFeedback(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean hasFeedback(int sessionId, int reviewerId) {
        String sql = "SELECT COUNT(*) FROM feedback WHERE session_id=? AND reviewer_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            ps.setInt(2, reviewerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Feedback mapFeedback(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setFeedbackId(rs.getInt("feedback_id"));
        f.setSessionId(rs.getInt("session_id"));
        f.setReviewerId(rs.getInt("reviewer_id"));
        f.setRevieweeId(rs.getInt("reviewee_id"));
        f.setRating(rs.getInt("rating"));
        f.setComments(rs.getString("comments"));
        f.setCreatedAt(rs.getString("created_at"));
        f.setReviewerName(rs.getString("reviewer_name"));
        f.setReviewerPhoto(rs.getString("reviewer_photo"));
        return f;
    }
}
