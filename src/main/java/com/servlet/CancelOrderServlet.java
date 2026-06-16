package com.servlet;

import com.dao.OrderDao;
import com.dao.PlaceTimeDao;
import com.entity.Order;
import com.entity.PlaceTime;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/cancelOrder")
public class CancelOrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int oid = Integer.parseInt(request.getParameter("oid"));
        OrderDao orderDao = new OrderDao();
        Order order = orderDao.findById(oid);

        if(order != null && order.getStatus() == 0) {
            // 1. 更新订单状态为3（已取消）
            orderDao.check(oid, 3);

            // 2. 恢复 place_time 状态为0（空闲）
            PlaceTimeDao timeDao = new PlaceTimeDao();
            List<PlaceTime> timeList = timeDao.getTimeByDateAndPid(order.getO_date(), order.getPid());
            String[] slots = order.getTime_slots().split(" ");
            for(String slot : slots){
                for(PlaceTime pt : timeList){
                    if(pt.getTime_slot().equals(slot)){
                        timeDao.updateStatus(pt.getTid(), 0);
                    }
                }
            }
        }

        response.sendRedirect("myOrder.jsp");
    }
}