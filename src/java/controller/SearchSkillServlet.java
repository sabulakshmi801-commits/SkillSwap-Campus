package controller;

import dao.SkillDAO;
import model.Skill;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class SearchSkillServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        String keyword  = request.getParameter("keyword");
        String category = request.getParameter("category");

        SkillDAO skillDAO = new SkillDAO();
        List<Skill> skills;

        if (keyword != null && !keyword.trim().isEmpty()) {
            skills = skillDAO.searchSkillsExceptUser(keyword.trim(), category, user.getUserId());
        } else {
            skills = skillDAO.getAllSkillsExceptUser(user.getUserId());
        }

        request.setAttribute("skills",   skills);
        request.setAttribute("keyword",  keyword);
        request.setAttribute("category", category);
        request.getRequestDispatcher("/jsp/skills.jsp").forward(request, response);
    }
}
