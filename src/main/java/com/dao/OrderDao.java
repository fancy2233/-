package com.dao;
import com.entity.Order;
import com.util.DBUtil;
import java.sql.*;
import java.util.*;

public class OrderDao {

    // 添加预约
    public void add(Order order) {
        Connection conn = DBUtil.getConn();
        String sql = "INSERT INTO orders(sid,pid,reason,time_slots,o_date,remark,apply_time,status) VALUES(?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, order.getSid());
            pstmt.setInt(2, order.getPid());
            pstmt.setString(3, order.getReason());
            pstmt.setString(4, order.getTime_slots());
            pstmt.setString(5, order.getO_date());
            pstmt.setString(6, order.getRemark());
            pstmt.setString(7, order.getApply_time());
            pstmt.setInt(8, 0);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, null, null);
        }
    }

    // 查询某个学生的预约（已修复：显示学生学号 username）
    public List<Order> findOrderBySid(int sid) {
        List<Order> list = new ArrayList<>();
        Connection conn = DBUtil.getConn();
        String sql = "SELECT o.*,u.username studentNo, u.name sname,p.pname pname FROM orders o LEFT JOIN user u ON o.sid=u.id LEFT JOIN place p ON o.pid=p.pid WHERE o.sid=? ORDER BY o.oid DESC";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, sid);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOid(rs.getInt("oid"));
                o.setStudentNo(rs.getString("studentNo"));
                o.setSname(rs.getString("sname"));
                o.setPname(rs.getString("pname"));
                o.setReason(rs.getString("reason"));
                o.setTime_slots(rs.getString("time_slots"));
                o.setO_date(rs.getString("o_date"));
                o.setApply_time(rs.getString("apply_time"));
                o.setStatus(rs.getInt("status"));
                o.setRemark(rs.getString("remark"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, null, null);
        }
        return list;
    }

    // 审核预约（你原来的保留不动）
    public void check(int oid, int status) {
        Connection conn = DBUtil.getConn();
        try {
            String sql = "UPDATE orders SET status=? WHERE oid=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, status);
            pstmt.setInt(2, oid);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, null, null);
        }
    }

    // ====================== 【新增：带老师ID + 操作时间的审核】 ======================
    public void checkWithTeacher(int oid, int status, String teacherUsername) {
        Connection conn = DBUtil.getConn();
        try {
            String sql = "UPDATE orders SET status=?, tid=?, operate_time=NOW() WHERE oid=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, status);
            pstmt.setString(2, teacherUsername);
            pstmt.setInt(3, oid);
            int affectedRows = pstmt.executeUpdate();
            System.out.println("【审核日志】更新预约ID=" + oid + "，老师账号=" + teacherUsername + "，影响行数=" + affectedRows);
        } catch (Exception e) {
            System.err.println("【审核错误】预约ID=" + oid + " 审核失败：");
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, null, null);
        }
    }
    

    // 根据ID查询预约（已修复）
    public Order findById(int oid) {
        Connection conn = DBUtil.getConn();
        String sql = "SELECT o.*,u.username studentNo, u.name sname,p.pname pname, o.tid teacher_username, t.name teacher_name " +
                     "FROM orders o " +
                     "LEFT JOIN user u ON o.sid=u.id " +
                     "LEFT JOIN place p ON o.pid=p.pid " +
                     "LEFT JOIN user t ON o.tid = t.username " +
                     "WHERE o.oid=?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, oid);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Order o = new Order();
                o.setOid(rs.getInt("oid"));
                o.setSid(rs.getInt("sid"));
                o.setStudentNo(rs.getString("studentNo"));
                o.setPid(rs.getInt("pid"));
                o.setSname(rs.getString("sname"));
                o.setPname(rs.getString("pname"));
                o.setReason(rs.getString("reason"));
                o.setTime_slots(rs.getString("time_slots"));
                o.setO_date(rs.getString("o_date"));
                o.setApply_time(rs.getString("apply_time"));
                o.setStatus(rs.getInt("status"));
                o.setRemark(rs.getString("remark"));

                o.setTid(rs.getString("teacher_username"));
                o.setTname(rs.getString("teacher_name"));
                o.setOperate_time(rs.getString("operate_time"));
                
                return o;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, null, null);
        }
        return null;
    }

    // 老师页面需要的 listAll()（已修复：显示学生学号 + 老师工号）
    public List<Order> listAll() {
        List<Order> list = new ArrayList<>();
        Connection conn = DBUtil.getConn();
        String sql = "SELECT o.*,u.username studentNo, u.name sname,p.pname pname, o.tid teacher_username, t.name teacher_name " +
                     "FROM orders o " +
                     "LEFT JOIN user u ON o.sid=u.id " +
                     "LEFT JOIN place p ON o.pid=p.pid " +
                     "LEFT JOIN user t ON o.tid = t.username " +
                     "ORDER BY o.oid DESC";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOid(rs.getInt("oid"));
                o.setSid(rs.getInt("sid"));
                o.setStudentNo(rs.getString("studentNo"));
                o.setSname(rs.getString("sname"));
                o.setPname(rs.getString("pname"));
                o.setReason(rs.getString("reason"));
                o.setTime_slots(rs.getString("time_slots"));
                o.setO_date(rs.getString("o_date"));
                o.setApply_time(rs.getString("apply_time"));
                o.setStatus(rs.getInt("status"));
                o.setRemark(rs.getString("remark"));

                o.setTid(rs.getString("teacher_username"));
                o.setTname(rs.getString("teacher_name"));
                o.setOperate_time(rs.getString("operate_time"));
                
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, null, null);
        }
        return list;
    }

    // 管理员筛选查询（已修复）
    public List<Order> listByFilter(String stuStart, String stuEnd, String optStart, String optEnd) {
        List<Order> list = new ArrayList<>();
        Connection conn = DBUtil.getConn();

        StringBuilder sql = new StringBuilder(
            "SELECT o.*, u.username studentNo, u.name sname, p.pname pname, o.tid teacher_username, t.name teacher_name " +
            "FROM orders o " +
            "LEFT JOIN user u ON o.sid = u.id " +
            "LEFT JOIN place p ON o.pid = p.pid " +
            "LEFT JOIN user t ON o.tid = t.username " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        // 学生预约日期筛选
        if (stuStart != null && !stuStart.isEmpty()) {
            sql.append("AND o.o_date >= ? ");
            params.add(stuStart);
        }
        if (stuEnd != null && !stuEnd.isEmpty()) {
            sql.append("AND o.o_date <= ? ");
            params.add(stuEnd);
        }

        // 老师操作时间筛选
        if (optStart != null && !optStart.isEmpty()) {
            sql.append("AND o.operate_time >= ? ");
            params.add(optStart);
        }
        if (optEnd != null && !optEnd.isEmpty()) {
            sql.append("AND o.operate_time <= ? ");
            params.add(optEnd);
        }

        sql.append("ORDER BY o.oid DESC");

        try {
            PreparedStatement pstmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOid(rs.getInt("oid"));
                o.setSid(rs.getInt("sid"));
                o.setStudentNo(rs.getString("studentNo"));
                o.setSname(rs.getString("sname"));
                o.setPid(rs.getInt("pid"));
                o.setPname(rs.getString("pname"));
                o.setReason(rs.getString("reason"));
                o.setTime_slots(rs.getString("time_slots"));
                o.setO_date(rs.getString("o_date"));
                o.setApply_time(rs.getString("apply_time"));
                o.setStatus(rs.getInt("status"));
                o.setRemark(rs.getString("remark"));

                o.setTid(rs.getString("teacher_username"));
                o.setTname(rs.getString("teacher_name"));
                o.setOperate_time(rs.getString("operate_time"));
               
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, null, null);
        }
        return list;
    }

    // 查询已预约时段
    public List<Order> getBookedOrdersByPidAndDate(int pid, String date) {
        List<Order> list = new ArrayList<>();
        Connection conn = DBUtil.getConn();
        String sql = "SELECT * FROM orders WHERE pid=? AND o_date=? AND status IN (0,1)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, pid);
            pstmt.setString(2, date);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOid(rs.getInt("oid"));
                o.setPid(rs.getInt("pid"));
                o.setO_date(rs.getString("o_date"));
                o.setTime_slots(rs.getString("time_slots"));
                o.setStatus(rs.getInt("status"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, null, null);
        }
        return list;
    }
}