<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User" %>
<%
    User admin = (User) session.getAttribute("user");
    if(admin == null || !"admin".equals(admin.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员后台</title>
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
            width:90%; max-width:1200px; margin:30px auto;
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
            font-size:20px; margin-bottom:20px;
            padding-bottom:10px; border-bottom:1px solid #eee;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>管理员后台</h1>
    <a href="/SchoolSystem1/logout" class="logout-btn">退出登录</a>
</div>
<div class="container">
    <div class="sidebar">
        <a href="index.jsp" class="menu-item active">控制台首页</a>
        <a href="studentList.jsp" class="menu-item">学生信息管理</a>
        <a href="teacherList.jsp" class="menu-item">教师信息管理</a>
        <a href="orderList.jsp" class="menu-item">预约信息管理</a>
        <a href="placeList.jsp" class="menu-item">教室信息管理</a>
    </div>
    <div class="content">
        <h2>欢迎进入管理员控制台</h2>
        <p>您可以管理学生、教师、预约、教室信息</p>
    </div>
</div>
</body>
</html>