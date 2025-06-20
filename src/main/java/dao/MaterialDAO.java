package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import model.Material;
import model.Module;
import util.DBContext;

public class MaterialDAO extends DBContext {

    public MaterialDAO() {
        super();
    }

    public List<Material> getAllMaterial(int courseId, int moduleId) {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT m.*, mo.ModuleName, c.CourseID,c.CourseName FROM Materials m JOIN Modules mo ON m.ModuleID = mo.ModuleID JOIN Courses c ON mo.CourseID = c.CourseID WHERE c.CourseID = ? AND mo.ModuleID =  ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseId);
            ps.setInt(2, moduleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int materialID = rs.getInt("MaterialID");
                int moduleID = rs.getInt("ModuleID");
                String materialName = rs.getString("MaterialName");
                String type = rs.getString("Type");
                Timestamp MaterialLastUpdate = rs.getTimestamp("MaterialLastUpdate");
                int materialOrder = rs.getInt("MaterialOrder");
                String materialLocation = rs.getString("MaterialLocation");
                String videoTime = rs.getString("VideoTime");
                String materialDescription = rs.getString("MaterialDescription");
                String moduleName = rs.getString("ModuleName");
                int courseID = rs.getInt("CourseID");
                String courseName = rs.getString("CourseName");
                Course course = new Course(courseID, courseName);
                Module module = new Module(moduleID, moduleName, course);
                list.add(new Material(materialID, materialName, module, type, MaterialLastUpdate,
                        materialOrder, videoTime, materialDescription, materialLocation));
            }
            return list;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public int insertMaterial(int moduleID, String materialName, String type, int materialOrder,
            String materialLocation, String videoTime, String materialDescription) {
        String sql = "INSERT INTO [dbo].[Materials] "
                + "([ModuleID],[MaterialName],[Type],[MaterialLastUpdate],[MaterialOrder],"
                + "[MaterialLocation],[VideoTime],[MaterialDescription]) "
                + "VALUES (?, ?, ?, GETDATE(), ?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, moduleID);
            ps.setString(2, materialName);
            ps.setString(3, type);
            ps.setInt(4, materialOrder);
            ps.setString(5, materialLocation);
            ps.setString(6, videoTime);
            ps.setString(7, materialDescription);
            int result = ps.executeUpdate();
            if (result > 0) {
                return 1;
            } else {
                return 0;
            }
        } catch (Exception e) {
            System.out.println("Insert Material Error: " + e.getMessage());
        }
        return 0;
    }

    public Material getMaterialById(int id) {
        Material material = null;
        String sql = "SELECT * FROM [dbo].[Materials] m JOIN [dbo].[Modules] mo ON m.ModuleID = mo.ModuleID JOIN [dbo].[Courses] c \n"
                + "ON mo.CourseID = c.CourseID\n"
                + "WHERE m.MaterialID = ?;";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int materialID = rs.getInt("MaterialID");
                int moduleID = rs.getInt("ModuleID");
                String materialName = rs.getString("MaterialName");
                String type = rs.getString("Type");
                Timestamp MaterialLastUpdate = rs.getTimestamp("MaterialLastUpdate");
                int materialOrder = rs.getInt("MaterialOrder");
                String materialLocation = rs.getString("MaterialLocation");
                String videoTime = rs.getString("VideoTime");
                String materialDescription = rs.getString("MaterialDescription");
                String moduleName = rs.getString("ModuleName");
                int courseID = rs.getInt("CourseID");
                String courseName = rs.getString("CourseName");
                Course course = new Course(courseID, courseName);
                Module module = new Module(moduleID, moduleName, course);
                material = new Material(materialID, materialName, module, type, MaterialLastUpdate, materialOrder, type, materialDescription, materialLocation);
            }
            return material;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return material;
    }

    public boolean update(String materialName, String type, int order, String materialLocation,
            String videoTime, String description, int materialId, int moduleId, int courseId) {
        String sql = "UPDATE mtl SET mtl.MaterialName = ?, mtl.Type = ?,mtl.MaterialLastUpdate = GETDATE(),\n"
                + "mtl.MaterialOrder = ?,mtl.MaterialLocation = ?,mtl.VideoTime = ?, mtl.MaterialDescription = ?\n"
                + "FROM Materials mtl JOIN Modules m ON mtl.ModuleID = m.ModuleID JOIN Courses c ON m.CourseID = c.CourseID\n"
                + "WHERE mtl.MaterialID = ? AND m.ModuleID = ? AND c.CourseID = ?; ";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, materialName);
            ps.setString(2, type);
            ps.setInt(3, order);
            ps.setString(4, materialLocation);
            ps.setString(5, videoTime);
            ps.setString(6, description);
            ps.setInt(7, materialId);
            ps.setInt(8, moduleId);
            ps.setInt(9, courseId);
            int num = ps.executeUpdate();
            if (num > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public int delete(int id) {
        String sql = "DELETE FROM Materials WHERE MaterialID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int num = ps.executeUpdate();
            if (num > 0) {
                return 1;
            } else {
                return 0;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return 0;
    }
}
