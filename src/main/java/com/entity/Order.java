package com.entity;

public class Order {
    private int oid;
    private int sid;
    private int pid;
    private String sname;
    private String pname;
    private String reason;
    private String time_slots;
    private String apply_time;
    private int status;
    private String remark;
    private String o_date;
    private String studentNo;

    private String tid;
    private String tname;
    private String operate_time;
 

    public String getStudentNo() {
        return studentNo;
    }
    public void setStudentNo(String studentNo) {
        this.studentNo = studentNo;
    }
    public String getO_date() {
        return o_date;
    }
    public void setO_date(String o_date) {
        this.o_date = o_date;
    }

    public int getOid() { return oid; }
    public void setOid(int oid) { this.oid = oid; }
    public int getSid() { return sid; }
    public void setSid(int sid) { this.sid = sid; }
    public int getPid() { return pid; }
    public void setPid(int pid) { this.pid = pid; }
    public String getSname() { return sname; }
    public void setSname(String sname) { this.sname = sname; }
    public String getPname() { return pname; }
    public void setPname(String pname) { this.pname = pname; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public String getTime_slots() { return time_slots; }
    public void setTime_slots(String time_slots) { this.time_slots = time_slots; }
    public String getApply_time() { return apply_time; }
    public void setApply_time(String apply_time) { this.apply_time = apply_time; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getTid() {
        return tid;
    }
    public void setTid(String tid) {
        this.tid = tid;
    }
    public String getTname() {
        return tname;
    }
    public void setTname(String tname) {
        this.tname = tname;
    }
    public String getOperate_time() {
        return operate_time;
    }
    public void setOperate_time(String operate_time) {
        this.operate_time = operate_time;
    }
}