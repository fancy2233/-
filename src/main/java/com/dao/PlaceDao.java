package com.dao;

import com.entity.Place;
import com.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PlaceDao {

    // ====================== 学生/老师通用查询（显示所有教室） ======================
    public List<Place> listAllPlace() {
        List<Place> placeList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConn();
            // 🔥 只改这里：只查询 status=0（未删除）的教室
            String sql = "SELECT * FROM place WHERE status=0";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Place place = new Place();
                place.setPid(rs.getInt("pid"));
                place.setPname(rs.getString("pname"));
                place.setEquipment(rs.getString("equipment"));
                place.setMax_num(rs.getInt("max_num"));
                place.setImg(rs.getString("img"));
                place.setStatus(rs.getInt("status"));
                place.setOpen_time(rs.getString("open_time"));

                place.setLocation("");
                place.setType("");

                placeList.add(place);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return placeList;
    }

    // ====================== 管理员专用：只查老师操作过的教室 ======================
    public List<Place> listAllForAdmin() {
        List<Place> placeList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConn();
            // 🔥 修复：关联老师表，只查询有老师操作的记录
            String sql = "SELECT p.*, u.username, u.name tname " +
                         "FROM place p " +
                         "LEFT JOIN user u ON p.tid = u.id " +
                         "WHERE p.tid IS NOT NULL " +
                         "ORDER BY p.updateTime DESC";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Place place = new Place();
                place.setPid(rs.getInt("pid"));
                place.setPname(rs.getString("pname"));
                place.setEquipment(rs.getString("equipment"));
                place.setMax_num(rs.getInt("max_num"));
                place.setOpen_time(rs.getString("open_time"));
                place.setLocation("");
                place.setType("");

                // 🔥 修复：读取老师信息 + 操作记录
                place.setUsername(rs.getString("username"));
                place.setTname(rs.getString("tname"));
                place.setUpdateTime(rs.getString("updateTime"));
                place.setOperateType(rs.getString("operateType"));

                placeList.add(place);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return placeList;
    }

    // ====================== 基础方法 ======================
    public List<Place> listAll() {
        return listAllPlace();
    }

    // 根据ID查询
    public Place findPlaceById(int pid) {
        Place place = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConn();
            String sql = "SELECT * FROM place WHERE pid = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, pid);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                place = new Place();
                place.setPid(rs.getInt("pid"));
                place.setPname(rs.getString("pname"));
                place.setEquipment(rs.getString("equipment"));
                place.setMax_num(rs.getInt("max_num"));
                place.setImg(rs.getString("img"));
                place.setStatus(rs.getInt("status"));
                place.setOpen_time(rs.getString("open_time"));
                place.setLocation("");
                place.setType("");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return place;
    }

    // ====================== 【修复】新增教室（自动记录老师操作） ======================
    public void add(Place p) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConn();
            // 🔥 修复：加入 tid, operateType, updateTime
            String sql = "INSERT INTO place(pname, equipment, max_num, img, status, open_time, tid, operateType, updateTime) VALUES(?,?,?,?,0,?,?,?,NOW())";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, p.getPname());
            pstmt.setString(2, p.getEquipment());
            pstmt.setInt(3, p.getMax_num());
            pstmt.setString(4, p.getImg());
            pstmt.setString(5, p.getOpen_time());
            pstmt.setInt(6, p.getTid());            // 老师ID
            pstmt.setString(7, p.getOperateType());  // 操作类型：新增
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    // ====================== 【修复】修改教室（自动记录老师操作） ======================
    public void update(Place place) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConn();
            // 🔥 修复：更新时记录 tid、操作类型=编辑、更新时间
            String sql = "UPDATE place SET pname=?, equipment=?, max_num=?, img=?, open_time=?, tid=?, operateType=?, updateTime=NOW() WHERE pid=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, place.getPname());
            pstmt.setString(2, place.getEquipment());
            pstmt.setInt(3, place.getMax_num());
            pstmt.setString(4, place.getImg());
            pstmt.setString(5, place.getOpen_time());
            pstmt.setInt(6, place.getTid());          // 老师ID
            pstmt.setString(7, place.getOperateType());// 操作类型：编辑
            pstmt.setInt(8, place.getPid());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    // ====================== 基础删除 ======================
    public void delete(int pid) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConn();
            String sql = "DELETE FROM place WHERE pid=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, pid);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    // ====================== 老师操作：新增（带日志） ======================
    public void add(Place p, int tid) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConn();
            String sql = "INSERT INTO place " +
                    "(pname, equipment, max_num, img, status, open_time, tid, updateTime, operateType) " +
                    "VALUES(?,?,?,?,0,?,?,NOW(),'新增')";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, p.getPname());
            pstmt.setString(2, p.getEquipment());
            pstmt.setInt(3, p.getMax_num());
            pstmt.setString(4, p.getImg());
            pstmt.setString(5, p.getOpen_time());
            pstmt.setInt(6, tid);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    // ====================== 老师操作：修改（带日志） ======================
    public void update(Place place, int tid) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConn();
            String sql = "UPDATE place SET " +
                    "pname=?, equipment=?, max_num=?, img=?, open_time=?, " +
                    "tid=?, updateTime=NOW(), operateType='编辑' " +
                    "WHERE pid=?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, place.getPname());
            pstmt.setString(2, place.getEquipment());
            pstmt.setInt(3, place.getMax_num());
            pstmt.setString(4, place.getImg());
            pstmt.setString(5, place.getOpen_time());
            pstmt.setInt(6, tid);
            pstmt.setInt(7, place.getPid());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    // ====================== 老师操作：删除（带日志） ======================
    // 🔥 🔥 🔥 只改这个方法！！！
    public void delete(int pid, int tid) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConn();
            // 记录删除操作 + 设置状态为 1（禁用）
            String updateSql = "UPDATE place SET operateType='删除', updateTime=NOW(), tid=?, status=1 WHERE pid=?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setInt(1, tid);
            pstmt.setInt(2, pid);
            pstmt.executeUpdate();

            // 🔥 注释掉！不执行真实删除，只软删除
            // delete(pid);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }
}