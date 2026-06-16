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
    <title>添加教室</title>
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
            width:90%; max-width:800px; margin:30px auto;
            background:#fff; border-radius:8px; padding:25px;
            box-shadow:0 2px 8px rgba(0,0,0,0.05);
        }
        .back { display:inline-block; margin-bottom:15px; color:#409eff; text-decoration:none; }
        h2 { font-size:20px; margin-bottom:20px; padding-bottom:10px; border-bottom:1px solid #eee; }
        .form-item { margin-bottom:20px; }
        .form-item label { display:block; font-size:14px; color:#666; margin-bottom:6px; }
        .form-item input, .form-item textarea {
            width:100%; height:44px; padding:0 12px;
            border:1px solid #e4e7ed; border-radius:6px;
            font-size:14px; outline:none;
        }
        .submit-btn {
            width:100%; height:44px; background:#409eff;
            color:#fff; border:none; border-radius:6px;
            font-size:16px; cursor:pointer;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>添加教室</h1>
    <a href="/SchoolSystem1/logout" class="logout-btn">退出</a>
</div>

<div class="container">
    <a href="placeList.jsp" class="back">← 返回教室列表</a>
    <h2>新增教室信息</h2>

    <form action="/SchoolSystem1/teacher/addPlace" method="post" enctype="multipart/form-data">
        <div class="form-item">
            <label>教室名称</label>
            <input type="text" name="pname" placeholder="如：子良A234" required>
        </div>

        <div class="form-item">
            <label>位置（楼栋）</label>
            <input type="text" name="location" placeholder="如：子良楼" required>
        </div>

        <div class="form-item">
            <label>容量（人数）</label>
            <input type="number" name="max_num" min="1" placeholder="如：60" required>
        </div>

        <div class="form-item">
            <label>开放时间</label>
            <input type="text" name="open_time" value="07:00-21:00" required>
        </div>

        <div class="form-item">
            <label>设备（用逗号分隔，如：空调,WiFi,投影仪）</label>
            <input type="text" name="equipment" required>
        </div>

        <div class="form-item">
            <label>教室图片（本地上传）</label>
            <input type="file" name="imgFile" accept="image/*" required>
        </div>

        <button type="submit" class="submit-btn">提交添加</button>
    </form>
</div>
</body>
</html>