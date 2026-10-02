package dao;

import model.User;
import utility.DBConnection;
import java.sql.*;
import java.util.*;

public class UserDAO {

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (name,email,password,role,department,bio,profile_photo) VALUES (?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole() != null ? user.getRole() : "student");
            ps.setString(5, user.getDepartment());
            ps.setString(6, user.getBio());
            ps.setString(7, user.getProfilePhoto() != null ? user.getProfilePhoto() : "default.png");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Updates name, department, and bio only — does not change profile photo. */
    public boolean updateProfileInfo(User user) {
        String sql = "UPDATE users SET name=?,department=?,bio=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getDepartment());
            ps.setString(3, user.getBio());
            ps.setInt(4, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateProfilePhoto(int userId, String photoName) {
        String sql = "UPDATE users SET profile_photo=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, normalizePhotoPath(photoName));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role!='admin' ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapUser(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean toggleUserStatus(int userId, boolean status) {
        String sql = "UPDATE users SET is_active=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role!='admin'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public void updateRating(int userId) {
        String sql = "UPDATE users SET avg_rating=(SELECT COALESCE(AVG(rating),0) FROM feedback WHERE reviewee_id=?) WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private static String normalizePhotoPath(String photo) {
        if (photo == null || photo.trim().isEmpty()) return "default.png";
        String p = photo.replace('\\', '/').trim();
        while (p.startsWith("uploads/")) p = p.substring("uploads/".length());
        return p.isEmpty() ? "default.png" : p;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setDepartment(rs.getString("department"));
        u.setBio(rs.getString("bio"));
        u.setProfilePhoto(normalizePhotoPath(rs.getString("profile_photo")));
        u.setAvgRating(rs.getDouble("avg_rating"));
        u.setTotalSessions(rs.getInt("total_sessions"));
        u.setActive(rs.getBoolean("is_active"));
        return u;
    }
}
