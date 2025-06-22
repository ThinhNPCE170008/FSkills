/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import model.Role;
import model.User;
import util.DBContext;

/**
 *
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
public class CourseDAO extends DBContext {

    public CourseDAO() {
        super();
    }

    public List<Course> getCourseByUserID(int userID) {
        List<Course> list = new ArrayList<>();

        String sql = "SELECT Users.*, Courses.* FROM Courses JOIN Users ON Courses.UserID = Users.UserID WHERE Users.UserID = ? AND Courses.Status = 0";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                int courseID = rs.getInt("CourseID");
                String courseName = rs.getNString("CourseName");
                String courseCategory = rs.getNString("CourseCategory");

                user.setUserId(userID);
                user.setDisplayName(rs.getString("DisplayName"));
                user.setEmail(rs.getString("Email"));
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
                user.setAvatar(rs.getString("Avatar"));
                user.setInfo(rs.getNString("Info"));

                int approveStatus = rs.getInt("ApproveStatus");
                Timestamp publicDate = rs.getTimestamp("PublicDate");
                Timestamp courseLastUpdate = rs.getTimestamp("CourseLastUpdate");
                int salePrice = rs.getInt("SalePrice");
                int originalPrice = rs.getInt("OriginalPrice");
                int isSale = rs.getInt("IsSale");
                String courseImageLocation = rs.getString("CourseImageLocation");

                Course course = new Course(courseID, courseName, courseCategory, user, approveStatus, publicDate, courseLastUpdate, salePrice, originalPrice, isSale, courseImageLocation);
                list.add(course);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Course> get3CourseByUserID(int userID) {
        List<Course> list = new ArrayList<>();

        String sql = "SELECT TOP 3 Users.*, Courses.* FROM Courses JOIN Users ON Courses.UserID = Users.UserID WHERE Users.UserID = ? AND Status = 0 ORDER BY PublicDate DESC";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                int courseID = rs.getInt("CourseID");
                String courseName = rs.getNString("CourseName");
                String courseCategory = rs.getNString("CourseCategory");

                user.setUserId(userID);
                user.setDisplayName(rs.getString("DisplayName"));
                user.setEmail(rs.getString("Email"));
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
                user.setAvatar(rs.getString("Avatar"));
                user.setInfo(rs.getNString("Info"));

                int approveStatus = rs.getInt("ApproveStatus");
                Timestamp publicDate = rs.getTimestamp("PublicDate");
                Timestamp courseLastUpdate = rs.getTimestamp("CourseLastUpdate");
                int salePrice = rs.getInt("SalePrice");
                int originalPrice = rs.getInt("OriginalPrice");
                int isSale = rs.getInt("IsSale");
                String courseImageLocation = rs.getString("CourseImageLocation");

                Course course = new Course(courseID, courseName, courseCategory, user, approveStatus, publicDate, courseLastUpdate, salePrice, originalPrice, isSale, courseImageLocation);
                list.add(course);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public Course getCourseByCourseID(int courseID) {

        String sql = "SELECT Courses.*, Users.DisplayName, Users.Email, Users.Gender, Users.DateOfBirth, Users.Avatar, Users.Info\n" +
                "FROM Courses JOIN Users ON Courses.UserID = Users.UserID\n" +
                "WHERE Courses.CourseID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String courseName = rs.getNString("CourseName");
                String courseCategory = rs.getNString("CourseCategory");

                int userID = rs.getInt("UserID");
                String displayName = rs.getNString("DisplayName");
                String email = rs.getString("Email");
                int gender = rs.getInt("Gender");
                Timestamp dateOfBirth = rs.getTimestamp("DateOfBirth");
                String avatar = rs.getString("Avatar");
                String info = rs.getNString("Info");

                int approveStatus = rs.getInt("ApproveStatus");
                Timestamp publicDate = rs.getTimestamp("PublicDate");
                Timestamp courseLastUpdate = rs.getTimestamp("CourseLastUpdate");
                int salePrice = rs.getInt("SalePrice");
                int originalPrice = rs.getInt("OriginalPrice");
                int isSale = rs.getInt("IsSale");
                String courseImageLocation = rs.getString("CourseImageLocation");

                User user = new User(userID, displayName, email, gender, dateOfBirth, avatar, info);

                Course course = new Course(courseID, courseName, courseCategory, user, approveStatus, publicDate, courseLastUpdate, salePrice, originalPrice, isSale, courseImageLocation);
                return course;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public int insertCourse(String courseName, String courseCategory, int userID, int salePrice, int originalPrice, int isSale, String courseImageLocation) {
        String sql = "INSERT INTO Courses (CourseName, CourseCategory, UserID, ApproveStatus, CourseLastUpdate, SalePrice, OriginalPrice, IsSale, CourseImageLocation, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setNString(1, courseName);
            ps.setNString(2, courseCategory);
            ps.setInt(3, userID);
            ps.setInt(4, 0);
            ps.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(6, salePrice);
            ps.setInt(7, originalPrice);
            ps.setInt(8, isSale);
            ps.setString(9, courseImageLocation);

            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int updateCourse(int courseID, String courseName, String courseCategory, int salePrice, int originalPrice, int isSale, String courseImageLocation) {
        String sql = "UPDATE Courses\n"
                + "SET CourseName = ?, CourseCategory = ?, CourseLastUpdate = ?, SalePrice = ?, OriginalPrice = ?, IsSale = ?, CourseImageLocation = ?\n"
                + "WHERE CourseID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setNString(1, courseName);
            ps.setNString(2, courseCategory);
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(4, salePrice);
            ps.setInt(5, originalPrice);
            ps.setInt(6, isSale);
            ps.setString(7, courseImageLocation);
            ps.setInt(8, courseID);

            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (Exception e) {
            System.out.println(e.getMessage());
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
        String sql = "UPDATE Courses SET [Status] = 1 WHERE CourseID = ?";

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
            while (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return count;
    }

    public int countCoursesByUserID(int userId) {
        String sql = "SELECT COUNT(*) AS CourseCount FROM Courses WHERE UserID = ? AND Status = 0";
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

    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT Courses.*, Users.DisplayName, Users.Email, Users.Gender, Users.DateOfBirth, Users.Avatar, Users.Info, Users.Role "
                + "FROM Courses JOIN Users ON Courses.UserID = Users.UserID "
                + "WHERE Courses.ApproveStatus = 1 "
                + "ORDER BY Courses.PublicDate DESC";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course course = createCourseFromResultSet(rs);
                if (course != null) {
                    list.add(course);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getAllCourses: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public List<Course> searchCourses(String searchTerm, String category) {
        List<Course> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT Courses.*, Users.DisplayName, Users.Email, Users.Gender, Users.DateOfBirth, Users.Avatar, Users.Info, Users.Role "
                + "FROM Courses JOIN Users ON Courses.UserID = Users.UserID "
                + "WHERE Courses.ApproveStatus = 1");

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (Courses.CourseName LIKE ? OR Users.DisplayName LIKE ?)");
        }

        if (category != null && !category.trim().isEmpty() && !category.equals("all")) {
            sql.append(" AND Courses.CourseCategory = ?");
        }

        sql.append(" ORDER BY Courses.PublicDate DESC");

        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchPattern = "%" + searchTerm.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            if (category != null && !category.trim().isEmpty() && !category.equals("all")) {
                ps.setString(paramIndex++, category);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course course = createCourseFromResultSet(rs);
                if (course != null) {
                    list.add(course);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in searchCourses: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT CourseCategory FROM Courses WHERE ApproveStatus = 1 AND CourseCategory IS NOT NULL ORDER BY CourseCategory";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String category = rs.getString("CourseCategory");
                if (category != null && !category.trim().isEmpty()) {
                    categories.add(category.trim());
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getAllCategories: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    private Course createCourseFromResultSet(ResultSet rs) {
        try {
            User user = new User();
            int courseID = rs.getInt("CourseID");
            String courseName = rs.getNString("CourseName");
            String courseCategory = rs.getNString("CourseCategory");

            int userID = rs.getInt("UserID");
            user.setUserId(userID);
            user.setDisplayName(rs.getString("DisplayName"));
            user.setEmail(rs.getString("Email"));

            // Handle role safely
            try {
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
                    default:
                        user.setRole(Role.LEARNER);
                }
            } catch (Exception e) {
                user.setRole(Role.LEARNER); // Default role
            }

            user.setGender(rs.getInt("Gender"));
            user.setDateOfBirth(rs.getTimestamp("DateOfBirth"));
            user.setAvatar(rs.getString("Avatar"));
            user.setInfo(rs.getNString("Info"));

            int approveStatus = rs.getInt("ApproveStatus");
            Timestamp publicDate = rs.getTimestamp("PublicDate");
            Timestamp courseLastUpdate = rs.getTimestamp("CourseLastUpdate");
            int salePrice = rs.getInt("SalePrice");
            int originalPrice = rs.getInt("OriginalPrice");
            int isSale = rs.getInt("IsSale");
            String courseImageLocation = rs.getString("CourseImageLocation");

            return new Course(courseID, courseName, courseCategory, user, approveStatus, publicDate, courseLastUpdate, salePrice, originalPrice, isSale, courseImageLocation);
        } catch (Exception e) {
            System.err.println("Error creating Course from ResultSet: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public List<Course> getRelatedCourses(int courseID, String category, int limit) {
        List<Course> relatedCourses = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " Courses.*, Users.DisplayName, Users.Email, Users.Gender, Users.DateOfBirth, Users.Avatar, Users.Info, Users.Role "
                + "FROM Courses JOIN Users ON Courses.UserID = Users.UserID "
                + "WHERE Courses.ApproveStatus = 1 AND Courses.CourseID != ? AND Courses.CourseCategory = ? "
                + "ORDER BY Courses.PublicDate DESC";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseID);
            ps.setNString(2, category);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course course = createCourseFromResultSet(rs);
                if (course != null) {
                    relatedCourses.add(course);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getRelatedCourses: " + e.getMessage());
            e.printStackTrace();
        }
        return relatedCourses;
    }

    public double getAverageCourseRating(int courseID) {
        String sql = "SELECT AVG(RatingValue) AS AverageRating FROM CourseRatings WHERE CourseID = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("AverageRating");
            }
        } catch (Exception e) {
            System.err.println("Error in getAverageCourseRating: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0; // Default to 0 if no ratings or error
    }

    public int getCourseRatingCount(int courseID) {
        String sql = "SELECT COUNT(*) AS RatingCount FROM CourseRatings WHERE CourseID = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("RatingCount");
            }
        } catch (Exception e) {
            System.err.println("Error in getCourseRatingCount: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public List<CourseSection> getCourseCurriculum(int courseID) {
        List<CourseSection> curriculum = new ArrayList<>();
        String sql = "SELECT SectionTitle, SectionDescription FROM CourseSections WHERE CourseID = ? ORDER BY SectionOrder";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CourseSection section = new CourseSection(rs.getString("SectionTitle"), rs.getString("SectionDescription"));
                curriculum.add(section);
            }
        } catch (Exception e) {
            System.err.println("Error in getCourseCurriculum: " + e.getMessage());
            e.printStackTrace();
        }
        return curriculum;
    }

    // Assuming you have a model class for CourseSection
    public static class CourseSection {

        private String title;
        private String description;

        public CourseSection(String title, String description) {
            this.title = title;
            this.description = description;
        }

        public String getTitle() {
            return title;
        }

        public String getDescription() {
            return description;
        }
    }

    public List<String> getCourseHighlights(int courseID) {
        List<String> highlights = new ArrayList<>();
        String sql = "SELECT Highlight FROM CourseHighlights WHERE CourseID = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                highlights.add(rs.getString("Highlight"));
            }
        } catch (Exception e) {
            System.err.println("Error in getCourseHighlights: " + e.getMessage());
            e.printStackTrace();
        }
        return highlights;
    }
//==========================================
    public int courseUpdateTime(int id) {
        String updateSql = "  UPDATE [dbo].[Courses] SET [CourseLastUpdate] = GETDATE() WHERE [CourseID] = ?;";
        try {
            PreparedStatement ps = conn.prepareStatement(updateSql);
            ps.setInt(1, id);
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return 1; // Cập nhật thành công
            } else {
                return 0; // Không có dòng nào bị ảnh hưởng
            }
        } catch (SQLException e) {
            System.out.println("Error updating course time: " + e.getMessage());
            return 0; // Trả về 0 nếu có lỗi
        }
    }
//==============================================
    public static void main(String[] args) {
        List<Course> list = new ArrayList<>();

        CourseDAO dao = new CourseDAO();
//        // Test getAllCourses
//        List<Course> courses = dao.getAllCourses();
//        System.out.println("Total courses: " + courses.size());
//
//        // Test getAllCategories
//        List<String> categories = dao.getAllCategories();
//        System.out.println("Categories: " + categories);

//        list = dao.getCourseByUserID(2);
//        for (Course course : list) {
//            System.out.println(course);
//        }

//        Course course = dao.getCourseByCourseID(2, 2);
//        System.out.println(course);

//        UserDAO udao = new UserDAO();
//        User user = udao.getByUserID(3);
//        int result = dao.insertCourse("C Sharf 123", "Dot Net Programming", 3, 9999, 999999, 0, "https://www.youtube.com/watch?v=de6UvFKbuZQ");
//        System.out.println(result);
//        int result = dao.updateCourse(8, "Bootstrap 5", "Web Develop", 1234, 123456789, 0, "https://www.youtube.com/watch?v=de6UvFKbuZQ");
//        System.out.println(result);
//        int result = dao.deleteCourse(9);
//        System.out.println(result);
//        int result = dao.countCoursesByUserID(2);
//        System.out.println(result);
//        int result = dao.onGoingLearner(16);
//        System.out.println(result);
//        int result = dao.countLearnersByUserID(2);
//        System.out.println(result);
    }
}
