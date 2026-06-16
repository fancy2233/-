<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.entity.User,com.dao.PlaceDao,com.dao.OrderDao,com.entity.Place,com.entity.Order,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"student".equals(user.getRole())){
        response.sendRedirect("/SchoolSystem1/login.jsp");
        return;
    }

    // ======================
    // 全局时间控制（禁止预约过去日期 + 当天过时时段灰色）
    // ======================
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String today = sdf.format(new Date());
    int currentHour = Integer.parseInt(new java.text.SimpleDateFormat("HH").format(new Date()));

    int pid = Integer.parseInt(request.getParameter("pid"));
    PlaceDao placeDao = new PlaceDao();
    Place place = placeDao.findPlaceById(pid);

    String date = request.getParameter("date");
    if(date == null) date = today;

    // ======================
    // 核心：禁止访问过去日期，直接跳回今天
    // ======================
    if (date.compareTo(today) < 0) {
        response.sendRedirect("/SchoolSystem1/student/toBook.jsp?pid=" + pid + "&date=" + today);
        return;
    }

    // 读取已预约时段
    OrderDao orderDao = new OrderDao();
    List<Order> bookedOrders = orderDao.getBookedOrdersByPidAndDate(pid, date);
    Set<String> bookedSlots = new HashSet<>();

    for(Order o : bookedOrders){
        if(o.getTime_slots() != null){
            String[] slots = o.getTime_slots().split(" ");
            for(String s : slots){
                bookedSlots.add(s.trim());
            }
        }
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>预约教室</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:"Microsoft Yahei",sans-serif; }
        body { background:#f5f7fa; }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color:#fff; padding:15px 20px;
            display:flex; justify-content:space-between; align-items:center;
        }
        .header h1 { font-size:20px; }
        .welcome { font-size:15px; margin-right:10px; }
        .nav-btn { background:rgba(255,255,255,0.2); color:#fff; padding:8px 14px; border-radius:6px; text-decoration:none; font-size:14px; }
        .container { width:90%; max-width:1200px; margin:30px auto; }
        .back { color:#409eff; text-decoration:none; margin-bottom:20px; display:inline-block; }
        .card { background:#fff; border-radius:8px; padding:25px; margin-bottom:20px; box-shadow:0 2px 8px rgba(0,0,0,0.05); }
        .card h2 { font-size:20px; margin-bottom:20px; padding-bottom:10px; border-bottom:1px solid #eee; }
        .info-container {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 30px;
        }
        .info-text {
            flex: 1;
            line-height: 2.2;
            font-size: 16px;
        }
        .info-img {
            flex-shrink: 0;
            width: 200px;
            height: 150px;
            border-radius: 8px;
            overflow: hidden;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #e4e7ed;
        }
        .info-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .time-group { display:flex; flex-wrap:wrap; gap:10px; margin:20px 0; }
        .time-item {
            padding:10px 16px; border-radius:6px; font-size:14px; cursor:pointer;
            border:1px solid #e4e7ed; transition:all 0.2s;
            background:#fff; color:#333;
        }
        /* 已预约：紫色 */
        .time-item.booked {
            background:#667eea;
            color:#fff;
            border-color:#667eea;
            cursor:not-allowed;
            opacity: 0.8;
        }
        /* 已过期：灰色不可选 */
        .time-item.expired {
            background:#c0c4cc !important;
            color:#fff !important;
            border-color:#c0c4cc !important;
            cursor:not-allowed !important;
        }
        .time-item.selected {
            background:#667eea;
            color:#fff;
            border-color:#667eea;
        }
        .form-item { margin-bottom:20px; }
        .form-item label { display:block; font-size:14px; color:#666; margin-bottom:6px; }
        .form-item input { width:100%; height:44px; padding:0 12px; border:1px solid #e4e7ed; border-radius:6px; font-size:14px; outline:none; }
        .submit-btn { width:100%; height:44px; background:#409eff; color:#fff; border:none; border-radius:6px; font-size:16px; cursor:pointer; }
    </style>
</head>
<body>
<div class="header">
    <h1>校园活动场地预约系统</h1>
    <div class="header-right">
        <span class="welcome">欢迎，<%=user.getName()%>（学生）</span>
        <a href="/SchoolSystem1/student/placeList.jsp" class="nav-btn">教室列表</a>
        <a href="/SchoolSystem1/logout" class="nav-btn">退出登录</a>
    </div>
</div>
<div class="container">
    <a href="placeList.jsp" class="back">← 返回教室列表</a>
    <div class="card">
        <h2>教室信息</h2>
        <div class="info-container">
            <div class="info-text">
                <div>教室名称：<%=place.getPname()%></div>
                <div>设备：<%=place.getEquipment()%></div>
                <div>容量：<%=place.getMax_num()%>人</div>
                <div>预约日期：<%=date%></div>
            </div>
            <div class="info-img">
                <img src="<%=request.getContextPath()%><%=place.getImg()%>" alt="<%=place.getPname()%>">
            </div>
        </div>
    </div>
    <div class="card">
        <h2>预约信息填写</h2>
        <form action="addOrder" method="post" id="bookForm">
            <input type="hidden" name="pid" value="<%=pid%>">
            <input type="hidden" name="date" value="<%=date%>">
            <input type="hidden" name="tids" id="tidsInput">
            <div class="form-item">
                <label>学号</label>
                <input type="text" value="<%=user.getUsername()%>" readonly>
            </div>
            <div class="form-item">
                <label>姓名</label>
                <input type="text" value="<%=user.getName()%>" readonly>
            </div>
            <div class="form-item">
                <label>预约活动名称</label>
                <input type="text" name="activity" placeholder="请输入活动名称" required>
            </div>
            <div class="form-item">
                <label>选择时段（可多选，紫色=已预约，灰色=已过期）</label>
                <div class="time-group" id="timeGroup">
                    <%
                        String[] allSlots = {
                            "07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00",
                            "11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00",
                            "15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00",
                            "19:00-20:00","20:00-21:00"
                        };
                        for(int i=0;i<allSlots.length;i++){
                            String slot = allSlots[i];
                            int slotHour = Integer.parseInt(slot.split(":")[0]);
                            boolean isExpired = false;

                            // 只有今天才判断时段是否过期
                            if (date.equals(today)) {
                                isExpired = slotHour <= currentHour;
                            }

                            if (isExpired) {
                    %>
                                <div class="time-item expired"><%=slot%></div>
                    <%
                            } else if(bookedSlots.contains(slot)){
                    %>
                                <div class="time-item booked"><%=slot%></div>
                    <%
                            }else{
                    %>
                                <div class="time-item free" data-tid="<%=i+1%>"><%=slot%></div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>
            <div class="form-item">
                <label>备注（选填）</label>
                <input type="text" name="remark" placeholder="请输入备注信息">
            </div>
            <button type="submit" class="submit-btn">提交预约</button>
        </form>
    </div>
</div>
<script>
    const timeGroup = document.getElementById('timeGroup');
    const tidsInput = document.getElementById('tidsInput');
    let selectedTids = [];

    timeGroup.addEventListener('click', function(e) {
        const item = e.target;
        // 禁止点击 已预约 + 已过期 的时段
        if (item.classList.contains('booked') || item.classList.contains('expired')) {
            return;
        }
        if (!item.classList.contains('free')) return;

        const tid = item.dataset.tid;
        if (item.classList.contains('selected')) {
            item.classList.remove('selected');
            selectedTids = selectedTids.filter(t => t !== tid);
        } else {
            item.classList.add('selected');
            selectedTids.push(tid);
        }
        tidsInput.value = selectedTids.join(',');
    });

    document.getElementById('bookForm').addEventListener('submit', function(e) {
        if(!tidsInput.value) {
            alert('请选择预约时段！');
            e.preventDefault();
        }
    });
</script>
</body>
</html>