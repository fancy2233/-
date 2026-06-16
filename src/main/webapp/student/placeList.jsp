<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User,com.dao.PlaceDao,com.entity.Place,com.dao.PlaceTimeDao,com.entity.PlaceTime,com.dao.OrderDao,com.entity.Order,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"student".equals(user.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }
    // 获取当前系统日期 yyyy-MM-dd
    java.text.SimpleDateFormat sdfDay = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String nowDay = sdfDay.format(new Date());
    
    String selectDate = request.getParameter("date");
    // 默认今天
    if(selectDate == null || selectDate.isEmpty()){
        selectDate = nowDay;
    }
    
    // 核心：如果选择的日期 < 今天，直接强制跳转到今天，禁止访问过去日期
    if(selectDate.compareTo(nowDay) < 0){
        response.sendRedirect("placeList.jsp?date=" + nowDay);
        return;
    }

    // 当天小时判断
    int currentHour = Integer.parseInt(new java.text.SimpleDateFormat("HH").format(new Date()));

    PlaceDao placeDao = new PlaceDao();
    PlaceTimeDao timeDao = new PlaceTimeDao();
    List<Place> allPlaces = placeDao.listAllPlace();
    List<Place> freePlaces = new ArrayList<>();
    for(Place p : allPlaces){
        List<PlaceTime> timeList = timeDao.getTimeByDateAndPid(selectDate, p.getPid());
        if(timeList == null || timeList.isEmpty()){
            freePlaces.add(p);
        } else {
            boolean hasFree = false;
            for(PlaceTime pt : timeList){
                if(pt.getStatus() == 0){
                    hasFree = true;
                    break;
                }
            }
            if(hasFree) freePlaces.add(p);
        }
    }
    String[] timeHours = {"07","08","09","10","11","12","13","14","15","16","17","18","19","20","21"};
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>教室预约列表</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:"Microsoft Yahei",sans-serif; }
        body { background-color:#f5f7fa; }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color:#fff; padding:15px 20px;
            display:flex; justify-content:space-between; align-items:center;
            box-shadow:0 2px 8px rgba(0,0,0,0.1);
        }
        .header h1 { font-size:20px; font-weight:600; }
        .header-right { display:flex; align-items:center; gap:12px; }
        .welcome { font-size:15px; margin-right:8px; }
        .nav-btn { background:rgba(255,255,255,0.2); color:#fff; border:none; padding:8px 14px; border-radius:6px; font-size:14px; cursor:pointer; text-decoration:none; }
        .logout-btn { background:#fff; color:#667eea; border:none; padding:8px 14px; border-radius:6px; font-size:14px; cursor:pointer; }
        .filter-bar { background:#fff; padding:15px 20px; margin:20px auto; width:90%; max-width:1200px; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.05); display:flex; gap:15px; align-items:center; flex-wrap:wrap; }
        .search-input { flex:1; min-width:200px; height:40px; padding:0 15px; border:1px solid #e4e7ed; border-radius:6px; font-size:14px; }
        .search-btn { background:#409eff; color:#fff; border:none; height:40px; padding:0 20px; border-radius:6px; cursor:pointer; font-size:14px; }
        .date-select { height:40px; padding:0 15px; border:1px solid #e4e7ed; border-radius:6px; font-size:14px; }
        .filter-tag { height:40px; padding:0 15px; border:1px solid #e4e7ed; border-radius:6px; background:#fff; cursor:pointer; font-size:14px; }
        .place-list { width:90%; max-width:1200px; margin:0 auto 30px; display:flex; flex-direction:column; gap:20px; }
        .place-card { background:#fff; border-radius:8px; padding:15px; box-shadow:0 2px 8px rgba(0,0,0,0.05); display:grid; grid-template-columns:200px 1fr auto; gap:15px; align-items:flex-start; }
        .place-img { width:200px; height:150px; object-fit:cover; border-radius:6px; background:#e4e7ed; }
        .place-info { display:flex; flex-direction:column; gap:8px; }
        .place-name { font-size:22px; font-weight:600; color:#333; }
        .info-item { font-size:15px; color:#666; display:flex; align-items:center; gap:8px; }
        .time-slot-bar { display:flex; gap:4px; margin-top:10px; }
        .slot { width:40px; height:12px; border-radius:2px; }
        .slot-free { background:#e4e7ed; }
        .slot-booked { background:#722ED1; }
        .slot-expired { background:#c0c4cc !important; }
        .time-label { display:flex; gap:4px; margin-top:4px; font-size:12px; color:#999; }
        .label-item { width:40px; text-align:center; }
        .book-btn { background:#409eff; color:#fff; border:none; padding:10px 25px; border-radius:6px; font-size:16px; cursor:pointer; text-decoration:none; white-space:nowrap; }
        .book-btn.disabled { background:#c0c4cc; cursor:not-allowed; }
    </style>
</head>
<body>
<div class="header">
    <h1>校园活动场地预约系统</h1>
    <div class="header-right">
        <span class="welcome">欢迎，<%=user.getName()%>（学生）</span>
        <a href="/SchoolSystem1/student/myOrder.jsp" class="nav-btn">我的预约</a>
        <a href="/SchoolSystem1/logout" class="logout-btn">退出登录</a>
    </div>
</div>
<div class="filter-bar">
    <input type="text" class="search-input" placeholder="请输入教室名称/位置搜索" id="searchInput">
    <button class="search-btn" onclick="doFilter()">搜索</button>
    <select class="filter-tag" id="buildSelect">
        <option value="">全部位置</option>
        <option value="子良">子良楼</option>
        <option value="东配">东配楼</option>
        <option value="新教">新教</option>
        <option value="邵科">邵科馆</option>
        <option value="文荟">文荟楼</option>
    </select>
    <select class="filter-tag" id="equipSelect">
        <option value="">全部设备</option>
        <option value="投影仪">投影仪</option>
        <option value="白板">白板</option>
    </select>
    <select class="filter-tag" id="numSelect">
        <option value="">全部人数</option>
        <option value="small">10人以下</option>
        <option value="mid">10-50人</option>
        <option value="big">50人以上</option>
    </select>
    <!-- 给日期框加min属性，前端禁止选过去日期 -->
    <input type="date" class="date-select" value="<%=selectDate%>" id="dateInput" min="<%=nowDay%>">
    <button class="search-btn" onclick="changeDate()">确定日期</button>
</div>
<div class="place-list" id="placeContainer">
    <% for(Place p : freePlaces) {
        OrderDao orderDao = new OrderDao();
        List<Order> bookedOrders = orderDao.getBookedOrdersByPidAndDate(p.getPid(), selectDate);
        Set<String> bookedSlotSet = new HashSet<>();
        for(Order o : bookedOrders){
            if(o.getTime_slots() != null){
                String[] slots = o.getTime_slots().split(" ");
                for(String s : slots){
                    bookedSlotSet.add(s.trim());
                }
            }
        }
        String[] allSlots = {
            "07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00",
            "11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00",
            "15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00",
            "19:00-20:00","20:00-21:00"
        };

        boolean hasAvailableSlot = true;
        // 只有今天才判断时段是否过期
        if(selectDate.equals(nowDay)){
            hasAvailableSlot = false;
            for(String slot : allSlots){
                int slotHour = Integer.parseInt(slot.split(":")[0]);
                if(slotHour > currentHour && !bookedSlotSet.contains(slot)){
                    hasAvailableSlot = true;
                    break;
                }
            }
        }
    %>
    <div class="place-card" data-name="<%=p.getPname()%>" data-equip="<%=p.getEquipment()%>" data-num="<%=p.getMax_num()%>">
        <img src="<%=request.getContextPath()%>/<%=p.getImg()%>" alt="<%=p.getPname()%>" class="place-img">
        <div class="place-info">
            <div class="place-name"><%=p.getPname()%></div>
            <div class="info-item">📌 位置：<%=p.getPname().split("楼")[0] + "楼"%></div>
            <div class="info-item">👥 容量：<%=p.getMax_num()%>人</div>
            <div class="info-item">⏰ 开放时间：<%=p.getOpen_time() == null ? "07:00~21:00" : p.getOpen_time()%></div>
            <div class="info-item">📦 设备：<%=p.getEquipment()%></div>
            <div class="time-label">
                <% for(String h : timeHours) { %><div class="label-item"><%=h%></div><% } %>
            </div>
            <div class="time-slot-bar">
                <% for(String slot : allSlots) {
                    int slotHour = Integer.parseInt(slot.split(":")[0]);
                    boolean isExpired = false;
                    // 仅今天判断时段过期
                    if(selectDate.equals(nowDay)){
                        isExpired = slotHour <= currentHour;
                    }
                %>
                    <% if(isExpired) { %>
                        <div class="slot slot-expired"></div>
                    <% } else if(bookedSlotSet.contains(slot)) { %>
                        <div class="slot slot-booked"></div>
                    <% } else { %>
                        <div class="slot slot-free"></div>
                    <% } %>
                <% } %>
            </div>
        </div>
        <% if(hasAvailableSlot) { %>
            <a href="/SchoolSystem1/student/toBook.jsp?pid=<%=p.getPid()%>&date=<%=selectDate%>" class="book-btn">预约</a>
        <% } else { %>
            <span class="book-btn disabled">不可预约</span>
        <% } %>
    </div>
    <% } %>
</div>
<script>
    function changeDate() {
        const date = document.getElementById("dateInput").value;
        window.location.href = "placeList.jsp?date=" + date;
    }
    function doFilter() {
        const keyword = document.getElementById("searchInput").value.toLowerCase();
        const build = document.getElementById("buildSelect").value;
        const equip = document.getElementById("equipSelect").value;
        const numType = document.getElementById("numSelect").value;
        const cards = document.querySelectorAll(".place-card");
        cards.forEach(card => {
            const name = card.dataset.name || "";
            const equipment = card.dataset.equip || "";
            const maxNum = parseInt(card.dataset.num) || 0;
            const matchName = keyword === "" || name.toLowerCase().includes(keyword);
            const matchBuild = build === "" || name.includes(build);
            const matchEquip = equip === "" || equipment.includes(equip);
            let matchNum = true;
            if (numType === "small") matchNum = maxNum < 10;
            else if (numType === "mid") matchNum = maxNum >= 10 && maxNum <= 50;
            else if (numType === "big") matchNum = maxNum > 50;
            card.style.display = (matchName && matchBuild && matchEquip && matchNum) ? "grid" : "none";
        });
    }
</script>
</body>
</html>