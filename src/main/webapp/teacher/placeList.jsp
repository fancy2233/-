<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User,com.dao.PlaceDao,com.entity.Place,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"teacher".equals(user.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }
    PlaceDao placeDao = new PlaceDao();
    // ====================== ✅ 只改这一行 ======================
    List<Place> allPlaceList = placeDao.listAllPlace(); // 原来：listAllPlace()

    // 筛选参数接收
    String keyword = request.getParameter("keyword");
    String build = request.getParameter("build");
    String equip = request.getParameter("equip");
    String numType = request.getParameter("numType");

    // 筛选后列表
    List<Place> filterList = new ArrayList<>();
    for(Place p : allPlaceList){
        // 名称/位置筛选
        boolean matchName = (keyword == null || keyword.isEmpty() || p.getPname().contains(keyword));
        // 楼栋筛选
        boolean matchBuild = (build == null || build.isEmpty() || p.getPname().contains(build));
        // 设备筛选
        boolean matchEquip = (equip == null || equip.isEmpty() || p.getEquipment().contains(equip));
        // 人数筛选
        boolean matchNum = true;
        if(numType != null && !numType.isEmpty()){
            if("small".equals(numType)) matchNum = p.getMax_num() < 10;
            else if("mid".equals(numType)) matchNum = p.getMax_num() >=10 && p.getMax_num() <=50;
            else if("big".equals(numType)) matchNum = p.getMax_num() >50;
        }

        if(matchName && matchBuild && matchEquip && matchNum){
            filterList.add(p);
        }
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>教室管理</title>
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

        /* 筛选栏样式（调整布局：搜索按钮放最右） */
        .filter-bar {
            display:flex; gap:10px; margin-bottom:20px; align-items:center; flex-wrap:wrap;
            justify-content: space-between;
        }
        .filter-left {
            display:flex; gap:10px; align-items:center; flex-wrap:wrap;
            flex:1;
        }
        .filter-right {
            display:flex; gap:10px; align-items:center;
        }
        .search-input {
            min-width:200px; height:40px; padding:0 12px;
            border:1px solid #e4e7ed; border-radius:6px; font-size:14px;
            flex:1;
        }
        .search-btn {
            height:40px; padding:0 20px; background:#409eff; color:#fff;
            border:none; border-radius:6px; cursor:pointer; font-size:14px;
        }
        .add-btn {
            height:40px; padding:0 20px; background:#67c23a; color:#fff;
            border:none; border-radius:6px; cursor:pointer; font-size:14px;
            text-decoration:none;
            line-height:40px;
        }
        .filter-tag {
            height:40px; padding:0 12px; border:1px solid #e4e7ed;
            border-radius:6px; background:#fff; cursor:pointer; font-size:14px;
        }

        table { width:100%; border-collapse:collapse; }
        th,td { padding:12px; text-align:left; border-bottom:1px solid #eee; font-size:14px; }
        th { background:#f8f9fa; }
        .btn { padding:6px 12px; border:none; border-radius:4px; color:#fff; cursor:pointer; font-size:13px; margin-right:5px; }
        .btn-edit { background:#409eff; }
        .btn-delete { background:#e74c3c; }
        .back { display:inline-block; margin-bottom:15px; color:#409eff; text-decoration:none; }
    </style>
</head>
<body>
<div class="header">
    <h1>教室管理</h1>
    <a href="/SchoolSystem1/logout" class="logout-btn">退出</a>
</div>

<div class="container">
    <div class="sidebar">
        <a href="/SchoolSystem1/teacher/orderList.jsp" class="menu-item">预约管理</a>
        <a href="/SchoolSystem1/teacher/placeList.jsp" class="menu-item active">教室管理</a>
    </div>

    <div class="content">
        <a href="index.jsp" class="back">← 返回首页</a>
        <h2>教室列表</h2>

        <!-- 调整布局：搜索按钮放最右 + 新增添加教室按钮 -->
        <form action="placeList.jsp" method="get" class="filter-bar">
            <div class="filter-left">
                <input type="text" name="keyword" class="search-input" placeholder="请输入教室名称/位置搜索"
                       value="<%=keyword != null ? keyword : ""%>">

                <select name="build" class="filter-tag">
                    <option value="">全部位置</option>
                    <option value="子良" <%="子良".equals(build) ? "selected" : ""%>>子良楼</option>
                    <option value="东配" <%="东配".equals(build) ? "selected" : ""%>>东配楼</option>
                    <option value="新教" <%="新教".equals(build) ? "selected" : ""%>>新教</option>
                    <option value="邵科" <%="邵科".equals(build) ? "selected" : ""%>>邵科馆</option>
                    <option value="文荟" <%="文荟".equals(build) ? "selected" : ""%>>文荟楼</option>
                </select>

                <select name="equip" class="filter-tag">
                    <option value="">全部设备</option>
                    <option value="投影仪" <%="投影仪".equals(equip) ? "selected" : ""%>>投影仪</option>
                    <option value="白板" <%="白板".equals(equip) ? "selected" : ""%>>白板</option>
                </select>

                <select name="numType" class="filter-tag">
                    <option value="">全部人数</option>
                    <option value="small" <%="small".equals(numType) ? "selected" : ""%>>10人以下</option>
                    <option value="mid" <%="mid".equals(numType) ? "selected" : ""%>>10-50人</option>
                    <option value="big" <%="big".equals(numType) ? "selected" : ""%>>50人以上</option>
                </select>
            </div>

            <div class="filter-right">
                <button type="submit" class="search-btn">搜索</button>
                <a href="/SchoolSystem1/teacher/addPlace.jsp" class="add-btn">添加教室</a>
            </div>
        </form>

        <table>
            <tr>
                <th>教室名称</th>
                <th>设备</th>
                <th>容量</th>
                <th>开放时间</th>
                <th>操作</th>
            </tr>
            <% if(filterList == null || filterList.isEmpty()) { %>
            <tr><td colspan="5" align="center" style="color:#999;">暂无符合条件的教室</td></tr>
            <% } else {
                for(Place p : filterList) { %>
            <tr>
                <td><%=p.getPname()%></td>
                <td><%=p.getEquipment()%></td>
                <td><%=p.getMax_num()%>人</td>
                <td><%=p.getOpen_time() == null ? "07:00-21:00" : p.getOpen_time()%></td>
                <td>
                    <a href="/SchoolSystem1/teacher/editPlace.jsp?pid=<%=p.getPid()%>" class="btn btn-edit">编辑</a>
                    <a href="/SchoolSystem1/teacher/deletePlace?pid=<%=p.getPid()%>" class="btn btn-delete" onclick="return confirm('确定删除该教室吗？删除后不可恢复！')">删除</a>
                </td>
            </tr>
            <% } } %>
        </table>
    </div>
</div>
</body>
</html>