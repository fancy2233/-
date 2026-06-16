package com.entity;

public class PlaceTime {
    private int tid;
    private int pid; 
    private String o_date;
    private String time_slot;
    private int status;

    public int getTid() { return tid; }
    public void setTid(int tid) { this.tid = tid; }
    public int getPid() { return pid; }
    public void setPid(int pid) { this.pid = pid; }
    public String getO_date() { return o_date; }
    public void setO_date(String o_date) { this.o_date = o_date; }
    public String getTime_slot() { return time_slot; }
    public void setTime_slot(String time_slot) { this.time_slot = time_slot; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    
}