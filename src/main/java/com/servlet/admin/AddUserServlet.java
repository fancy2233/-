package com.servlet.admin;


import com.dao.UserDao;
import com.entity.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/addUser")
public class AddUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            req.setCharacterEncoding("UTF-8");

            String username = req.getParameter("username");
            String name = req.getParameter("name");
            String password = req.getParameter("password");
            String role = req.getParameter("role"); // 关键：获取角色

            User user = new User();
            user.setUsername(username);
            user.setName(name);
            user.setPassword(password);
            user.setRole(role);

            UserDao dao = new UserDao();
            dao.add(user);

            // 🔥 核心修改：根据角色自动跳转对应列表
            if("student".equals(role)){
                // 添加学生 → 跳学生列表
                resp.sendRedirect("/SchoolSystem1/admin/studentList.jsp");
            } else if("teacher".equals(role)){
                // 添加教师 → 跳教师列表（完美解决你的问题！）
                resp.sendRedirect("/SchoolSystem1/admin/teacherList.jsp");
            } else {
                // 兜底：跳管理员首页
                resp.sendRedirect("/SchoolSystem1/admin/index.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}