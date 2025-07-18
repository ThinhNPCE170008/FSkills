package dao;

import java.io.InputStream;
import java.sql.*;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Module;
import model.Category;
import model.Course;
import model.Role;
import model.User;
import util.DBContext;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
public class CourseDAO extends DBContext {

    public CourseDAO() {
        super();
    }

    public List<Course> getCourseByUserID(int userID) {
        List<Course> list = new ArrayList<>();

        String sql = "SELECT\n"
                + "u.DisplayName, u.Email, u.Role, u.Gender, u.DateOfBirth, u.Info, u.Avatar, u.PhoneNumber,\n"
                + "c.*,\n"
                + "cat.category_id, cat.category_name\n"
                + "FROM Courses c\n"
                + "JOIN Users u ON c.UserID = u.UserID\n"
                + "JOIN Category cat ON c.category_id = cat.category_id\n"
                + "WHERE c.UserID = ? AND c.Status = 0 AND (c.ApproveStatus = 0 OR c.ApproveStatus = 1 OR c.ApproveStatus = 3)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setUserId(userID);
                user.setDisplayName(rs.getString("DisplayName"));
                user.setEmail(rs.getString("Email"));
                user.setPhone(rs.getString("PhoneNumber"));
                int roleInt = rs.getInt("Role");
                switch (roleInt) {
                    case 0:
                        user.setRole(Role.LEARNER);
                        break;
                    case 1:
                        user.setRole(Role.INSTRUCTOR);
                        break;
                    case 2:
                        user.setRole(Role.ADMIN);
                        break;
                }
                user.setGender(rs.getInt("Gender"));
                user.setDateOfBirth(rs.getTimestamp("DateOfBirth"));
                user.setAvatar(rs.getBytes("Avatar"));
                user.setInfo(rs.getNString("Info"));

                Category category = new Category();
                category.setId(rs.getInt("category_id"));
                category.setName(rs.getNString("category_name"));

                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setCourseName(rs.getNString("CourseName"));
                course.setUser(user);
                course.setCategory(category);
                course.setApproveStatus(rs.getInt("ApproveStatus"));
                course.setPublicDate(rs.getTimestamp("PublicDate"));
                course.setCourseLastUpdate(rs.getTimestamp("CourseLastUpdate"));
                course.setSalePrice(rs.getInt("SalePrice"));
                course.setOriginalPrice(rs.getInt("OriginalPrice"));
                course.setIsSale(rs.getInt("IsSale"));
                course.setCourseImageLocation(rs.getBytes("CourseImageLocation"));
                course.setCourseSummary(rs.getNString("CourseSummary"));
                course.setCourseHighlight(rs.getNString("CourseHighlight"));

                list.add(course);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Course> get3CourseByUserID(int userID) {
        List<Course> list = new ArrayList<>();

        String sql = "SELECT TOP 3\n"
                + "    u.DisplayName, u.Email, u.Role, u.Gender, u.DateOfBirth, u.Info, u.Avatar, u.PhoneNumber,\n"
                + "    c.*,\n"
                + "    cat.category_id, cat.category_name,\n"
                + "    COUNT(DISTINCT e.UserID) AS TotalEnrolled\n"
                + "FROM Courses c\n"
                + "JOIN Users u ON c.UserID = u.UserID\n"
                + "JOIN Category cat ON c.category_id = cat.category_id\n"
                + "LEFT JOIN Enroll e ON c.CourseID = e.CourseID\n"
                + "WHERE c.UserID = ? \n"
                + "  AND c.Status = 0 \n"
                + "  AND c.ApproveStatus = 1\n"
                + "GROUP BY\n"
                + "    u.DisplayName, u.Email, u.Role, u.Gender, u.DateOfBirth, u.Info, u.Avatar, u.PhoneNumber,\n"
                + "    c.CourseID, c.CourseName, c.OriginalPrice, c.SalePrice, c.IsSale, \n"
                + "    c.CourseImageLocation, c.PublicDate, c.CourseLastUpdate, c.Status, c.ApproveStatus, c.UserID, c.category_id,\n"
                + "    c.CourseSummary, c.CourseHighlight,\n"
                + "    cat.category_id, cat.category_name\n"
                + "ORDER BY TotalEnrolled DESC;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setUserId(userID);
                user.setDisplayName(rs.getString("DisplayName"));
                user.setEmail(rs.getString("Email"));
                user.setPhone(rs.getString("PhoneNumber"));
                int roleInt = rs.getInt("Role");
                switch (roleInt) {
                    case 0:
                        user.setRole(Role.LEARNER);
                        break;
                    case 1:
                        user.setRole(Role.INSTRUCTOR);
                        break;
                    case 2:
                        user.setRole(Role.ADMIN);
                        break;
                }
                user.setGender(rs.getInt("Gender"));
                user.setDateOfBirth(rs.getTimestamp("DateOfBirth"));
                user.setAvatar(rs.getBytes("Avatar"));
                user.setInfo(rs.getNString("Info"));

                Category category = new Category();
                category.setId(rs.getInt("category_id"));
                category.setName(rs.getNString("category_name"));

                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setCourseName(rs.getNString("CourseName"));
                course.setUser(user);
                course.setCategory(category);
                course.setApproveStatus(rs.getInt("ApproveStatus"));
                course.setPublicDate(rs.getTimestamp("PublicDate"));
                course.setCourseLastUpdate(rs.getTimestamp("CourseLastUpdate"));
                course.setSalePrice(rs.getInt("SalePrice"));
                course.setOriginalPrice(rs.getInt("OriginalPrice"));
                course.setIsSale(rs.getInt("IsSale"));
                course.setCourseImageLocation(rs.getBytes("CourseImageLocation"));
                course.setCourseSummary(rs.getNString("CourseSummary"));
                course.setCourseHighlight(rs.getNString("CourseHighlight"));
                course.setTotalEnrolled(rs.getInt("TotalEnrolled"));

                list.add(course);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public Course getCourseByCourseID(int courseID) {

        String sql = "SELECT c.*,\n"
                + "cat.category_name,\n"
                + "u.DisplayName\n"
                + "FROM Courses c\n"
                + "JOIN Users u ON c.UserID = u.UserID\n"
                + "JOIN Category cat ON c.category_id = cat.category_id\n"
                + "WHERE c.CourseID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setDisplayName(rs.getNString("DisplayName"));

                Category category = new Category();
                category.setId(rs.getInt("category_id"));
                category.setName(rs.getNString("category_name"));

                Course course = new Course();
                course.setCourseID(courseID);
                course.setCourseName(rs.getNString("CourseName"));
                course.setCategory(category);
                course.setUser(user);
                course.setApproveStatus(rs.getInt("ApproveStatus"));
                course.setPublicDate(rs.getTimestamp("PublicDate"));
                course.setCourseLastUpdate(rs.getTimestamp("CourseLastUpdate"));
                course.setSalePrice(rs.getInt("SalePrice"));
                course.setOriginalPrice(rs.getInt("OriginalPrice"));
                course.setIsSale(rs.getInt("IsSale"));
                course.setCourseImageLocation(rs.getBytes("CourseImageLocation"));
                course.setCourseSummary(rs.getNString("CourseSummary"));
                course.setCourseHighlight(rs.getNString("CourseHighlight"));

                return course;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public int insertCourse(String courseName, int categoryId, int userID, int originalPrice, InputStream courseImageLocation, String courseSummary, String courseHighlight) {

        String sql = "INSERT INTO Courses\n"
                + "(CourseName, category_id, UserID, ApproveStatus, CourseLastUpdate, "
                + "OriginalPrice, CourseImageLocation, CourseSummary, CourseHighlight, Status)\n"
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setNString(1, courseName);
            ps.setInt(2, categoryId);
            ps.setInt(3, userID);
            ps.setInt(4, 0);
            ps.setTimestamp(5, Timestamp.from(Instant.now()));
//            ps.setInt(6, salePrice);
            ps.setInt(6, originalPrice);
//            ps.setInt(8, isSale);
            if (courseImageLocation != null) {
                ps.setBinaryStream(7, courseImageLocation, courseImageLocation.available());
            } else {
                ps.setNull(7, Types.VARBINARY);
            }
            ps.setNString(8, courseSummary);
            ps.setNString(9, courseHighlight);

            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (Exception e) {
            System.out.println("Insert failed: " + e.getMessage());
        }
        return 0;
    }

    public int updateCourse(int courseID, String courseName, int categoryId, int originalPrice, InputStream courseImageLocation, String courseSummary, String courseHighlight) {

        String sql = "UPDATE Courses\n"
                + "SET CourseName = ?, category_id = ?, CourseLastUpdate = ?, OriginalPrice = ?, CourseImageLocation = ?, CourseSummary = ?, CourseHighlight = ?\n"
                + "WHERE CourseID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setNString(1, courseName);
            ps.setInt(2, categoryId);
            ps.setTimestamp(3, Timestamp.from(Instant.now()));
//            ps.setInt(4, salePrice);
            ps.setInt(4, originalPrice);
//            ps.setInt(6, isSale);
            if (courseImageLocation != null) {
                ps.setBinaryStream(5, courseImageLocation, courseImageLocation.available());
            } else {
                ps.setNull(5, Types.VARBINARY);
            }
            ps.setNString(6, courseSummary);
            ps.setNString(7, courseHighlight);
            ps.setInt(8, courseID);

            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;

        } catch (Exception e) {
            System.out.println("Update failed: " + e.getMessage());
        }
        return 0;
    }

    public int deleteCourse(int courseID) {
        String sql = "DELETE FROM Courses WHERE CourseID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseID);

            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int checkStatus(int courseID) {
        String sql = "UPDATE Courses SET [Status] = 1, CourseLastUpdate = SYSUTCDATETIME() WHERE CourseID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseID);

            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;

    }

    public int onGoingLearner(int courseID) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS onGoingLearner FROM Enroll WHERE CourseID = ? AND CompleteDate IS NULL";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseID);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return count;
    }

    public int countCoursesByUserID(int userId) {
        String sql = "SELECT COUNT(*) AS CourseCount FROM Courses WHERE UserID = ? AND Status = 0 AND (ApproveStatus = 0 OR ApproveStatus = 1 OR ApproveStatus = 3)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("CourseCount");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countLearnersByUserID(int userId) {
        String sql = "SELECT COUNT(DISTINCT Enroll.UserID) AS LearnerCount FROM Enroll\n"
                + "JOIN Courses ON Enroll.CourseID = Courses.CourseID\n"
                + "WHERE Courses.UserID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("LearnerCount");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public double getAverageRatingByUserID(int userID) {
        double avgRating = 0.0;
        String sql = "SELECT \n"
                + "    AVG(Rate) AS AvgRating\n"
                + "FROM Feedbacks f\n"
                + "JOIN Courses c ON c.CourseID = f.CourseID\n"
                + "WHERE c.UserID = ? AND c.ApproveStatus = 1";

        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                avgRating = rs.getDouble("avgRating");

            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return avgRating;
    }

    public int submitCourseApprove(int courseID) {
        String sql = "UPDATE Courses SET ApproveStatus = 3 WHERE CourseID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseID);

            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }


    public int courseUpdateTime(int id) {
        String updateSql = "  UPDATE [dbo].[Courses] SET [CourseLastUpdate] = GETDATE() WHERE [CourseID] = ?;";
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
            System.out.println("Error updating course time: " + e.getMessage());
            return 0;
        }
    }

    public List<Course> getAllCourses(int page, int pageSize) {
        List<Course> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT "
                + "u.DisplayName, u.Email, u.Role, u.Gender, u.DateOfBirth, u.Info, u.Avatar, u.PhoneNumber, "
                + "c.*, "
                + "cat.category_id, cat.category_name "
                + "FROM Courses c "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "JOIN Category cat ON c.category_id = cat.category_id "
                + "WHERE c.ApproveStatus = 1 "
                + "ORDER BY c.PublicDate DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course course = buildCourseFromResultSet(rs);
                list.add(course);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Course> searchCourses(String keyword, int page, int pageSize) {
        List<Course> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT "
                + "u.DisplayName, u.Email, u.Role, u.Gender, u.DateOfBirth, u.Info, u.Avatar, u.PhoneNumber, "
                + "c.*, "
                + "cat.category_id, cat.category_name "
                + "FROM Courses c "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "JOIN Category cat ON c.category_id = cat.category_id "
                + "WHERE c.ApproveStatus = 1 "
                + "AND (c.CourseName LIKE ? OR c.CourseSummary LIKE ? OR cat.category_name LIKE ?) "
                + "ORDER BY c.PublicDate DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setInt(4, offset);
            ps.setInt(5, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course course = buildCourseFromResultSet(rs);
                list.add(course);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Course> getCoursesByCategory(String categoryName, int page, int pageSize) {
        List<Course> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT "
                + "u.DisplayName, u.Email, u.Role, u.Gender, u.DateOfBirth, u.Info, u.Avatar, u.PhoneNumber, "
                + "c.*, "
                + "cat.category_id, cat.category_name "
                + "FROM Courses c "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "JOIN Category cat ON c.category_id = cat.category_id "
                + "WHERE c.ApproveStatus = 1 AND cat.category_name = ? "
                + "ORDER BY c.PublicDate DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, categoryName);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course course = buildCourseFromResultSet(rs);
                list.add(course);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Course> searchAndFilterCourses(String keyword, String categoryName, int page, int pageSize) {
        List<Course> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT "
                + "u.DisplayName, u.Email, u.Role, u.Gender, u.DateOfBirth, u.Info, u.Avatar, u.PhoneNumber, "
                + "c.*, "
                + "cat.category_id, cat.category_name "
                + "FROM Courses c "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "JOIN Category cat ON c.category_id = cat.category_id "
                + "WHERE c.ApproveStatus = 1 "
                + "AND (c.CourseName LIKE ? OR c.CourseSummary LIKE ? OR cat.category_name LIKE ?) "
                + "AND cat.category_name = ? "
                + "ORDER BY c.PublicDate DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, categoryName);
            ps.setInt(5, offset);
            ps.setInt(6, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course course = buildCourseFromResultSet(rs);
                list.add(course);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public int getTotalCoursesCount() {
        String sql = "SELECT COUNT(*) as total FROM Courses WHERE ApproveStatus = 1";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int getSearchCoursesCount(String keyword) {
        String sql = "SELECT COUNT(*) as total FROM Courses c "
                + "JOIN Category cat ON c.category_id = cat.category_id "
                + "WHERE c.ApproveStatus = 1 "
                + "AND (c.CourseName LIKE ? OR c.CourseSummary LIKE ? OR cat.category_name LIKE ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int getCoursesByCategoryCount(String categoryName) {
        String sql = "SELECT COUNT(*) as total FROM Courses c "
                + "JOIN Category cat ON c.category_id = cat.category_id "
                + "WHERE c.ApproveStatus = 1 AND cat.category_name = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, categoryName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int getSearchAndFilterCoursesCount(String keyword, String categoryName) {
        String sql = "SELECT COUNT(*) as total FROM Courses c "
                + "JOIN Category cat ON c.category_id = cat.category_id "
                + "WHERE c.ApproveStatus = 1 "
                + "AND (c.CourseName LIKE ? OR c.CourseSummary LIKE ? OR cat.category_name LIKE ?) "
                + "AND cat.category_name = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, categoryName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    private Course buildCourseFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("UserID"));
        user.setDisplayName(rs.getString("DisplayName"));
        user.setEmail(rs.getString("Email"));
        user.setPhone(rs.getString("PhoneNumber"));
        int roleInt = rs.getInt("Role");
        switch (roleInt) {
            case 0:
                user.setRole(Role.LEARNER);
                break;
            case 1:
                user.setRole(Role.INSTRUCTOR);
                break;
            case 2:
                user.setRole(Role.ADMIN);
                break;
        }
        user.setGender(rs.getInt("Gender"));
        user.setDateOfBirth(rs.getTimestamp("DateOfBirth"));
        user.setAvatar(rs.getBytes("Avatar"));
        user.setInfo(rs.getNString("Info"));

        Category category = new Category();
        category.setId(rs.getInt("category_id"));
        category.setName(rs.getNString("category_name"));

        Course course = new Course();
        course.setCourseID(rs.getInt("CourseID"));
        course.setCourseName(rs.getNString("CourseName"));
        course.setUser(user);
        course.setCategory(category);
        course.setApproveStatus(rs.getInt("ApproveStatus"));
        course.setPublicDate(rs.getTimestamp("PublicDate"));
        course.setCourseLastUpdate(rs.getTimestamp("CourseLastUpdate"));
        course.setSalePrice(rs.getInt("SalePrice"));
        course.setOriginalPrice(rs.getInt("OriginalPrice"));
        course.setIsSale(rs.getInt("IsSale"));
        course.setCourseImageLocation(rs.getBytes("CourseImageLocation"));
        course.setCourseSummary(rs.getNString("CourseSummary"));
        course.setCourseHighlight(rs.getNString("CourseHighlight"));

        return course;
    }

    public Course getCourseByCourseIDAdmin(int courseID) throws SQLException {
        String sql = "SELECT c.*, "
                + "cat.category_name, "
                + "u.DisplayName, u.Email, u.Role, u.Gender, u.DateOfBirth, u.Info, u.Avatar, u.PhoneNumber, "
                + "COALESCE(e.TotalEnrolled, 0) AS TotalEnrolled "
                + "FROM Courses c "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "JOIN Category cat ON c.category_id = cat.category_id "
                + "LEFT JOIN (SELECT CourseID, COUNT(*) AS TotalEnrolled FROM Enroll GROUP BY CourseID) e ON c.CourseID = e.CourseID "
                + "WHERE c.CourseID = ?";

        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Course course = buildCourseFromResultSet(rs);
                course.setTotalEnrolled(rs.getInt("TotalEnrolled"));
                course.setStatus(rs.getInt("Status"));

                // Get modules
                ModuleDAO moduleDAO = new ModuleDAO();
                List<Module> modules = moduleDAO.getModulesByCourseIDAdmin(courseID);
                course.setModules(modules);

                return course;
            }
        } catch (SQLException e) {
            System.out.println("Error in getCourseByCourseIDAdmin: " + e.getMessage());
        }
        return null;
    }

    public int deleteCourseAdmin(int courseID) {
        String checkEnrollmentSql = "SELECT COUNT(*) AS enrolledCount FROM Enroll WHERE CourseID = ?";
        String deleteCourseSql = "DELETE FROM Courses WHERE CourseID = ?";

        try (
                 PreparedStatement checkPs = conn.prepareStatement(checkEnrollmentSql)) {
            checkPs.setInt(1, courseID);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                int enrolledCount = rs.getInt("enrolledCount");
                if (enrolledCount > 0) {
                    return -1;
                }
            }

            ModuleDAO moduleDAO = new ModuleDAO();
            moduleDAO.deleteModulesByCourseIDAdmin(courseID);

            try ( PreparedStatement deletePs = conn.prepareStatement(deleteCourseSql)) {
                deletePs.setInt(1, courseID);
                int rowsAffected = deletePs.executeUpdate();
                return rowsAffected > 0 ? 1 : 0;
            }

        } catch (SQLException e) {
            System.out.println("Error in deleteCourseAdmin: " + e.getMessage());
            return -2;
        }
    }

    public List<Course> getAllCoursesAdmin(int page, int pageSize) {
        List<Course> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT "
                + "u.DisplayName, u.Email, u.Role, u.Gender, u.DateOfBirth, u.Info, u.Avatar, u.PhoneNumber, "
                + "c.*, "
                + "cat.category_id, cat.category_name, "
                + "COALESCE(e.TotalEnrolled, 0) AS TotalEnrolled "
                + "FROM Courses c "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "JOIN Category cat ON c.category_id = cat.category_id "
                + "LEFT JOIN (SELECT CourseID, COUNT(*) AS TotalEnrolled FROM Enroll GROUP BY CourseID) e ON c.CourseID = e.CourseID "
                + "ORDER BY c.PublicDate DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course course = buildCourseFromResultSet(rs);
                course.setTotalEnrolled(rs.getInt("TotalEnrolled"));
                course.setStatus(rs.getInt("Status"));
                list.add(course);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public static void main(String[] args) {
        List<Course> list = new ArrayList<>();
        CourseDAO dao = new CourseDAO();

        list = dao.getCourseByUserID(3);
        for (Course course : list) {
            System.out.println(course);
        }

        ZonedDateTime now = ZonedDateTime.now(ZoneId.of("UTC"));
        System.out.println("UTC time: " + now);

        ZonedDateTime vn = ZonedDateTime.now(ZoneId.of("Asia/Saigon"));
        System.out.println("VN time: " + vn);

//        String secretKey = System.getenv("CLOUDFLARE_SECRET_KEY");
        String GOOGLE_CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");
        String GOOGLE_CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET");
//        String turnstileSiteKey = System.getenv("CLOUDFLARE_SITE_KEY");
//        System.out.println("Secret Key:" + secretKey);
//        System.out.println("Site Key:" + turnstileSiteKey);
        System.out.println("Client Key:" + GOOGLE_CLIENT_ID);
        System.out.println("Secret Google Key:" + GOOGLE_CLIENT_SECRET);
//        System.out.println("Local JVM time: " + ZonedDateTime.now());

//        Instant nowInstant = Instant.now();
//        System.out.println("Instant.now(): " + now);

//        List<Course> courseList = dao.get3CourseByUserID(3);
//        for (Course course : courseList) {
//            System.out.println(course);
//        }

        String YOUTUBE_API_KEY = System.getenv("YOUTUBE_API_KEY");
        System.out.println(YOUTUBE_API_KEY);
    }
}
