package controller;

import dao.MessageDAO;
import dao.NotificationDAO;
import dao.UserDAO;
import model.Message;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ChatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        String action = request.getParameter("action");
        MessageDAO messageDAO = new MessageDAO();
        UserDAO    userDAO    = new UserDAO();

        // AJAX: fetch conversation messages
        if ("getMessages".equals(action)) {
            int receiverId = Integer.parseInt(request.getParameter("receiverId"));
            messageDAO.markAsRead(receiverId, user.getUserId());
            List<Message> messages = messageDAO.getConversation(user.getUserId(), receiverId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < messages.size(); i++) {
                Message m = messages.get(i);
                String txt   = escape(m.getMessage());
                String sName = escape(m.getSenderName());
                String time  = m.getSentTime() != null ? m.getSentTime() : "";
                sb.append("{")
                  .append("\"messageId\":").append(m.getMessageId()).append(",")
                  .append("\"senderId\":").append(m.getSenderId()).append(",")
                  .append("\"message\":\"").append(txt).append("\",")
                  .append("\"sentTime\":\"").append(time).append("\",")
                  .append("\"senderName\":\"").append(sName).append("\"")
                  .append("}");
                if (i < messages.size() - 1) sb.append(",");
            }
            sb.append("]");
            response.getWriter().print(sb.toString());
            return;
        }

        // Normal page load
        String chatWithStr = request.getParameter("with");
        if (chatWithStr != null && !chatWithStr.isEmpty()) {
            int chatWithId = Integer.parseInt(chatWithStr);
            User chatWith = userDAO.getUserById(chatWithId);
            request.setAttribute("chatWith", chatWith);
        }

        request.setAttribute("contacts", messageDAO.getChatContacts(user.getUserId()));
        request.setAttribute("allUsers", userDAO.getAllUsers());
        request.getRequestDispatcher("/jsp/chat.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.setStatus(401);
            response.getWriter().print("{\"success\":false}");
            return;
        }

        User user        = (User) session.getAttribute("loggedUser");
        int receiverId   = Integer.parseInt(request.getParameter("receiverId"));
        String msgText   = request.getParameter("message");

        if (msgText == null || msgText.trim().isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().print("{\"success\":false}");
            return;
        }

        Message msg = new Message();
        msg.setSenderId(user.getUserId());
        msg.setReceiverId(receiverId);
        msg.setMessage(msgText.trim());

        MessageDAO messageDAO = new MessageDAO();
        boolean sent = messageDAO.sendMessage(msg);

        // Notify receiver
        if (sent) {
            NotificationDAO notifDAO = new NotificationDAO();
            String preview = msgText.length() > 50 ? msgText.substring(0, 50) + "..." : msgText;
            notifDAO.addNotification(receiverId,
                "New Chat Message",
                user.getName() + ": " + preview,
                "message",
                user.getUserId());
        }

        response.setContentType("application/json");
        response.getWriter().print("{\"success\":" + sent + "}");
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "");
    }
}
