package com.servlet;

import com.dao.PlaceDao;
import com.entity.User;
import com.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/teacher/deletePlace")
public class DeletePlaceServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int pid = Integer.parseInt(request.getParameter("pid"));
        
        // 🔥 关键修改：获取当前登录老师的ID
        User teacher = (User) request.getSession().getAttribute("user");
        int tid = teacher.getId(); // 拿到老师ID
        
        PlaceDao placeDao = new PlaceDao();
        // 🔥 修复报错：调用带两个参数的 delete 方法
        placeDao.delete(pid, tid);
        
        // 删除后跳转到老师的教室列表
        response.sendRedirect(request.getContextPath() + "/teacher/placeList.jsp");
    }
}