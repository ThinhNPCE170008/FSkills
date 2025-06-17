/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

        String sql = "SELECT Users.*, Courses.* FROM Courses JOIN Users ON Courses.UserID = Users.UserID WHERE Users.UserID = ?";

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

        String sql = "SELECT TOP 3 Users.*, Courses.* FROM Courses JOIN Users ON Courses.UserID = Users.UserID WHERE Users.UserID = ? ORDER BY PublicDate DESC";

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

        String sql = "SELECT Courses.*, Users.DisplayName, Users.Email, Users.Gender, Users.DateOfBirth, Users.Avatar, Users.Info\n"
                + "FROM Courses JOIN Users ON Courses.UserID = Users.UserID\n"
                + "WHERE Courses.CourseID = ?";

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
        String sql = "INSERT INTO Courses (CourseName, CourseCategory, UserID, ApproveStatus, CourseLastUpdate, SalePrice, OriginalPrice, IsSale, CourseImageLocation) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
    
    public int onGoingLearner(int courseID) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS onGoingLearner FROM Enroll WHERE CourseID = ? AND CompleteDate IS NULL";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseID);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return count;
    }

    public int countCoursesByUserID(int userId) {
        String sql = "SELECT COUNT(*) AS CourseCount FROM Courses WHERE UserID = ?";
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
        String sql = "SELECT COUNT(DISTINCT Enroll.UserID) AS LearnerCount FROM Enroll\n" +
                "JOIN Courses ON Enroll.CourseID = Courses.CourseID\n" +
                "WHERE Courses.UserID = ?";

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

    public static void main(String[] args) {
        List<Course> list = new ArrayList<>();

        CourseDAO dao = new CourseDAO();

//        list = dao.getCourseByUserID(3);
//        for (Course course : list) {
//            System.out.println(course);
//        }

//        Course course = dao.getCourseByCourseID(2);
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
