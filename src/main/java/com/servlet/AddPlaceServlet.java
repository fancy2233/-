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

@MultipartConfig
@WebServlet("/teacher/addPlace")
public class AddPlaceServlet extends HttpServlet {

    private static final String UPLOAD_FOLDER = "img";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // ====================== 🔥 新增：获取当前登录老师 ======================
        User teacher = (User) request.getSession().getAttribute("user");
        int tid = teacher.getId();

        // 1. 获取表单数据
        String pname = request.getParameter("pname");
        String location = request.getParameter("location");
        int max_num = Integer.parseInt(request.getParameter("max_num"));
        String open_time = request.getParameter("open_time");
        String equipment = request.getParameter("equipment");

        // 2. 处理图片上传
        Part imgPart = request.getPart("imgFile");
        String fileName = getFileName(imgPart);
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_FOLDER;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        imgPart.write(uploadPath + File.separator + fileName);
        String imgPath = UPLOAD_FOLDER + "/" + fileName;

        // 3. 组装Place对象，插入数据库
        Place place = new Place();
        place.setPname(pname);
        place.setEquipment(equipment);
        place.setMax_num(max_num);
        place.setOpen_time(open_time);
        place.setImg(imgPath);
        place.setStatus(0);

        // ====================== 🔥 新增：记录老师操作信息 ======================
        place.setTid(tid);
        place.setOperateType("新增");

        PlaceDao placeDao = new PlaceDao();
        placeDao.add(place);

        // 4. 跳转回教室列表
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