package com.servlet.admin;

import com.dao.UserDao;
import com.entity.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/updateUser")
public class UpdateUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String name = request.getParameter("name");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            User u = new User();
            u.setId(id);
            u.setUsername(username);
            u.setName(name);
            u.setPassword(password);

            new UserDao().update(u);
            response.sendRedirect(role.equals("student") ? "studentList.jsp" : "teacherList.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}