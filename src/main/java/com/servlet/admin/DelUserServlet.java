package com.servlet.admin;

import com.dao.UserDao;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/delUser")
public class DelUserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String role = request.getParameter("role");
            new UserDao().delete(id);
            response.sendRedirect(role.equals("student") ? "studentList.jsp" : "teacherList.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}