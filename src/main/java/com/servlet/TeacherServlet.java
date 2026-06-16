package com.servlet;
import com.dao.OrderDao;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
@WebServlet("/teacher/test")
public class TeacherServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int oid = Integer.parseInt(req.getParameter("oid"));
        int status = Integer.parseInt(req.getParameter("status"));
        OrderDao dao = new OrderDao();
        dao.check(oid, status);
        resp.sendRedirect("/SchoolSystem1/teacher/check.jsp");
    }
}