package dao;

import model.Skill;
import utility.DBConnection;
import java.sql.*;
import java.util.*;

public class SkillDAO {

    public boolean addSkill(Skill skill) {
        String sql = "INSERT INTO skills (user_id,skill_name,category,description,experience_level,availability) VALUES (?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, skill.getUserId());
            ps.setString(2, skill.getSkillName());
            ps.setString(3, skill.getCategory());
            ps.setString(4, skill.getDescription());
            ps.setString(5, skill.getExperienceLevel());
            ps.setString(6, skill.getAvailability() != null ? skill.getAvailability() : "Flexible");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Skill> getAllSkillsExceptUser(int excludeUserId) {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT s.*, u.name AS user_name, u.department AS user_department, u.profile_photo, u.avg_rating "
                   + "FROM skills s JOIN users u ON s.user_id=u.user_id "
                   + "WHERE s.is_active=1 AND s.user_id<>? ORDER BY s.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, excludeUserId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapSkill(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Skill> getAllSkills() {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT s.*, u.name AS user_name, u.department AS user_department, u.profile_photo, u.avg_rating "
                   + "FROM skills s JOIN users u ON s.user_id=u.user_id WHERE s.is_active=1 ORDER BY s.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapSkill(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Skill> getSkillsByUser(int userId) {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT s.*, u.name AS user_name, u.department AS user_department, u.profile_photo, u.avg_rating "
                   + "FROM skills s JOIN users u ON s.user_id=u.user_id WHERE s.user_id=? AND s.is_active=1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapSkill(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Skill> searchSkillsExceptUser(String keyword, String category, int excludeUserId) {
        List<Skill> list = new ArrayList<>();
        boolean hasCat = (category != null && !category.isEmpty());
        String sql = "SELECT s.*, u.name AS user_name, u.department AS user_department, u.profile_photo, u.avg_rating "
                   + "FROM skills s JOIN users u ON s.user_id=u.user_id "
                   + "WHERE s.is_active=1 AND s.user_id<>? "
                   + "AND (s.skill_name LIKE ? OR s.description LIKE ? OR u.name LIKE ?) "
                   + (hasCat ? "AND s.category=? " : "")
                   + "ORDER BY s.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int i = 1;
            ps.setInt(i++, excludeUserId);
            ps.setString(i++, "%" + keyword + "%");
            ps.setString(i++, "%" + keyword + "%");
            ps.setString(i++, "%" + keyword + "%");
            if (hasCat) ps.setString(i, category);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapSkill(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Skill> searchSkills(String keyword, String category) {
        return searchSkillsExceptUser(keyword, category, -1);
    }

    public Skill getSkillById(int skillId) {
        String sql = "SELECT s.*, u.name AS user_name, u.department AS user_department, u.profile_photo, u.avg_rating "
                   + "FROM skills s JOIN users u ON s.user_id=u.user_id WHERE s.skill_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, skillId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapSkill(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean deleteSkill(int skillId, int userId) {
        String sql = "UPDATE skills SET is_active=0 WHERE skill_id=? AND user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, skillId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<String> getTrendingSkills() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT skill_name, COUNT(*) AS cnt FROM sessions WHERE skill_name IS NOT NULL GROUP BY skill_name ORDER BY cnt DESC LIMIT 5";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(rs.getString("skill_name"));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalSkills() {
        String sql = "SELECT COUNT(*) FROM skills WHERE is_active=1";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Skill mapSkill(ResultSet rs) throws SQLException {
        Skill s = new Skill();
        s.setSkillId(rs.getInt("skill_id"));
        s.setUserId(rs.getInt("user_id"));
        s.setSkillName(rs.getString("skill_name"));
        s.setCategory(rs.getString("category"));
        s.setDescription(rs.getString("description"));
        s.setExperienceLevel(rs.getString("experience_level"));
        s.setAvailability(rs.getString("availability"));
        s.setUserName(rs.getString("user_name"));
        s.setUserDepartment(rs.getString("user_department"));
        s.setProfilePhoto(rs.getString("profile_photo"));
        s.setAvgRating(rs.getDouble("avg_rating"));
        return s;
    }
}
