package dao;

import java.io.InputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Course;
import model.Material;
import model.Module;
import model.User;
import util.DBContext;

public class MaterialDAO extends DBContext {

    public MaterialDAO() {
        super();
    }

    public List<Material> getAllMaterial(int courseId, int moduleId) {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT m.*, mo.ModuleName, c.CourseID, c.CourseName \n"
                + "FROM Materials m \n"
                + "JOIN Modules mo ON m.ModuleID = mo.ModuleID \n"
                + "JOIN Courses c ON mo.CourseID = c.CourseID \n"
                + "WHERE c.CourseID = ? AND mo.ModuleID = ? \n"
                + "ORDER BY m.MaterialOrder;";

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
                byte[] materialFile = rs.getBytes("MaterialFile");
                String materialUrl = rs.getString("MaterialUrl");
                String videoTime = rs.getString("VideoTime");
                String materialDescription = rs.getString("MaterialDescription");
                String fileName = rs.getString("FileName");
                String moduleName = rs.getString("ModuleName");
                int courseID = rs.getInt("CourseID");
                String courseName = rs.getString("CourseName");
                Course course = new Course(courseID, courseName);
                Module module = new Module(moduleID, moduleName, course);
                list.add(new Material(materialID, materialName, module, type, MaterialLastUpdate,
                        materialOrder, videoTime, materialDescription, materialUrl, materialFile, fileName));
            }
            return list;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public int insertMaterial(int moduleID, String materialName, String type, int materialOrder,
            String materialUrl, InputStream materialFile, String fileName, String videoTime, String materialDescription) {
        String sql;
        if (type.equalsIgnoreCase("pdf")) {
            sql = "INSERT INTO [dbo].[Materials] "
                    + "([ModuleID],[MaterialName],[Type],[MaterialLastUpdate],[MaterialOrder],"
                    + "[MaterialFile],[FileName],[MaterialDescription]) "
                    + "VALUES (?, ?, ?, GETDATE(), ?, ?, ?, ?)";
        } else {
            sql = "INSERT INTO [dbo].[Materials] "
                    + "([ModuleID],[MaterialName],[Type],[MaterialLastUpdate],[MaterialOrder],"
                    + "[MaterialUrl],[VideoTime],[MaterialDescription]) "
                    + "VALUES (?, ?, ?, GETDATE(), ?, ?, ?, ?)";
        }
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, moduleID);
            ps.setString(2, materialName);
            ps.setString(3, type);
            ps.setInt(4, materialOrder);
            if (type.equalsIgnoreCase("pdf")) {
                if (materialFile != null) {
                    ps.setBlob(5, materialFile);
                    ps.setString(6, fileName);
                } else {
                    ps.setNull(5, Types.BLOB);
                    ps.setString(6, "No Data");
                }
            } else {
                ps.setString(5, materialUrl);
                ps.setString(6, videoTime);
            }
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
        String sql = "SELECT * \n"
                + "FROM [dbo].[Materials] m\n"
                + "JOIN [dbo].[Modules] mo ON m.ModuleID = mo.ModuleID\n"
                + "JOIN [dbo].[Courses] c ON mo.CourseID = c.CourseID\n"
                + "JOIN [dbo].[Users] u ON c.UserID = u.UserID\n"
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
                byte[] materialFile = rs.getBytes("MaterialFile");
                String fileName = rs.getString("FileName");
                String materialUrl = rs.getString("MaterialUrl");
                String videoTime = rs.getString("VideoTime");
                String materialDescription = rs.getString("MaterialDescription");
                String moduleName = rs.getString("ModuleName");
                int courseID = rs.getInt("CourseID");
                String courseName = rs.getString("CourseName");
                int userId = rs.getInt("UserID");
                String userName = rs.getString("UserName");
                User user = new User(userId, userName);
                Course course = new Course(courseID, courseName, user);
                Module module = new Module(moduleID, moduleName, course);
                material = new Material(materialID, materialName, module, type,
                        MaterialLastUpdate, materialOrder, videoTime, materialDescription,
                        materialUrl, materialFile, fileName);
            }
            return material;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return material;
    }

    public boolean update(String materialName, String type, int order, String materialUrl,
            InputStream materialFile, String fileName,
            String videoTime, String description, int materialId, int moduleId, int courseId, boolean updateNew) {
        String sql;

        if (type.equalsIgnoreCase("pdf")) {
            if (updateNew) {
                sql = "UPDATE mtl SET mtl.MaterialName = ?, mtl.Type = ?,mtl.MaterialLastUpdate = GETDATE(),\n"
                        + "mtl.MaterialOrder = ?, mtl.MaterialFile= ?, mtl.FileName=?,"
                        + "mtl.MaterialUrl = NULL, mtl.VideoTime = NULL, mtl.MaterialDescription = ?\n"
                        + "FROM Materials mtl JOIN Modules m ON mtl.ModuleID = m.ModuleID JOIN Courses c ON m.CourseID = c.CourseID\n"
                        + "WHERE mtl.MaterialID = ? AND m.ModuleID = ? AND c.CourseID = ?; ";
            } else {
                sql = "UPDATE mtl SET mtl.MaterialName = ?, mtl.Type = ?,mtl.MaterialLastUpdate = GETDATE(),\n"
                        + "mtl.MaterialOrder = ?, mtl.MaterialUrl = NULL, mtl.VideoTime = NULL, "
                        + "mtl.MaterialDescription = ?\n"
                        + "FROM Materials mtl JOIN Modules m ON mtl.ModuleID = m.ModuleID JOIN Courses c ON m.CourseID = c.CourseID\n"
                        + "WHERE mtl.MaterialID = ? AND m.ModuleID = ? AND c.CourseID = ?; ";
            }
        } else {
            sql = "UPDATE mtl SET mtl.MaterialName = ?, mtl.Type = ?,mtl.MaterialLastUpdate = GETDATE(),\n"
                    + "mtl.MaterialOrder = ?,mtl.MaterialUrl = ?, mtl.VideoTime = ?,"
                    + "mtl.MaterialFile= NULL, mtl.FileName=NULL, mtl.MaterialDescription = ?\n"
                    + "FROM Materials mtl JOIN Modules m ON mtl.ModuleID = m.ModuleID JOIN Courses c ON m.CourseID = c.CourseID\n"
                    + "WHERE mtl.MaterialID = ? AND m.ModuleID = ? AND c.CourseID = ?; ";
        }

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, materialName);
            ps.setString(2, type);
            ps.setInt(3, order);
            if (updateNew) {
                if (type.equalsIgnoreCase("pdf")) {
                    if (materialFile != null) {
                        ps.setBlob(4, materialFile);
                        ps.setString(5, fileName);
                    } else {
                        ps.setNull(4, Types.BLOB);
                        ps.setString(5, "No Data");
                    }

                } else {
                    ps.setString(4, materialUrl);
                    ps.setString(5, videoTime);
                }
                ps.setString(6, description);
                ps.setInt(7, materialId);
                ps.setInt(8, moduleId);
                ps.setInt(9, courseId);
            } else {
                ps.setString(4, description);
                ps.setInt(5, materialId);
                ps.setInt(6, moduleId);
                ps.setInt(7, courseId);
            }

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

     public List<Material> getMaterialsByModuleIDAdmin(int moduleID) throws SQLException {
        List<Material> materials = new ArrayList<>();
        String query = "SELECT materialId, materialName, moduleID, type, materialLastUpdate, "
                + "materialOrder, time, materialDescription, materialUrl, materialFile, fileName "
                + "FROM Materials WHERE moduleID = ?";
        try ( PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, moduleID);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Material material = new Material();
                    material.setMaterialId(rs.getInt("materialId"));
                    material.setMaterialName(rs.getString("materialName"));

                    // Create a simple module object with just the ID since module name is not needed here
                    Module module = new Module();
                    module.setModuleID(rs.getInt("moduleID"));
                    material.setModule(module);
                    material.setType(rs.getString("type"));
                    material.setMaterialLastUpdate(rs.getTimestamp("materialLastUpdate"));
                    material.setMaterialOrder(rs.getInt("materialOrder"));
                    material.setTime(rs.getString("time"));
                    material.setMaterialDescription(rs.getString("materialDescription"));
                    material.setMaterialUrl(rs.getString("materialUrl"));
                    material.setMaterialFile(rs.getBytes("materialFile"));
                    material.setFileName(rs.getString("fileName"));
                    // Encode PDF file to base64 (nếu cần)
                    if ("pdf".equalsIgnoreCase(material.getType()) && material.getMaterialFile() != null) {
                        String base64 = java.util.Base64.getEncoder().encodeToString(material.getMaterialFile());
                        material.setPdfDataURI("data:application/pdf;base64," + base64);
                    }
                    materials.add(material);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getMaterialsByModuleIDAdmin: " + e.getMessage());
            throw e;
        }
        return materials;
    }

    public int deleteMaterialAdmin(int materialID) throws SQLException {
        String query = "DELETE FROM Materials WHERE materialId = ?";
        try ( PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, materialID);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error in deleteMaterialAdmin: " + e.getMessage());
            throw e;
        }
    }

    public int deleteMaterialsByModuleIDAdmin(int moduleID) throws SQLException {
        String query = "DELETE FROM Materials WHERE moduleID = ?";
        try ( PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, moduleID);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error in deleteMaterialsByModuleIDAdmin: " + e.getMessage());
            throw e;
        }
    }

    public int deleteMaterialsByCourseIDAdmin(int courseID) throws SQLException {
        String query = "DELETE FROM Materials WHERE moduleID IN (SELECT moduleID FROM Modules WHERE courseID = ?)";
        try ( PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, courseID);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error in deleteMaterialsByCourseIDAdmin: " + e.getMessage());
            throw e;
        }
    }
    public boolean checkMaterialOrderExists(int materialOrder, int moduleId, int courseId) {
        boolean exists = false;

        String sql = "SELECT 1 FROM Materials m "
                + "JOIN Modules mo ON m.ModuleID = mo.ModuleID "
                + "JOIN Courses c ON mo.CourseID = c.CourseID \n"
                + "WHERE m.MaterialOrder = ? And mo.ModuleID= ? and c.CourseID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, materialOrder);
            ps.setInt(2, moduleId);
            ps.setInt(3, courseId);
            ResultSet rs = ps.executeQuery();
            exists = rs.next(); // Nếu có dòng nào trả về là tồn tại
        } catch (SQLException e) {
        }

        return exists;
    }

    public boolean checkMaterialOrderExistsForUpdate(int materialOrder, int moduleId,
            int courseId, int materialId) {
        boolean exists = false;
        String sql = "SELECT 1 FROM Materials m JOIN Modules mo ON m.ModuleID = mo.ModuleID "
                + "JOIN Courses c ON mo.CourseID = c.CourseID \n"
                + "WHERE m.MaterialOrder = ? And mo.ModuleID= ? and c.CourseID = ? "
                + "and m.MaterialID != ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, materialOrder);
            ps.setInt(2, moduleId);
            ps.setInt(3, courseId);
            ps.setInt(4, materialId);
            ResultSet rs = ps.executeQuery();
            exists = rs.next();
        } catch (SQLException e) {
        }

        return exists;
    }
    
    public int countMaterialOrderConflict(int moduleId, int courseId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Materials m \n"
                + "JOIN Modules mo ON m.ModuleID = mo.ModuleID \n"
                + "JOIN Courses c ON mo.CourseID = c.CourseID \n"
                + "WHERE mo.ModuleID = ?\n"
                + "AND c.CourseID = ?";

	try {
            PreparedStatement ps = conn.prepareStatement(sql);
	    ps.setInt(1, moduleId);
            ps.setInt(2, courseId);
	    ResultSet rs = ps.executeQuery();
            if (rs.next()) {
	    count = rs.getInt(1);
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
	return count;
    }
    
    public int checkMaterialInCourse(int CourseID) {
        String sql = "SELECT TOP 1\n" +
                "m.MaterialID\n" +
                "FROM Materials m\n" +
                "JOIN Modules mo ON m.ModuleID = mo.ModuleID\n" +
                "WHERE mo.CourseID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, CourseID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return 1;
            } else {
                return 0;
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }
}