<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User,com.dao.OrderDao,com.entity.Order,java.util.*" %>
<%
    User admin = (User) session.getAttribute("user");
    if(admin == null || !"admin".equals(admin.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }

    // 获取筛选参数
    String stuStart = request.getParameter("stuStart");
    String stuEnd   = request.getParameter("stuEnd");
    String optStart = request.getParameter("optStart");
    String optEnd   = request.getParameter("optEnd");

    OrderDao orderDao = new OrderDao();
    // 调用修复后的筛选方法，完整包含老师信息
    List<Order> orderList = orderDao.listByFilter(stuStart, stuEnd, optStart, optEnd);

    Map<Integer,String> statusMap = new HashMap<>();
    statusMap.put(0,"待审核");
    statusMap.put(1,"已通过");
    statusMap.put(2,"已拒绝");
    statusMap.put(3,"已取消");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>预约信息管理</title>
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
            width:95%; max-width:1400px; margin:30px auto;
            display:grid; grid-template-columns:200px 1fr; gap:20px;
        }
        .sidebar {
            background:#fff; border-radius:8px; padding:15px;
            box-shadow:0 2px 8px rgba(0,0,0,0.05);
        }
        .menu-item {
            display:block; padding:12px 15px; margin-bottom:8px;
            border-radius:6px; text-decoration:none; color:#333;
        }
        .menu-item.active { background:#409eff; color:#fff; }

        .content {
            background:#fff; border-radius:8px; padding:25px;
            box-shadow:0 2px 8px rgba(0,0,0,0.05);
        }
        .content h2 {
            font-size:20px; margin-bottom:15px;
            padding-bottom:10px; border-bottom:1px solid #eee;
        }

        /* 筛选条 */
        .filter-box {
            padding:12px 15px; background:#f8f9fa;
            border-radius:6px; margin-bottom:20px;
            display:flex; gap:15px; align-items:center; flex-wrap:wrap;
        }
        .filter-item { display:flex; align-items:center; gap:6px; }
        .filter-item label { font-size:14px; color:#666; }
        .filter-item input {
            height:34px; padding:0 8px; border:1px solid #ddd;
            border-radius:4px; font-size:14px;
        }
        .search-btn {
            background:#409eff; color:#fff; border:none;
            padding:0 15px; height:34px; border-radius:4px; cursor:pointer;
        }
        .reset-btn {
            background:#909399; color:#fff; border:none;
            padding:0 15px; height:34px; border-radius:4px; cursor:pointer;
        }

        table { width:100%; border-collapse:collapse; }
        th,td { padding:10px 8px; text-align:left; border-bottom:1px solid #eee; font-size:14px; }
        th { background:#f8f9fa; font-weight:600; white-space:nowrap; }
        .status0 { color:#f90; font-weight:bold; }
        .status1 { color:#27ae60; font-weight:bold; }
        .status2 { color:#e74c3c; font-weight:bold; }
        .status3 { color:#999; }
    </style>
</head>
<body>

<div class="header">
    <h1>管理员后台</h1>
    <a href="/SchoolSystem1/logout" class="logout-btn">退出登录</a>
</div>

<div class="container">
    <div class="sidebar">
        <a href="index.jsp" class="menu-item">控制台首页</a>
        <a href="studentList.jsp" class="menu-item">学生信息管理</a>
        <a href="teacherList.jsp" class="menu-item">教师信息管理</a>
        <a href="orderList.jsp" class="menu-item active">预约信息管理</a>
        <a href="placeList.jsp" class="menu-item">教室信息管理</a>
    </div>

    <div class="content">
        <h2>预约信息管理</h2>

        <!-- 双时间筛选条 -->
        <form action="orderList.jsp" method="get" class="filter-box">
            <div class="filter-item">
                <label>学生预约：</label>
                <input type="date" name="stuStart" value="<%=stuStart!=null ? stuStart : ""%>">
                <span>~</span>
                <input type="date" name="stuEnd" value="<%=stuEnd!=null ? stuEnd : ""%>">
            </div>
            <div class="filter-item">
                <label>老师操作：</label>
                <input type="date" name="optStart" value="<%=optStart!=null ? optStart : ""%>">
                <span>~</span>
                <input type="date" name="optEnd" value="<%=optEnd!=null ? optEnd : ""%>">
            </div>
            <button type="submit" class="search-btn">筛选</button>
            <button type="button" class="reset-btn" onclick="window.location.href='orderList.jsp'">重置</button>
        </form>

        <table>
            <tr>
                <th>学号</th>
                <th>姓名</th>
                <th>教室名称</th>
                <th>预约活动</th>
                <th>预约日期</th>
                <th>预约时段</th>
                <th>备注</th>
                <th>审核状态</th>
                <th>老师工号</th>
                <th>老师姓名</th>
                <th>操作时间</th>
            </tr>

            <% if(orderList == null || orderList.isEmpty()){ %>
                <tr><td colspan="11" align="center">暂无预约记录</td></tr>
            <% }else{ for(Order o : orderList){ %>
            <tr>
                <!-- 🔥 只改这一行：sid → studentNo -->
                <td><%=o.getStudentNo()%></td>
                <td><%=o.getSname()%></td>
                <td><%=o.getPname()%></td>
                <td><%=o.getReason()%></td>
                <td><%=o.getO_date()%></td>
                <td><%=o.getTime_slots()%></td>
                <td><%=o.getRemark() == null ? "" : o.getRemark()%></td>
                <td class="status<%=o.getStatus()%>"><%=statusMap.get(o.getStatus())%></td>
                <td><%=o.getStatus() == 0 ? "" : o.getTid()%></td>
                <td><%=o.getStatus() == 0 ? "" : (o.getTname() == null ? "" : o.getTname())%></td>
                <td><%=o.getStatus() == 0 ? "" : (o.getOperate_time() == null ? "" : o.getOperate_time())%></td>
            </tr>
            <% } } %>
        </table>
    </div>
</div>
</body>
</html>