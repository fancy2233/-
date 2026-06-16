<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User,com.dao.OrderDao,com.entity.Order,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"student".equals(user.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }

    OrderDao orderDao = new OrderDao();
    List<Order> orderList = orderDao.findOrderBySid(user.getId());

    Map<Integer,String> statusMap = new HashMap<>();
    statusMap.put(0,"待审核");
    statusMap.put(1,"已通过");
    statusMap.put(2,"已拒绝");
    statusMap.put(3,"已取消");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的预约</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:"Microsoft Yahei",sans-serif; }
        body { background:#f5f7fa; }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color:#fff; padding:15px 20px;
            display:flex; justify-content:space-between; align-items:center;
            box-shadow:0 2px 8px rgba(0,0,0,0.1);
        }
        .header h1 { font-size:20px; }
        .nav-btn { background:rgba(255,255,255,0.2); color:#fff; padding:8px 14px; border-radius:6px; text-decoration:none; font-size:14px; }
        .logout-btn { background:#fff; color:#667eea; padding:8px 14px; border:none; border-radius:6px; cursor:pointer; }

        .container { width:90%; max-width:1200px; margin:30px auto; }
        .card { background:#fff; border-radius:8px; padding:25px; box-shadow:0 2px 8px rgba(0,0,0,0.05); }
        .card h2 { font-size:20px; margin-bottom:20px; padding-bottom:10px; border-bottom:1px solid #eee; }

        table { width:100%; border-collapse:collapse; }
        table th, table td { padding:12px 15px; text-align:left; border-bottom:1px solid #eee; font-size:14px; }
        table th { background:#f8f9fa; font-weight:600; }

        .status0 { color:#f90; }
        .status1 { color:#2ecc71; }
        .status2 { color:#e74c3c; }
        .status3 { color:#999; }

        .back-btn { display:inline-block; margin-bottom:15px; color:#409eff; text-decoration:none; font-size:14px; }
        .cancel-btn { padding:6px 12px; background:#e74c3c; color:#fff; border:none; border-radius:4px; cursor:pointer; font-size:13px; }
        .cancel-btn:disabled { background:#999; cursor:not-allowed; }
    </style>
</head>
<body>

<div class="header">
    <h1>校园活动场地预约系统</h1>
    <div class="header-right">
        <span class="welcome">欢迎，<%=user.getName()%>（学生）</span>
        <a href="/SchoolSystem1/student/placeList.jsp" class="nav-btn">教室列表</a>
        <a href="/SchoolSystem1/logout" class="logout-btn">退出登录</a>
    </div>
</div>

<div class="container">
    <a href="placeList.jsp" class="back-btn">← 返回教室列表</a>

    <div class="card">
        <h2>我的预约记录</h2>
        <table>
            <thead>
                <tr>
                    <th>教室名称</th>
                    <th>学号</th>
                    <th>姓名</th>
                    <th>预约活动</th>
                    <th>预约日期</th> <!-- 新增 -->
                    <th>预约时段</th>
                    <th>备注</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <% if(orderList == null || orderList.isEmpty()) { %>
                    <tr><td colspan="9" align="center" style="color:#999;">暂无预约记录</td></tr>
                <% } else {
                    for(Order o : orderList){
                %>
                <tr>
                    <td><%=o.getPname()%></td>
                    <td><%=user.getUsername()%></td>
                    <td><%=o.getSname()%></td>
                    <td><%=o.getReason()%></td>
                    <td><%=o.getO_date()%></td> <!-- 新增 -->
                    <td><%=o.getTime_slots() == null ? "-" : o.getTime_slots()%></td>
                    <td><%=o.getRemark() != null ? o.getRemark() : "无"%></td>
                    <td class="status<%=o.getStatus()%>"><%=statusMap.get(o.getStatus())%></td>
                    <td>
                        <% if(o.getStatus() == 0) { %>
                            <button class="cancel-btn" onclick="cancelOrder(<%=o.getOid()%>)">取消</button>
                        <% } else { %>
                            <button class="cancel-btn" disabled>-</button>
                        <% } %>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    function cancelOrder(oid) {
        if(confirm("确定取消该预约吗？")){
            window.location.href = "/SchoolSystem1/student/cancelOrder?oid="+oid;
        }
    }
</script>
</body>
</html>