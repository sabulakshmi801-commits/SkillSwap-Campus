package dao;

import model.Message;
import model.User;
import utility.DBConnection;
import java.sql.*;
import java.util.*;

public class MessageDAO {

    public boolean sendMessage(Message msg) {
        String sql = "INSERT INTO messages (sender_id,receiver_id,message) VALUES (?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, msg.getSenderId());
            ps.setInt(2, msg.getReceiverId());
            ps.setString(3, msg.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Message> getConversation(int userId1, int userId2) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT m.*, s.name AS sender_name, s.profile_photo AS sender_photo "
                   + "FROM messages m JOIN users s ON m.sender_id=s.user_id "
                   + "WHERE (m.sender_id=? AND m.receiver_id=?) OR (m.sender_id=? AND m.receiver_id=?) "
                   + "ORDER BY m.sent_time ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId1); ps.setInt(2, userId2);
            ps.setInt(3, userId2); ps.setInt(4, userId1);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapMessage(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<User> getChatContacts(int userId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT DISTINCT u.user_id, u.name, u.profile_photo, u.department, u.role "
                   + "FROM users u JOIN messages m ON (m.sender_id=u.user_id OR m.receiver_id=u.user_id) "
                   + "WHERE (m.sender_id=? OR m.receiver_id=?) AND u.user_id!=? ORDER BY u.name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setInt(2, userId); ps.setInt(3, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setName(rs.getString("name"));
                u.setProfilePhoto(rs.getString("profile_photo"));
                u.setDepartment(rs.getString("department"));
                u.setRole(rs.getString("role"));
                list.add(u);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public void markAsRead(int senderId, int receiverId) {
        String sql = "UPDATE messages SET is_read=1 WHERE sender_id=? AND receiver_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, senderId); ps.setInt(2, receiverId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM messages WHERE receiver_id=? AND is_read=0";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Message mapMessage(ResultSet rs) throws SQLException {
        Message m = new Message();
        m.setMessageId(rs.getInt("message_id"));
        m.setSenderId(rs.getInt("sender_id"));
        m.setReceiverId(rs.getInt("receiver_id"));
        m.setMessage(rs.getString("message"));
        m.setRead(rs.getBoolean("is_read"));
        m.setSentTime(rs.getString("sent_time"));
        m.setSenderName(rs.getString("sender_name"));
        m.setSenderPhoto(rs.getString("sender_photo"));
        return m;
    }
}
