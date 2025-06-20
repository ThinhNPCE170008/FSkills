package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
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
                int videoTime = rs.getInt("VideoTime");
                String materialDescription = rs.getString("MaterialDescription");
                String moduleName = rs.getString("ModuleName");
                int courseID = rs.getInt("CourseID");
                String courseName = rs.getString("CourseName");
                Course course = new Course(courseID , courseName);
                Module module = new Module(moduleID, moduleName,course);
                list.add(new Material(materialID, materialName, module, type, MaterialLastUpdate, 
                        materialOrder,videoTime,materialDescription , materialLocation));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

}
