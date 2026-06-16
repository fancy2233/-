package com.servlet;

import com.dao.PlaceDao;
import com.entity.Place;
import com.entity.User; // 🔥 必须加
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

// 🔥 关键：加这个注解，原生支持上传
@MultipartConfig
@WebServlet("/teacher/updatePlace")
public class UpdatePlaceServlet extends HttpServlet {

    // 🔥 图片保存路径（你可以直接用这个，自动创建文件夹）
    private static final String UPLOAD_FOLDER = "img";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // ====================== 🔥 新增：获取当前老师 ======================
        User teacher = (User) request.getSession().getAttribute("user");
        int tid = teacher.getId();

        // 1. 获取普通表单字段
        int pid = Integer.parseInt(request.getParameter("pid"));
        String pname = request.getParameter("pname");
        String equipment = request.getParameter("equipment");
        String open_time = request.getParameter("open_time");
        int max_num = Integer.parseInt(request.getParameter("max_num"));

        // 2. 获取上传的图片
        Part imgPart = request.getPart("imgFile");
        String imgFileName = null;

        if (imgPart != null && imgPart.getSize() > 0) {
            // 获取文件名
            String fileName = getFileName(imgPart);

            // 服务器保存路径：项目目录下 /img/xxx.jpg
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_FOLDER;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // 写入文件
            imgPart.write(uploadPath + File.separator + fileName);

            // ====================== ✅ 只改这一行 ======================
            // 原来错误：request.getContextPath() + "/" + UPLOAD_FOLDER + "/" + fileName;
            imgFileName = UPLOAD_FOLDER + "/" + fileName;
        }

        // 3. 查询原来的教室信息
        PlaceDao placeDao = new PlaceDao();
        Place place = placeDao.findPlaceById(pid);

        if (place != null) {
            place.setPname(pname);
            place.setEquipment(equipment);
            place.setOpen_time(open_time);
            place.setMax_num(max_num);

            // 如果上传了新图片，才更新
            if (imgFileName != null) {
                place.setImg(imgFileName);
            }

            // ====================== 🔥 新增：记录老师操作 ======================
            place.setTid(tid);
            place.setOperateType("编辑");

            // 执行更新
            placeDao.update(place);
        }

        // 跳转回老师的教室列表
        response.sendRedirect("/SchoolSystem1/teacher/placeList.jsp");
    }

    // 工具方法：获取上传文件名
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String cd : contentDisposition.split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf("=") + 2, cd.length() - 1).replaceAll("\"", "");
            }
        }
        return null;
    }
}