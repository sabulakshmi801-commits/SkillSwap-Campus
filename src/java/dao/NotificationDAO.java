package dao;

import model.Notification;
import utility.DBConnection;
import java.sql.*;
import java.util.*;

public class NotificationDAO {

    private static boolean hasReferenceColumn(Connection con) {
        try (ResultSet rs = con.getMetaData().getColumns(null, null, "notifications", "reference_id")) {
            return rs.next();
        } catch (SQLException e) {
            return false;
        }
    }

    public void addNotification(int userId, String title, String message, String type) {
        addNotification(userId, title, message, type, 0);
    }

    public void addNotification(int userId, String title, String message, String type, int referenceId) {
        try (Connection con = DBConnection.getConnection()) {
            if (hasReferenceColumn(con)) {
                String sql = "INSERT INTO notifications (user_id, title, message, type, reference_id) VALUES (?,?,?,?,?)";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    ps.setString(2, title);
                    ps.setString(3, message);
                    ps.setString(4, type);
                    ps.setInt(5, referenceId);
                    ps.executeUpdate();
                    return;
                }
            }
            String msg = message;
            if (referenceId > 0) {
                msg = "REF:" + referenceId + "|" + message;
            }
            String sql = "INSERT INTO notifications (user_id, title, message, type) VALUES (?,?,?,?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, title);
                ps.setString(3, msg);
                ps.setString(4, type);
                ps.executeUpdate();
            }
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public List<Notification> getNotificationsByType(int userId, String type) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id=? AND type=? ORDER BY created_at DESC LIMIT 20";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, type);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapNotification(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Notification> getNotifications(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id=? ORDER BY created_at DESC LIMIT 30";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapNotification(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id=? AND is_read=0";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public void markAsRead(int notificationId, int userId) {
        String sql = "UPDATE notifications SET is_read=1 WHERE notification_id=? AND user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void markAllRead(int userId) {
        String sql = "UPDATE notifications SET is_read=1 WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private Notification mapNotification(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notification_id"));
        n.setUserId(rs.getInt("user_id"));
        n.setTitle(rs.getString("title"));
        n.setMessage(rs.getString("message"));
        n.setType(rs.getString("type"));
        try {
            n.setReferenceId(rs.getInt("reference_id"));
        } catch (SQLException ignored) {
            n.setReferenceId(0);
        }
        if (n.getReferenceId() <= 0) {
            n.setReferenceId(parseLegacyReference(n.getMessage(), n.getType()));
        }
        n.setRead(rs.getBoolean("is_read"));
        n.setCreatedAt(rs.getString("created_at"));
        return n;
    }

    private int parseLegacyReference(String message, String type) {
        if (message == null || !message.startsWith("REF:")) return 0;
        try {
            int pipe = message.indexOf('|');
            if (pipe > 4) return Integer.parseInt(message.substring(4, pipe));
        } catch (NumberFormatException ignored) {}
        return 0;
    }
}
