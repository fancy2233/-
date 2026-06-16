package com.servlet;

import com.dao.OrderDao;
import com.entity.Order;
import com.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/student/addOrder")
public class AddOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 1. 获取用户信息
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"student".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }

        // 2. 获取前端参数
        int pid = Integer.parseInt(request.getParameter("pid"));
        String date = request.getParameter("date");
        String activity = request.getParameter("activity");
        String tids = request.getParameter("tids"); // 前端传的是 "1,2,3..." 格式
        String remark = request.getParameter("remark");

        // 3. 校验参数
        if (activity == null || activity.trim().isEmpty() || tids == null || tids.trim().isEmpty()) {
            response.getWriter().write("<script>alert('请填写活动名称并选择时段！');history.back();</script>");
            return;
        }

        // ==============================================
        // 🔧 核心修复：时间段映射 + 拼接（100% 保证能显示）
        // ==============================================
        Map<String, String> slotMap = new LinkedHashMap<>();
        slotMap.put("1", "07:00-08:00");
        slotMap.put("2", "08:00-09:00");
        slotMap.put("3", "09:00-10:00");
        slotMap.put("4", "10:00-11:00");
        slotMap.put("5", "11:00-12:00");
        slotMap.put("6", "12:00-13:00");
        slotMap.put("7", "13:00-14:00");
        slotMap.put("8", "14:00-15:00");
        slotMap.put("9", "15:00-16:00");
        slotMap.put("10", "16:00-17:00");
        slotMap.put("11", "17:00-18:00");
        slotMap.put("12", "18:00-19:00");
        slotMap.put("13", "19:00-20:00");
        slotMap.put("14", "20:00-21:00");

        StringBuilder timeSlotsStr = new StringBuilder();
        String[] tidArr = tids.split(",");
        for (String tid : tidArr) {
            if (slotMap.containsKey(tid)) {
                timeSlotsStr.append(slotMap.get(tid)).append(" ");
            }
        }

        // 4. 构造订单对象，存入所有信息
        String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        Order order = new Order();
        order.setSid(user.getId());
        order.setPid(pid);
        order.setReason(activity);
        order.setTime_slots(timeSlotsStr.toString().trim()); // ✅ 这里存时间段！
        order.setO_date(date); // ✅ 存预约日期
        order.setApply_time(now);
        order.setRemark(remark != null ? remark : "");
        order.setStatus(0);

        // 5. 存入数据库
        OrderDao dao = new OrderDao();
        dao.add(order);

        // 6. 跳转到我的预约
        response.sendRedirect("myOrder.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}