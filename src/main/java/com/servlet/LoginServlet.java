package com.servlet;

import com.dao.UserDao;
import com.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/userLogin")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        // ====================== 【新增：获取角色】 ======================
        String role = req.getParameter("role");

        UserDao dao = new UserDao();
        // ====================== 【修改：调用带角色的登录方法】 ======================
        User user = dao.loginByRole(username, password, role);

        if (user == null) {
            // ====================== 【修改：错误提示更精准】 ======================
            req.setAttribute("msg", "账号、密码或角色错误");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        } else {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            if ("student".equals(user.getRole())) {
                resp.sendRedirect("student/placeList.jsp");
            } else if ("teacher".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/teacher/index.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/index.jsp");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}