<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User,com.dao.UserDao" %>
<%
    User admin = (User) session.getAttribute("user");
    if(admin == null || !"admin".equals(admin.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("id"));
    UserDao dao = new UserDao();
    User u = dao.findById(id);
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑教师</title>
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
            width:90%; max-width:700px; margin:30px auto;
            background:#fff; border-radius:8px; padding:25px;
            box-shadow:0 2px 8px rgba(0,0,0,0.05);
        }
        .back {
            color:#409eff; text-decoration:none;
            margin-bottom:15px; display:inline-block;
            font-size:14px;
        }
        h2 {
            font-size:20px; margin-bottom:20px;
            padding-bottom:10px; border-bottom:1px solid #eee;
        }
        .form-item {
            margin-bottom:15px;
        }
        .form-item label {
            display:block; margin-bottom:6px;
            font-size:14px; color:#666;
        }
        .form-item input {
            width:100%; height:40px;
            padding:0 12px; border:1px solid #ddd;
            border-radius:6px; font-size:14px;
            outline:none;
        }
        .submit-btn {
            width:100%; height:42px;
            background:#409eff; color:#fff;
            border:none; border-radius:6px;
            cursor:pointer; font-size:16px;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>管理员后台</h1>
    <a href="/SchoolSystem1/logout" class="logout-btn">退出登录</a>
</div>

<div class="container">
    <a href="teacherList.jsp" class="back">← 返回教师列表</a>
    <h2>编辑教师</h2>
    <form action="/SchoolSystem1/admin/updateUser" method="post">
        <input type="hidden" name="id" value="<%=u.getId()%>">
        <input type="hidden" name="role" value="teacher">

        <div class="form-item">
            <label>工号</label>
            <input type="text" name="username" value="<%=u.getUsername()%>" required>
        </div>
        <div class="form-item">
            <label>姓名</label>
            <input type="text" name="name" value="<%=u.getName()%>" required>
        </div>
        <div class="form-item">
            <label>密码</label>
            <input type="text" name="password" value="<%=u.getPassword()%>" required>
        </div>

        <button type="submit" class="submit-btn">保存修改</button>
    </form>
</div>
</body>
</html>