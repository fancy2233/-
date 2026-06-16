<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户登录</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:"Microsoft Yahei",sans-serif; }
        body { background-color:#f5f7fa; display:flex; justify-content:center; align-items:center; min-height:100vh; }
        .box { background:#fff; width:400px; padding:40px; border-radius:8px; box-shadow:0 2px 10px rgba(0,0,0,0.08); text-align:center; }
        .box h2 { font-size:24px; color:#333; margin-bottom:25px; }
        .item { margin-bottom:20px; text-align:left; }
        .item label { display:block; font-size:14px; color:#666; margin-bottom:6px; }
        .item input, .item select { 
            width:100%; height:44px; padding:0 12px; 
            border:1px solid #e4e7ed; border-radius:6px; 
            font-size:14px; outline:none; 
        }
        .btn { width:100%; height:44px; background:#409eff; color:#fff; border:none; border-radius:6px; font-size:16px; margin-top:10px; cursor:pointer; }
        .tip { margin-top:15px; font-size:14px; color:#666; }
        .tip a { color:#409eff; text-decoration:none; }
        .msg { color:#f56c6c; margin-top:15px; font-size:14px; }
    </style>
</head>
<body>
<div class="box">
    <h2>用户登录</h2>
    <form action="userLogin" method="post">
        <div class="item">
            <label>用户名</label>
            <input type="text" name="username" placeholder="请输入用户名">
        </div>
        <div class="item">
            <label>密码</label>
            <input type="password" name="password" placeholder="请输入密码">
        </div>

        <!-- ====================== 【新增：角色下拉框】 ====================== -->
        <div class="item">
            <label>登录角色</label>
            <select name="role" required>
                <option value="">请选择角色</option>
                <option value="student">学生</option>
                <option value="teacher">教师</option>
                <option value="admin">管理员</option>
            </select>
        </div>
        <!-- =============================================================== -->

        <button class="btn" type="submit">登录</button>
    </form>
    <div class="tip">没有账号？<a href="register.jsp">立即注册</a></div>
    <p class="msg">${msg}</p>
</div>
</body>
</html>