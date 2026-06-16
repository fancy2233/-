<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User, com.dao.PlaceDao, com.entity.Place, java.util.List" %>
<%
    // 权限校验
    User user = (User) session.getAttribute("user");
    if(user == null || !"student".equals(user.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }

    // 从数据库查询所有可用场地（去掉status=0限制，确保显示所有）
    PlaceDao placeDao = new PlaceDao();
    List<Place> placeList = placeDao.listAllPlace();
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>校园活动场地预约系统 - 学生首页</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:"Microsoft Yahei",sans-serif; }
        body { background-color:#f5f7fa; }
        /* 顶部导航栏 */
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color:#fff;
            padding:15px 20px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            box-shadow:0 2px 8px rgba(0,0,0,0.1);
        }
        .header h1 { font-size:20px; font-weight:600; }
        .user-info {
            display:flex;
            align-items:center;
            gap:20px;
        }
        .user-info span { font-size:15px; }
        .logout-btn {
            background:#fff;
            color:#667eea;
            border:none;
            padding:8px 16px;
            border-radius:6px;
            cursor:pointer;
            font-size:14px;
            font-weight:500;
            transition:all 0.2s;
        }
        .logout-btn:hover { background:#f0f0f0; }
        /* 横幅区域 */
        .banner {
            background: linear-gradient(90deg, #409eff 0%, #722ed1 100%);
            color:#fff;
            text-align:center;
            padding:40px 20px;
            margin:20px auto;
            width:90%;
            max-width:1200px;
            border-radius:8px;
        }
        .banner h2 { font-size:28px; margin-bottom:8px; }
        .banner p { font-size:15px; opacity:0.9; margin-bottom:20px; }
        .banner .btn {
            background:#fff;
            color:#409eff;
            border:none;
            padding:10px 24px;
            border-radius:6px;
            font-size:15px;
            font-weight:500;
            cursor:pointer;
            text-decoration:none;
            display:inline-block;
        }
        /* 主体容器 */
        .container {
            width:90%;
            max-width:1200px;
            margin:0 auto 30px;
        }
        /* 标题栏 */
        .title-bar {
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:20px;
        }
        .title-bar h3 { font-size:20px; color:#333; }
        .title-bar a {
            color:#409eff;
            text-decoration:none;
            font-size:14px;
            font-weight:500;
        }
        /* 场地卡片网格 */
        .place-grid {
            display:grid;
            grid-template-columns:repeat(3, 1fr);
            gap:25px;
            margin-bottom:40px;
        }
        .place-card {
            background:#fff;
            border-radius:8px;
            overflow:hidden;
            box-shadow:0 2px 10px rgba(0,0,0,0.08);
            transition:transform 0.2s;
        }
        .place-card:hover { transform:translateY(-5px); }
        .place-img {
            width:100%;
            height:180px;
            object-fit: cover;
            background:#e4e7ed;
            display:flex;
            align-items:center;
            justify-content:center;
            color:#999;
            font-size:14px;
        }
        .place-info { padding:15px 20px; }
        .place-name {
            font-size:16px;
            font-weight:600;
            color:#333;
            margin-bottom:8px;
        }
        .place-equipment {
            font-size:13px;
            color:#666;
            margin-bottom:8px;
            line-height:1.5;
        }
        .place-count {
            font-size:12px;
            color:#999;
            text-align:right;
            margin-bottom:12px;
        }
        .card-btn {
            width:100%;
            display:flex;
            justify-content:space-between;
            align-items:center;
        }
        .detail-btn {
            color:#666;
            font-size:13px;
            text-decoration:none;
        }
        .book-btn {
            background:#409eff;
            color:#fff;
            border:none;
            padding:6px 16px;
            border-radius:6px;
            font-size:13px;
            cursor:pointer;
            text-decoration:none;
        }
        /* 我的预约入口 */
        .my-order-section {
            background:#fff;
            border-radius:12px;
            padding:40px 20px;
            box-shadow:0 2px 10px rgba(0,0,0,0.05);
            text-align:center;
        }
        .my-order-section h3 {
            font-size:22px;
            color:#333;
            margin-bottom:25px;
        }
        .my-order-btn {
            background:#409eff;
            color:#fff;
            border:none;
            padding:12px 30px;
            border-radius:8px;
            font-size:16px;
            cursor:pointer;
            text-decoration:none;
            display:inline-block;
        }
        .my-order-btn:hover {
            background:#337ecc;
        }
        /* 底部 */
        .footer {
            background:#1e293b;
            color:#94a3b8;
            text-align:center;
            padding:20px;
            font-size:13px;
            margin-top:40px;
        }
    </style>
</head>
<body>
    <!-- 顶部导航 -->
    <div class="header">
        <h1>校园活动场地预约系统</h1>
        <div class="user-info">
            <span>欢迎，<%=user.getName()%>（学生）</span>
            <a href="/SchoolSystem1/logout" class="logout-btn">退出登录</a>
        </div>
    </div>

    <!-- 横幅 -->
    <div class="banner">
        <h2>发现您的完美学习空间</h2>
        <p>轻松预约自习室，专注学习，无需等待</p>
        <a href="#place-list" class="btn">立即预约 ➜</a>
    </div>

    <!-- 主体内容 -->
    <div class="container" id="place-list">
        <!-- 特色自习室标题 -->
        <div class="title-bar">
            <h3>场地概览</h3>
            <a href="/SchoolSystem1/student/placeList.jsp">查看全部 ➜</a>
        </div>

        <!-- 场地卡片（从数据库动态生成） -->
        <div class="place-grid">
            <%
                // 遍历数据库查询到的场地，动态生成卡片
                for(Place place : placeList) {
            %>
            <div class="place-card">
                <!-- 场地图片（从数据库读取路径） -->
                <img src="<%=place.getImg()%>" alt="<%=place.getPname()%>" class="place-img">
                <div class="place-info">
                    <div class="place-name"><%=place.getPname()%></div>
                    <div class="place-equipment">设备：<%=place.getEquipment()%></div>
                    <div class="place-count">可容纳：<%=place.getMax_num()%>人</div>
                    <div class="card-btn">
                        <a href="#" class="detail-btn">查看详情</a>
                        <a href="/SchoolSystem1/student/bookPlace?pid=<%=place.getPid()%>" class="book-btn">立即预约</a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <!-- 我的预约 -->
        <div class="my-order-section">
            <h3>我的预约</h3>
            <a href="/SchoolSystem1/student/myOrder.jsp" class="my-order-btn">查看我的预约记录</a>
        </div>
    </div>

    <!-- 底部 -->
    <div class="footer">
        © 2026 自习室预约系统 版权所有
    </div>
</body>
</html>