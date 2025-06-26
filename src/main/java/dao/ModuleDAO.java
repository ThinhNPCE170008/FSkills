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

import model.Category;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
public class ModuleDAO extends DBContext {

    public ModuleDAO() {
        super();
    }

    public List<Module> getAllModuleByCourseID(int courseID) {
        List<Module> list = new ArrayList<>();
        String sql = "SELECT m.*, c.CourseName, cat.category_id, cat.category_name "
                + "FROM Modules m "
                + "JOIN Courses c ON m.CourseID = c.CourseID "
                + "JOIN Category cat ON c.category_id = cat.category_id "
                + "WHERE c.CourseID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("category_id"));
                category.setName(rs.getNString("category_name"));

                Course course = new Course();
                course.setCourseID(courseID);
                course.setCourseName(rs.getNString("CourseName"));
                course.setCategory(category);

                Module module = new Module();
                module.setModuleID(rs.getInt("moduleID"));
                module.setModuleName(rs.getString("moduleName"));
                module.setCourse(course);
                module.setModuleLastUpdate(rs.getTimestamp("ModuleLastUpdate"));

                list.add(module);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public Module getModuleByID(int moduleID) {
        String sql = "SELECT m.*, c.CourseName, c.CourseID, cat.category_id, cat.category_name " +
                "FROM Modules m " +
                "JOIN Courses c ON m.CourseID = c.CourseID " +
                "JOIN Category cat ON c.category_id = cat.category_id " +
                "WHERE m.ModuleID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, moduleID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("category_id"));
                category.setName(rs.getNString("category_name"));

                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setCourseName(rs.getNString("CourseName"));
                course.setCategory(category);

                Module module = new Module();
                module.setModuleID(rs.getInt("moduleID"));
                module.setModuleName(rs.getString("moduleName"));
                module.setCourse(course);
                module.setModuleLastUpdate(rs.getTimestamp("ModuleLastUpdate"));

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

            String updateCourseSql = "UPDATE Courses SET CourseLastUpdate = GETDATE() WHERE CourseID = ?";
            PreparedStatement ps3 = conn.prepareStatement(updateCourseSql);
            ps3.setInt(1, module.getCourse().getCourseID());
            ps3.executeUpdate();

            int insert = ps.executeUpdate();
            return insert > 0 ? 1 : 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int updateModule(int moduleID, String moduleName) {
        String sql = "UPDATE Modules\n"
                + "SET ModuleName = ?, ModuleLastUpdate = ?\n"
                + "WHERE ModuleID = ?";

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
        String sql = "DELETE FROM Modules\n"
                + "WHERE ModuleID = ?";

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

    // Created by DuyHKCE180230
    public int moduleUpdateTime(int id) {
        String updateSql = "UPDATE [dbo].[Modules] SET [ModuleLastUpdate] = GETDATE() WHERE [ModuleID] = ?;";
        try {
            PreparedStatement ps = conn.prepareStatement(updateSql);
            ps.setInt(1, id);
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return 1;
            } else {
                return 0;
            }
        } catch (SQLException e) {
            System.out.println("Error updating module time: " + e.getMessage());
            return 0;
        }
    }

//    public static void main(String[] args) {
//        ModuleDAO dao = new ModuleDAO();
//        CourseDAO courseDAO = new CourseDAO();
//        List<Module> modules = new ArrayList<>();
//
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
//    }
}
