package com.servlet;

import com.dao.OrderDao;
import com.entity.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/teacher/check")
public class CheckOrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        User teacher = (User) session.getAttribute("user");

        // 1. 校验登录状态，防止空指针
        if (teacher == null || !"teacher".equals(teacher.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 2. 获取参数
        int oid = Integer.parseInt(req.getParameter("oid"));
        int status = Integer.parseInt(req.getParameter("status"));

        // 3. 调用审核方法
        OrderDao orderDao = new OrderDao();
        orderDao.checkWithTeacher(oid, status, teacher.getUsername());

        // 关键：加随机参数，强制浏览器不缓存页面
        resp.sendRedirect(req.getContextPath() + "/teacher/orderList.jsp?r=" + System.currentTimeMillis());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doGet(req, resp);
    }
}