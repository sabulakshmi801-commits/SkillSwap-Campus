package controller;

import dao.SkillDAO;
import dao.NotificationDAO;
import model.Skill;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AddSkillServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/jsp/addSkill.jsp").forward(request, response);
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
        String action = request.getParameter("action");

        SkillDAO skillDAO = new SkillDAO();

        if ("delete".equals(action)) {
            int skillId = Integer.parseInt(request.getParameter("skillId"));
            skillDAO.deleteSkill(skillId, user.getUserId());
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // Add skill
        Skill skill = new Skill();
        skill.setUserId(user.getUserId());
        skill.setSkillName(request.getParameter("skillName"));
        skill.setCategory(request.getParameter("category"));
        skill.setDescription(request.getParameter("description"));
        skill.setExperienceLevel(request.getParameter("experienceLevel"));
        skill.setAvailability(request.getParameter("availability"));

        if (skillDAO.addSkill(skill)) {
            // Notify connections
            response.sendRedirect(request.getContextPath() + "/skills?success=Skill+added+successfully");
        } else {
            request.setAttribute("error", "Failed to add skill. Please try again.");
            request.getRequestDispatcher("/jsp/addSkill.jsp").forward(request, response);
        }
    }
}
