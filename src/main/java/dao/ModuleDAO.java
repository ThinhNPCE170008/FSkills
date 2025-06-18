package dao;

import model.Course;
import model.Module;
import util.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ModuleDAO extends DBContext {

    public ModuleDAO() {
        super();
    }

    public List<Module> getAllModuleByCourseID(int courseID) {
        List<Module> list = new ArrayList<>();
        String sql = "SELECT M.*, C.CourseName, C.CourseCategory FROM Modules M\n" +
                "JOIN Courses C ON M.CourseID = C.CourseID\n" +
                "WHERE C.CourseID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int moduleID = rs.getInt("ModuleID");
                String moduleName = rs.getString("ModuleName");
                Timestamp moduleLastUpdate = rs.getTimestamp("ModuleLastUpdate");

                String courseName = rs.getString("CourseName");
                String courseCategory = rs.getString("CourseCategory");

                Course course = new Course(courseName, courseCategory);
                Module module = new Module(moduleID, moduleName, course, moduleLastUpdate);

                list.add(module);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public Module getModuleByID(int moduleID) {
        String sql = "SELECT M.*, C.CourseName, C.CourseCategory FROM Modules M\n" +
                "JOIN Courses C ON M.CourseID = C.CourseID\n" +
                "WHERE M.ModuleID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, moduleID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String moduleName = rs.getString("ModuleName");
                Timestamp moduleLastUpdate = rs.getTimestamp("ModuleLastUpdate");

                String courseName = rs.getString("CourseName");
                String courseCategory = rs.getString("CourseCategory");

                Course course = new Course(courseName, courseCategory);
                Module module = new Module(moduleID, moduleName, course, moduleLastUpdate);

                return module;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public int insertModule(Module module) {
        String sql = "INSERT INTO Modules (ModuleName, CourseID, ModuleLastUpdate) VALUES (?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setNString(1, module.getModuleName());
            ps.setInt(2, module.getCourse().getCourseID());
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));

//            String getCourseSql = "SELECT CourseID FROM Modules WHERE ModuleID = ?";
//            PreparedStatement ps2 = conn.prepareStatement(getCourseSql);
//            ps2.setInt(1, module.getModuleID());
//            ResultSet rs = ps2.executeQuery();
//            int courseID = 0;
//            if (rs.next()) {
//                courseID = rs.getInt("CourseID");
//            }

            String updateCourseSql = "UPDATE Courses SET CourseLastUpdate = GETDATE() WHERE CourseID = ?";
            PreparedStatement ps3 = conn.prepareStatement(updateCourseSql);
            ps3.setInt(1, module.getCourse().getCourseID());
            ps3.executeUpdate();

            int insert =  ps.executeUpdate();
            return insert > 0 ? 1 : 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int updateModule(int moduleID, String moduleName) {
        String sql = "UPDATE Modules\n" +
                "SET ModuleName = ?, ModuleLastUpdate = ?\n" +
                "WHERE ModuleID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, moduleName);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, moduleID);

            String getCourseSql = "SELECT CourseID FROM Modules WHERE ModuleID = ?";
            PreparedStatement ps2 = conn.prepareStatement(getCourseSql);
            ps2.setInt(1, moduleID);
            ResultSet rs = ps2.executeQuery();
            int courseID = 0;
            if (rs.next()) {
                courseID = rs.getInt("CourseID");
            }

            String updateCourseSql = "UPDATE Courses SET CourseLastUpdate = GETDATE() WHERE CourseID = ?";
            PreparedStatement ps3 = conn.prepareStatement(updateCourseSql);
            ps3.setInt(1, courseID);
            ps3.executeUpdate();

            int update = ps.executeUpdate();
            return update > 0 ? 1 : 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int deleteModule(int moduleID) {
        String sql = "DELETE FROM Modules\n" +
                "WHERE ModuleID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, moduleID);

            String getCourseSql = "SELECT CourseID FROM Modules WHERE ModuleID = ?";
            PreparedStatement ps2 = conn.prepareStatement(getCourseSql);
            ps2.setInt(1, moduleID);
            ResultSet rs = ps2.executeQuery();
            int courseID = 0;
            if (rs.next()) {
                courseID = rs.getInt("CourseID");
            }

            String updateCourseSql = "UPDATE Courses SET CourseLastUpdate = GETDATE() WHERE CourseID = ?";
            PreparedStatement ps3 = conn.prepareStatement(updateCourseSql);
            ps3.setInt(1, courseID);
            ps3.executeUpdate();

            int update = ps.executeUpdate();
            return update > 0 ? 1 : 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public static void main(String[] args) {
        ModuleDAO dao = new ModuleDAO();
        CourseDAO courseDAO = new CourseDAO();
        List<Module> modules = new ArrayList<>();

//        modules = dao.getAllModuleByCourseID(1);
//        for (Module module : modules) {
//            System.out.println(module);
//        }

//        Module m = dao.getModuleByID(1);
//        System.out.println(m);

//        Course course = new Course();
//        course = courseDAO.getCourseByCourseID(2);
//        Module module = new Module("Miền Bắc Tiến Lên", course);
//        int result = dao.insertModule(module);
//        System.out.println(result);

//        int result = dao.updateModule(6,"Ba Cào Thắng");
//        System.out.println(result);

//        int result = dao.deleteModule(7);
//        System.out.println(result);
    }
}
