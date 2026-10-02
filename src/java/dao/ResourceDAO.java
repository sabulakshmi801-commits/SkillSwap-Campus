package dao;

import model.Resource;
import utility.DBConnection;
import java.sql.*;
import java.util.*;

public class ResourceDAO {

    public boolean uploadResource(Resource res) {
        String sql = "INSERT INTO resources (user_id,skill_id,title,file_name,file_type,file_path,description,category) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, res.getUserId());
            ps.setInt(2, res.getSkillId());
            ps.setString(3, res.getTitle());
            ps.setString(4, res.getFileName());
            ps.setString(5, res.getFileType());
            ps.setString(6, res.getFilePath());
            ps.setString(7, res.getDescription());
            ps.setString(8, res.getCategory());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Resource> getAllResources() {
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT r.*, u.name AS uploader_name FROM resources r JOIN users u ON r.user_id=u.user_id ORDER BY r.upload_date DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapResource(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Resource> getResourcesByUser(int userId) {
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT r.*, u.name AS uploader_name FROM resources r JOIN users u ON r.user_id=u.user_id WHERE r.user_id=? ORDER BY r.upload_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapResource(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Resource getResourceById(int resourceId) {
        String sql = "SELECT r.*, u.name AS uploader_name FROM resources r JOIN users u ON r.user_id=u.user_id WHERE r.resource_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, resourceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapResource(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void incrementDownloadCount(int resourceId) {
        String sql = "UPDATE resources SET download_count=download_count+1 WHERE resource_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, resourceId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public int getTotalResources() {
        String sql = "SELECT COUNT(*) FROM resources";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Resource mapResource(ResultSet rs) throws SQLException {
        Resource r = new Resource();
        r.setResourceId(rs.getInt("resource_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setSkillId(rs.getInt("skill_id"));
        r.setTitle(rs.getString("title"));
        r.setFileName(rs.getString("file_name"));
        r.setFileType(rs.getString("file_type"));
        r.setFilePath(rs.getString("file_path"));
        r.setDescription(rs.getString("description"));
        r.setCategory(rs.getString("category"));
        r.setDownloadCount(rs.getInt("download_count"));
        r.setUploadDate(rs.getString("upload_date"));
        r.setUploaderName(rs.getString("uploader_name"));
        return r;
    }
}
