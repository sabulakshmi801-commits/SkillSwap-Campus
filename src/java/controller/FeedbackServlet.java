package controller;

import dao.FeedbackDAO;
import dao.SessionDAO;
import dao.UserDAO;
import dao.NotificationDAO;
import model.Feedback;
import model.LearningSession;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String sessionIdStr = request.getParameter("sessionId");
        if (sessionIdStr != null) {
            SessionDAO sessionDAO = new SessionDAO();
            LearningSession ls = sessionDAO.getSessionById(Integer.parseInt(sessionIdStr));
            request.setAttribute("sessionForFeedback", ls);
        }
        request.getRequestDispatcher("/jsp/feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");

        int sessionId  = Integer.parseInt(request.getParameter("sessionId"));
        int revieweeId = Integer.parseInt(request.getParameter("revieweeId"));
        int rating;
        try { rating = Integer.parseInt(request.getParameter("rating")); }
        catch (NumberFormatException e) { rating = 5; }
        String comments = request.getParameter("comments");

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        if (feedbackDAO.hasFeedback(sessionId, user.getUserId())) {
            request.setAttribute("error", "You have already submitted feedback for this session.");
            request.getRequestDispatcher("/jsp/feedback.jsp").forward(request, response);
            return;
        }

        Feedback fb = new Feedback();
        fb.setSessionId(sessionId);
        fb.setReviewerId(user.getUserId());
        fb.setRevieweeId(revieweeId);
        fb.setRating(rating);
        fb.setComments(comments);

        if (feedbackDAO.addFeedback(fb)) {
            // Update avg rating
            new UserDAO().updateRating(revieweeId);
            // Notify reviewee
            new NotificationDAO().addNotification(revieweeId,
                "New Feedback",
                user.getName() + " gave you a " + rating + "-star rating!",
                "feedback");
            response.sendRedirect(request.getContextPath() + "/session?success=Feedback+submitted");
        } else {
            request.setAttribute("error", "Failed to submit feedback.");
            request.getRequestDispatcher("/jsp/feedback.jsp").forward(request, response);
        }
    }
}
