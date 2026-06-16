<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User,com.dao.UserDao,java.util.*" %>
<%
    User admin = (User) session.getAttribute("user");
    if(admin == null || !"admin".equals(admin.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }
    UserDao dao = new UserDao();
    List<User> list = dao.listByRole("teacher");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>教师信息管理</title>
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
        .bar { display:flex; justify-content:space-between; margin-bottom:15px; align-items:center; }
        .add-btn { background:#67c23a; color:#fff; padding:8px 14px; border-radius:6px; text-decoration:none; }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:10px; text-align:left; border-bottom:1px solid #eee; }
        th { background:#f8f9fa; }
        .btn { padding:6px 10px; border-radius:4px; color:#fff; text-decoration:none; font-size:12px; margin-right:5px; }
        .edit { background:#409eff; }
        .del { background:#f56c6c; }
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
        <a href="index.jsp" class="menu-item">控制台首页</a>
        <a href="studentList.jsp" class="menu-item">学生信息管理</a>
        <a href="teacherList.jsp" class="menu-item active">教师信息管理</a>
        <a href="orderList.jsp" class="menu-item">预约信息管理</a>
        <a href="placeList.jsp" class="menu-item">教室信息管理</a>
    </div>
    <div class="content">
        <div class="bar">
            <h2>教师信息管理</h2>
            <a href="teacherAdd.jsp" class="add-btn">添加教师</a>
        </div>
        <table>
            <tr>
                <th>工号（用户名）</th>
                <th>姓名</th>
                <th>密码</th>
                <th>操作</th>
            </tr>
            <% for(User u : list) { %>
            <tr>
                <td><%=u.getUsername()%></td>
                <td><%=u.getName()%></td>
                <td><%=u.getPassword()%></td>
                <td>
                    <a href="teacherEdit.jsp?id=<%=u.getId()%>" class="btn edit">编辑</a>
                    <a href="/SchoolSystem1/admin/delUser?id=<%=u.getId()%>&role=teacher" class="btn del" onclick="return confirm('确定删除？')">删除</a>
                </td>
            </tr>
            <% } %>
        </table>
    </div>
</div>
</body>
</html>