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
    <title>添加学生</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:"Microsoft Yahei",sans-serif; }
        body { background:#f5f7fa; }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color:#fff; padding:15px 20px;
            display:flex; justify-content:space-between; align-items:center;
        }
        .logout-btn { background:#fff; color:#667eea; padding:8px 14px; border-radius:6px; text-decoration:none; }
        .container { width:90%; max-width:700px; margin:30px auto; background:#fff; border-radius:8px; padding:25px; box-shadow:0 2px 8px rgba(0,0,0,0.05); }
        .back { color:#409eff; text-decoration:none; margin-bottom:15px; display:inline-block; }
        h2 { margin-bottom:20px; padding-bottom:10px; border-bottom:1px solid #eee; }
        .form-item { margin-bottom:15px; }
        .form-item label { display:block; margin-bottom:5px; font-size:14px; color:#666; }
        .form-item input { width:100%; height:40px; padding:0 12px; border:1px solid #ddd; border-radius:6px; }
        .submit { background:#409eff; color:#fff; width:100%; height:42px; border:none; border-radius:6px; cursor:pointer; }
    </style>
</head>
<body>
<div class="header">
    <h1>管理员后台</h1>
    <a href="/SchoolSystem1/logout" class="logout-btn">退出</a>
</div>
<div class="container">
    <a href="studentList.jsp" class="back">← 返回学生管理</a>
    <h2>添加学生</h2>
    <form action="/SchoolSystem1/admin/addUser" method="post">
        <input type="hidden" name="role" value="student">
        <div class="form-item">
            <label>学号（用户名）</label>
            <input type="text" name="username"placeholder="请输入学生学号" required>
        </div>
        <div class="form-item">
            <label>姓名</label>
            <input type="text" name="name" placeholder="请输入学生姓名"required>
        </div>
        <div class="form-item">
            <label>密码</label>
            <!-- 🔥 只改这里：pwd → password  和后端对应 -->
            <input type="text" name="password" placeholder="请输入初始密码"required>
        </div>
        <button type="submit" class="submit">确认添加</button>
    </form>
</div>
</body>
</html>