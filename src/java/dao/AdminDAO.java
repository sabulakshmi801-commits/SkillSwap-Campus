package dao;

import utility.DBConnection;
import java.sql.*;
import java.util.*;

public class AdminDAO {

    public Map<String, Integer> getAnalytics() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        try (Connection con = DBConnection.getConnection()) {
            String[][] queries = {
                {"totalUsers",       "SELECT COUNT(*) FROM users WHERE role!='admin'"},
                {"totalStudents",    "SELECT COUNT(*) FROM users WHERE role='student'"},
                {"totalFaculty",     "SELECT COUNT(*) FROM users WHERE role='faculty'"},
                {"totalSkills",      "SELECT COUNT(*) FROM skills WHERE is_active=1"},
                {"totalSessions",    "SELECT COUNT(*) FROM sessions"},
                {"completedSessions","SELECT COUNT(*) FROM sessions WHERE status='Completed'"},
                {"pendingSessions",  "SELECT COUNT(*) FROM sessions WHERE status='Pending'"},
                {"totalResources",   "SELECT COUNT(*) FROM resources"},
                {"totalMessages",    "SELECT COUNT(*) FROM messages"}
            };
            for (String[] q : queries) {
                ResultSet rs = con.createStatement().executeQuery(q[1]);
                if (rs.next()) stats.put(q[0], rs.getInt(1));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }

    public List<Map<String, String>> getDepartmentStats() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT department, COUNT(*) AS cnt FROM users WHERE role!='admin' AND department IS NOT NULL GROUP BY department ORDER BY cnt DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, String> m = new LinkedHashMap<>();
                m.put("department", rs.getString("department"));
                m.put("count", String.valueOf(rs.getInt("cnt")));
                list.add(m);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getPopularSkills() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT skill_name, COUNT(*) AS cnt FROM sessions WHERE skill_name IS NOT NULL GROUP BY skill_name ORDER BY cnt DESC LIMIT 10";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, String> m = new LinkedHashMap<>();
                m.put("skill", rs.getString("skill_name"));
                m.put("count", String.valueOf(rs.getInt("cnt")));
                list.add(m);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getMonthlySessionStats() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(created_at,'%b') AS month, COUNT(*) AS cnt FROM sessions "
                   + "WHERE created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH) GROUP BY DATE_FORMAT(created_at,'%Y-%m') ORDER BY created_at";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, String> m = new LinkedHashMap<>();
                m.put("month", rs.getString("month"));
                m.put("count", String.valueOf(rs.getInt("cnt")));
                list.add(m);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
