/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Comment;
import model.Course;
import model.Module;
import model.Material;
import model.Report;
import model.ReportCategory;
import model.User;
import util.DBContext;

/**
 *
 * @author huakh
 */
public class ReportDAO extends DBContext {

    public ReportDAO() {
        super();
    }

    public List<Report> getAll() {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT r.ReportID,r.ReportDetail, r.ReportDate, u.UserID, u.UserName, u.DisplayName,\n"
                + "c.ReportCategoryID, c.ReportName AS CategoryName, co.CommentID, co.CommentContent,\n"
                + "m.MaterialID, m.MaterialName, mo.ModuleID, mo.ModuleName, cs.CourseID, cs.CourseName,us.UserID as CourseUserID,us.UserName as CourseUserName, us.DisplayName as CourseDisplayName\n"
                + "FROM [FLearn].[dbo].[Reports] r JOIN [FLearn].[dbo].[Users] u  ON r.UserID = u.UserID\n"
                + "JOIN [FLearn].[dbo].[ReportCategory] c ON r.CategoryID = c.ReportCategoryID\n"
                + "LEFT JOIN [FLearn].[dbo].[Comments] co ON r.CommentID = co.CommentID\n"
                + "LEFT JOIN [FLearn].[dbo].[Materials] m ON r.MaterialID = m.MaterialID\n"
                + "LEFT JOIN [FLearn].[dbo].[Modules] mo ON m.ModuleID = mo.ModuleID\n"
                + "LEFT JOIN [FLearn].[dbo].[Courses] cs ON mo.CourseID = cs.CourseID JOIN [FLearn].[dbo].[Users] us  ON cs.UserID = us.UserID";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                //Report
                int reportId = rs.getInt("ReportID");
                String reportDetail = rs.getString("ReportDetail");
                Timestamp reportDate = rs.getTimestamp("ReportDate");
                //user
                int userId = rs.getInt("UserID");
                String userName = rs.getString("UserName");
                String displayName = rs.getString("DisplayName");
                User user = new User(userId, userName, displayName);

                int courseUserID = rs.getInt("courseUserID");
                String courseUserName = rs.getString("CourseUserName");
                String courseDisplayName = rs.getString("CourseDisplayName");
                User courseUser = new User(courseUserID, courseUserName, courseDisplayName);
                //Course
                int courseID = rs.getInt("CourseID");
                String courseName = rs.getString("CourseName");
                Course course = new Course(courseID, courseName, courseUser);
                //Module
                int moduleID = rs.getInt("ModuleID");
                String moduleName = rs.getString("ModuleName");
                Module module = new Module(moduleID, moduleName, course);
                //Material
                int materialID = rs.getInt("MaterialID");
                String materialName = rs.getString("MaterialName");
                Material material = new Material(materialID, materialName, module);
                // Comment
                int commentID = rs.getInt("CommentID");
                Comment comment = null;
                if (!rs.wasNull()) {
                    String commentContent = rs.getString("CommentContent");
                    comment = new Comment(commentID, commentContent);
                }
                //Category
                int reportCategoryID = rs.getInt("ReportCategoryID");
                String categoryName = rs.getString("CategoryName");
                ReportCategory category = new ReportCategory(reportCategoryID, categoryName);

                list.add(new Report(reportId, reportDetail, reportDate, user, category, comment, material));
            }
            return list;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public int createReportMaterial(String reportDetail, int userId, int materialId, int categoryId) {
        String sql = "INSERT INTO [dbo].[Reports] ( [ReportDetail], [ReportDate], [UserID], "
                + "[MaterialID], [CommentID], [CategoryID])\n"
                + "VALUES ( ?, GETDATE(), ?, ?, NULL, ?);";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, reportDetail);
            ps.setInt(2, userId);
            ps.setInt(3, materialId);
            ps.setInt(4, categoryId);
            int row = ps.executeUpdate();
            if (row > 0) {
                return 1;
            } else {
                return 0;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }

    public int createReportComment(String reportDetail, int userId, int materialId, int commentId, int categoryId) {
        String sql = "INSERT INTO [dbo].[Reports] ( [ReportDetail], [ReportDate], [UserID], "
                + "[MaterialID], [CommentID], [CategoryID])\n"
                + "VALUES ( ?, GETDATE(), ?, ?, ?, ?);";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, reportDetail);
            ps.setInt(2, userId);
            ps.setInt(3, materialId);
            ps.setInt(4, commentId);
            ps.setInt(5, categoryId);
            int row = ps.executeUpdate();
            if (row > 0) {
                return 1;
            } else {
                return 0;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }

