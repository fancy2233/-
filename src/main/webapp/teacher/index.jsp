<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"teacher".equals(user.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>教师管理端</title>
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
        .welcome { font-size:15px; }
        .logout-btn {
            background:#fff; color:#667eea;
            border:none; padding:8px 14px; border-radius:6px;
            font-size:14px; cursor:pointer; text-decoration:none;
        }
        .container {
            width:90%; max-width:1200px; margin:30px auto;
            display:grid; grid-template-columns:200px 1fr; gap:20px;
        }
        .sidebar {
            background:#fff; border-radius:8px; padding:15px;
            box-shadow:0 2px 8px rgba(0,0,0,0.05);
        }
        .menu-item {
            display:block; padding:12px 15px; margin-bottom:8px;
            border-radius:6px; font-size:15px; text-decoration:none;
            color:#333; transition:background 0.2s;
        }
        .menu-item:hover { background:#f0f0f0; }
        .menu-item.active { background:#409eff; color:#fff; }
        .content {
            background:#fff; border-radius:8px; padding:25px;
            box-shadow:0 2px 8px rgba(0,0,0,0.05);
            text-align:center; line-height:2;
        }
        .content h2 { margin-bottom:20px; }
    </style>
</head>
<body>
<div class="header">
    <h1>校园场地预约系统（教师端）</h1>
    <div>
        <span class="welcome">欢迎，<%=user.getName()%></span>
        <a href="/SchoolSystem1/logout" class="logout-btn">退出登录</a>
    </div>
</div>

<div class="container">
    <div class="sidebar">
        <a href="/SchoolSystem1/teacher/orderList.jsp" class="menu-item">预约管理</a>
        <a href="/SchoolSystem1/teacher/placeList.jsp" class="menu-item">教室管理</a>
    </div>
    <div class="content">
        <h2>教师审核中心</h2>
        <p>左侧菜单可进行预约审核与教室查看</p>
    </div>
</div>
</body>
</html>