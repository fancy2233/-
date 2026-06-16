package com.entity;

public class Place {
    private int pid;
    private String pname;
    private String equipment;
    private int max_num;
    private String img;
    private String location;  // 位置
    private String open_time; // 开放时间
    private String type;      // 类型
    private int status;

    // ====================== 你需要新增的字段 ======================
    private int tid;           // 🔥 新增：操作老师ID（解决setTid报错）
    private String username;    // 老师工号
    private String tname;       // 老师姓名
    private String operateType; // 操作类型（新增/编辑/删除）
    private String updateTime;  // 操作时间

    // 全量getter/setter（原有全部保留，只追加新字段）
    public int getPid() { return pid; }
    public void setPid(int pid) { this.pid = pid; }
    public String getPname() { return pname; }
    public void setPname(String pname) { this.pname = pname; }
    public String getEquipment() { return equipment; }
    public void setEquipment(String equipment) { this.equipment = equipment; }
    public int getMax_num() { return max_num; }
    public void setMax_num(int max_num) { this.max_num = max_num; }
    public String getImg() { return img; }
    public void setImg(String img) { this.img = img; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getOpen_time() { return open_time; }
    public void setOpen_time(String open_time) { this.open_time = open_time; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    // ====================== 新增字段的 getter/setter ======================
    // 🔥 新增：tid 的 get/set 方法
    public int getTid() { return tid; }
    public void setTid(int tid) { this.tid = tid; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getTname() { return tname; }
    public void setTname(String tname) { this.tname = tname; }

    public String getOperateType() { return operateType; }
    public void setOperateType(String operateType) { this.operateType = operateType; }

    public String getUpdateTime() { return updateTime; }
    public void setUpdateTime(String updateTime) { this.updateTime = updateTime; }
}