    public Report getReportByReportId(int id) {
        Report re = null;
        String sql = "SELECT r.ReportID,r.ReportDetail, r.ReportDate, u.UserID, u.UserName, u.DisplayName,\n"
                + "c.ReportCategoryID, c.ReportName AS CategoryName, co.CommentID, co.CommentContent,\n"
                + "m.MaterialID, m.MaterialName, mo.ModuleID, mo.ModuleName, cs.CourseID, cs.CourseName,us.UserID as CourseUserID,us.UserName as CourseUserName, us.DisplayName as CourseDisplayName\n"
                + "FROM [FLearn].[dbo].[Reports] r JOIN [FLearn].[dbo].[Users] u  ON r.UserID = u.UserID\n"
                + "JOIN [FLearn].[dbo].[ReportCategory] c ON r.CategoryID = c.ReportCategoryID\n"
                + "LEFT JOIN [FLearn].[dbo].[Comments] co ON r.CommentID = co.CommentID\n"
                + "LEFT JOIN [FLearn].[dbo].[Materials] m ON r.MaterialID = m.MaterialID\n"
                + "LEFT JOIN [FLearn].[dbo].[Modules] mo ON m.ModuleID = mo.ModuleID\n"
                + "LEFT JOIN [FLearn].[dbo].[Courses] cs ON mo.CourseID = cs.CourseID JOIN [FLearn].[dbo].[Users] us  ON cs.UserID = us.UserID "
                + "WHERE r.ReportID = ?;";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                //Report
                int reportId = rs.getInt("ReportID");
                String reportDetail = rs.getString("ReportDetail");
                Timestamp reportDate = rs.getTimestamp("ReportDate");
                //user
                int userId = rs.getInt("UserID");
                String userName = rs.getString("UserName");
                String displayName = rs.getString("DisplayName");
                User user = new User(userId, userName, displayName);

                int courseUserID = rs.getInt("courseUserID");
                String courseUserName = rs.getString("CourseUserName");
                String courseDisplayName = rs.getString("CourseDisplayName");
                User courseUser = new User(courseUserID, courseUserName, courseDisplayName);
                //Course
                int courseID = rs.getInt("CourseID");
                String courseName = rs.getString("CourseName");
                Course course = new Course(courseID, courseName, courseUser);
                //Module
                int moduleID = rs.getInt("ModuleID");
                String moduleName = rs.getString("ModuleName");
                Module module = new Module(moduleID, moduleName, course);
                //Material
                int materialID = rs.getInt("MaterialID");
                String materialName = rs.getString("MaterialName");
                Material material = new Material(materialID, materialName, module);
                // Comment
                int commentID = rs.getInt("CommentID");
                Comment comment = null;
                if (!rs.wasNull()) {
                    String commentContent = rs.getString("CommentContent");
                    comment = new Comment(commentID, commentContent);
                }
                //Category
                int reportCategoryID = rs.getInt("ReportCategoryID");
                String categoryName = rs.getString("CategoryName");
                ReportCategory category = new ReportCategory(reportCategoryID, categoryName);
                re = new Report(reportId, reportDetail, reportDate, user, category, comment, material);
                return re;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return re;
    }

    public List<Report> getReportByUserId(int id) {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT r.ReportID,r.ReportDetail, r.ReportDate, u.UserID, u.UserName, u.DisplayName,\n"
                + "c.ReportCategoryID, c.ReportName AS CategoryName, co.CommentID, co.CommentContent,\n"
                + "m.MaterialID, m.MaterialName, mo.ModuleID, mo.ModuleName, cs.CourseID, cs.CourseName,us.UserID as CourseUserID,us.UserName as CourseUserName, us.DisplayName as CourseDisplayName\n"
                + "FROM [FLearn].[dbo].[Reports] r JOIN [FLearn].[dbo].[Users] u  ON r.UserID = u.UserID\n"
                + "JOIN [FLearn].[dbo].[ReportCategory] c ON r.CategoryID = c.ReportCategoryID\n"
                + "LEFT JOIN [FLearn].[dbo].[Comments] co ON r.CommentID = co.CommentID\n"
                + "LEFT JOIN [FLearn].[dbo].[Materials] m ON r.MaterialID = m.MaterialID\n"
                + "LEFT JOIN [FLearn].[dbo].[Modules] mo ON m.ModuleID = mo.ModuleID\n"
                + "LEFT JOIN [FLearn].[dbo].[Courses] cs ON mo.CourseID = cs.CourseID JOIN [FLearn].[dbo].[Users] us  ON cs.UserID = us.UserID\n"
                + "WHERE u.UserID=?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                //Report
                int reportId = rs.getInt("ReportID");
                String reportDetail = rs.getString("ReportDetail");
                Timestamp reportDate = rs.getTimestamp("ReportDate");
                //user
                int userId = rs.getInt("UserID");
                String userName = rs.getString("UserName");
                String displayName = rs.getString("DisplayName");
                User user = new User(userId, userName, displayName);

                int courseUserID = rs.getInt("courseUserID");
                String courseUserName = rs.getString("CourseUserName");
                String courseDisplayName = rs.getString("CourseDisplayName");
                User courseUser = new User(courseUserID, courseUserName, courseDisplayName);
                //Course
                int courseID = rs.getInt("CourseID");
                String courseName = rs.getString("CourseName");
                Course course = new Course(courseID, courseName, courseUser);
                //Module
                int moduleID = rs.getInt("ModuleID");
                String moduleName = rs.getString("ModuleName");
                Module module = new Module(moduleID, moduleName, course);
                //Material
                int materialID = rs.getInt("MaterialID");
                String materialName = rs.getString("MaterialName");
                Material material = new Material(materialID, materialName, module);
                // Comment
                int commentID = rs.getInt("CommentID");
                Comment comment = null;
                if (!rs.wasNull()) {
                    String commentContent = rs.getString("CommentContent");
                    comment = new Comment(commentID, commentContent);
                }
                //Category
                int reportCategoryID = rs.getInt("ReportCategoryID");
                String categoryName = rs.getString("CategoryName");
                ReportCategory category = new ReportCategory(reportCategoryID, categoryName);
                Report report = new Report(reportId, reportDetail, reportDate, user, category, comment, material);
                list.add(report);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return list;
    }
}
