<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User,com.dao.PlaceDao,com.entity.Place,java.util.*" %>
<%
    User admin = (User) session.getAttribute("user");
    if(admin == null || !"admin".equals(admin.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }
    PlaceDao dao = new PlaceDao();
    // 🔥 改回只查老师操作过的方法
    List<Place> list = dao.listAllForAdmin();
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>教室信息汇总</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:"Microsoft Yahei",sans-serif; }
        body { background:#f5f7fa; }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color:#fff; padding:15px 20px;
            display:flex; justify-content:space-between; align-items:center;
        }
        .logout-btn { background:#fff; color:#667eea; padding:8px 14px; border-radius:6px; text-decoration:none; }
        .container { width:90%; max-width:1400px; margin:30px auto; display:grid; grid-template-columns:200px 1fr; gap:20px; }
        .sidebar { background:#fff; border-radius:8px; padding:15px; box-shadow:0 2px 8px rgba(0,0,0,0.05); }
        .menu-item { display:block; padding:12px 15px; margin-bottom:8px; border-radius:6px; text-decoration:none; color:#333; }
        .menu-item.active { background:#409eff; color:#fff; }
        .content { background:#fff; border-radius:8px; padding:25px; box-shadow:0 2px 8px rgba(0,0,0,0.05); }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:10px; text-align:left; border-bottom:1px solid #eee; }
        th { background:#f8f9fa; }
    </style>
</head>
<body>
<div class="header">
    <h1>管理员后台</h1>
    <a href="/SchoolSystem1/logout" class="logout-btn">退出</a>
</div>
<div class="container">
    <div class="sidebar">
        <a href="index.jsp" class="menu-item">控制台首页</a>
        <a href="studentList.jsp" class="menu-item">学生信息管理</a>
        <a href="teacherList.jsp" class="menu-item">教师信息管理</a>
        <a href="orderList.jsp" class="menu-item">预约信息管理</a>
        <a href="placeList.jsp" class="menu-item active">教室信息管理</a>
    </div>
    <div class="content">
        <h2>教室操作记录汇总</h2>
        <table>
            <tr>
                <th>教室名称</th>
                <th>设备</th>
                <th>容量</th>
                <th>开放时间</th>
                <th>老师工号</th>
                <th>老师姓名</th>
                <th>操作类型</th>
                <th>操作时间</th>
            </tr>
            <% if(list == null || list.isEmpty()){ %>
            <tr><td colspan="8" align="center">暂无老师操作记录</td></tr>
            <% } else { for(Place p : list) { %>
            <tr>
                <td><%=p.getPname()%></td>
                <td><%=p.getEquipment()%></td>
                <td><%=p.getMax_num()%></td>
                <td><%=p.getOpen_time()%></td>
                <td><%=p.getUsername()%></td>
                <td><%=p.getTname()%></td>
                <td><%=p.getOperateType()%></td>
                <td><%=p.getUpdateTime()%></td>
            </tr>
            <% } } %>
        </table>
    </div>
</div>
</body>
</html>