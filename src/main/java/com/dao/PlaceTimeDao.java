package com.dao;

import com.entity.PlaceTime;
import com.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PlaceTimeDao {

    // 根据日期和教室ID查询所有时段（适配o_date）
    public List<PlaceTime> getTimeByDateAndPid(String date, int pid) {
        List<PlaceTime> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConn();
            // ================= 核心修复：SQL条件用o_date =================
            String sql = "SELECT * FROM place_time WHERE o_date = ? AND pid = ? ORDER BY tid";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, date);
            pstmt.setInt(2, pid);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                PlaceTime pt = new PlaceTime();
                pt.setTid(rs.getInt("tid"));
                pt.setPid(rs.getInt("pid"));
                pt.setO_date(rs.getString("o_date")); // 用你有的setO_date
                pt.setTime_slot(rs.getString("time_slot"));
                pt.setStatus(rs.getInt("status"));
                list.add(pt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    // 更新时段状态
    public void updateStatus(int tid, int status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConn();
            String sql = "UPDATE place_time SET status = ? WHERE tid = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, status);
            pstmt.setInt(2, tid);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }
}