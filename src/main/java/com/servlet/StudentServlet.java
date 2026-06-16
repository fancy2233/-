package com.servlet;
import com.dao.OrderDao; import com.entity.Order; import com.entity.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
@WebServlet("/student/apply")
public class StudentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        int pid = Integer.parseInt(req.getParameter("pid"));
        String reason = req.getParameter("reason");
        String time = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());
        Order order = new Order();
        order.setSid(user.getId());
        order.setPid(pid);
        order.setReason(reason);
        order.setApply_time(time);
        OrderDao dao = new OrderDao();
        dao.add(order);
        resp.sendRedirect("/SchoolSystem1/student/order.jsp");
    }
}