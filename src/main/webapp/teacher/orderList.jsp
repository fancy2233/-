<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User,com.dao.OrderDao,com.entity.Order,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"teacher".equals(user.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }
    OrderDao orderDao = new OrderDao();
    List<Order> allOrderList = orderDao.listAll();

    String filterStatus = request.getParameter("status");
    List<Order> orderList = new ArrayList<>();

    if(filterStatus == null || filterStatus.isEmpty() || "all".equals(filterStatus)){
        orderList = allOrderList;
    } else {
        int status = Integer.parseInt(filterStatus);
        for(Order o : allOrderList){
            if(o.getStatus() == status){
                orderList.add(o);
            }
        }
    }

    Map<Integer,String> statusMap = new HashMap<>();
    statusMap.put(0,"待审核");
    statusMap.put(1,"已通过");
    statusMap.put(2,"已拒绝");
    statusMap.put(3,"已取消");

    Map<Integer,String> colorMap = new HashMap<>();
    colorMap.put(0,"#f90");
    colorMap.put(1,"#2ecc71");
    colorMap.put(2,"#e74c3c");
    colorMap.put(3,"#999");

    String currentStatus = filterStatus == null ? "all" : filterStatus;
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>预约审核</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:"Microsoft Yahei",sans-serif; }
        body { background:#f5f7fa; }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color:#fff; padding:15px 20px;
            display:flex; justify-content:space-between; align-items:center;
        }
        .logout-btn {
            background:#fff; color:#667eea;
            border:none; padding:8px 14px; border-radius:6px;
            cursor:pointer; text-decoration:none;
        }
        .container {
            width:90%; max-width:1400px; margin:30px auto;
            display:flex; gap:20px;
        }
        .sidebar {
            width:200px; background:#fff; border-radius:8px; padding:15px;
            box-shadow:0 2px 8px rgba(0,0,0,0.05);
        }
        .menu-item {
            display:block; padding:12px 15px; margin-bottom:8px;
            border-radius:6px; text-decoration:none; color:#333;
        }
        .menu-item.active { background:#409eff; color:#fff; }
        .content {
            flex:1; background:#fff; border-radius:8px; padding:25px;
            box-shadow:0 2px 8px rgba(0,0,0,0.05);
        }
        .content h2 {
            font-size:20px; margin-bottom:20px;
            padding-bottom:10px; border-bottom:1px solid #eee;
        }
        .filter-buttons {
            display:flex; gap:10px; margin-bottom:20px; flex-wrap:wrap;
        }
        .filter-btn {
            padding:8px 16px; border:1px solid #e4e7ed;
            border-radius:6px; background:#fff; color:#333;
            cursor:pointer; text-decoration:none; font-size:14px;
        }
        .filter-btn.active {
            background:#409eff; color:#fff; border-color:#409eff;
        }
        table { width:100%; border-collapse:collapse; table-layout:fixed; }
        th,td { padding:12px; text-align:left; border-bottom:1px solid #eee; font-size:14px; vertical-align:middle; }
        th { background:#f8f9fa; }
        .status { font-weight:bold; }
        
        /* 按钮样式修复 */
        .btn-box { 
            white-space:nowrap; 
            display:flex; 
            gap:4px;
        }
        .btn { 
            padding:5px 10px; 
            border:none; 
            border-radius:4px; 
            color:#fff; 
            cursor:pointer; 
            font-size:12px; 
            flex-shrink:0;
        }
        .btn-pass { background:#2ecc71; }
        .btn-reject { background:#e74c3c; }
        .back { display:inline-block; margin-bottom:15px; color:#409eff; text-decoration:none; }

        /* 固定列宽，防止挤变形 */
        th:nth-child(1),td:nth-child(1) { width:90px; }
        th:nth-child(2),td:nth-child(2) { width:70px; }
        th:nth-child(5),td:nth-child(5) { width:100px; }
        th:nth-child(6),td:nth-child(6) { width:160px; }
        th:nth-child(9),td:nth-child(9) { width:120px; }
    </style>
</head>
<body>
<div class="header">
    <h1>预约审核</h1>
    <a href="/SchoolSystem1/logout" class="logout-btn">退出</a>
</div>

<div class="container">
    <div class="sidebar">
        <a href="/SchoolSystem1/teacher/orderList.jsp" class="menu-item active">预约管理</a>
        <a href="/SchoolSystem1/teacher/placeList.jsp" class="menu-item">教室管理</a>
    </div>

    <div class="content">
        <a href="index.jsp" class="back">← 返回首页</a>
        <h2>学生预约列表</h2>

        <div class="filter-buttons">
            <a href="orderList.jsp?status=all" class="filter-btn <%="all".equals(currentStatus) ? "active" : ""%>">全部</a>
            <a href="orderList.jsp?status=0" class="filter-btn <%="0".equals(currentStatus) ? "active" : ""%>">待审核</a>
            <a href="orderList.jsp?status=1" class="filter-btn <%="1".equals(currentStatus) ? "active" : ""%>">已通过</a>
            <a href="orderList.jsp?status=2" class="filter-btn <%="2".equals(currentStatus) ? "active" : ""%>">已拒绝</a>
            <a href="orderList.jsp?status=3" class="filter-btn <%="3".equals(currentStatus) ? "active" : ""%>">已取消</a>
        </div>

        <table>
            <tr>
                <th>学号</th>
                <th>姓名</th>
                <th>教室名称</th>
                <th>预约活动</th>
                <th>预约日期</th>
                <th>预约时段</th>
                <th>备注</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
            <% if(orderList == null || orderList.isEmpty()) { %>
            <tr><td colspan="9" align="center" style="color:#999;">暂无相关预约记录</td></tr>
            <% } else {
                for(Order o : orderList) { %>
            <tr>
                <td><%=o.getStudentNo()%></td>
                <td><%=o.getSname()%></td>
                <td><%=o.getPname()%></td>
                <td><%=o.getReason()%></td>
                <td><%=o.getO_date() == null ? "-" : o.getO_date()%></td>
                <td><%=o.getTime_slots() == null ? "-" : o.getTime_slots()%></td>
                <td><%=o.getRemark() == null ? "-" : o.getRemark()%></td>
                <td style="color:<%=colorMap.get(o.getStatus())%>"><%=statusMap.get(o.getStatus())%></td>
                <td>
                    <div class="btn-box">
                    <% if(o.getStatus() == 0) { %>
                    <a href="/SchoolSystem1/teacher/check?oid=<%=o.getOid()%>&status=1" class="btn btn-pass">通过</a>
                    <a href="/SchoolSystem1/teacher/check?oid=<%=o.getOid()%>&status=2" class="btn btn-reject">拒绝</a>
                    <% } else { %> — <% } %>
                    </div>
                </td>
            </tr>
            <% } } %>
        </table>
    </div>
</div>
</body>
</html>