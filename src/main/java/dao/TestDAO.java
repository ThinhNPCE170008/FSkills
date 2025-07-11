package dao;

import model.Course;
import model.Module;
import model.Test;
import util.DBContext;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * TestDAO class for CRUD operations on Tests table
 * @author Generated for InstructorTestServlet functionality
 */
public class TestDAO extends DBContext {

    public TestDAO() {
        super();
    }

    /**
     * Get all tests by module ID
     */
    public List<Test> getTestsByModuleID(int moduleID) {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT t.*, m.ModuleName,c.CourseName, c.CourseID  " +
                    "FROM Tests t " +
                    "JOIN Modules m ON t.ModuleID = m.ModuleID " +
                    "JOIN Courses c ON m.CourseID = c.CourseID " +
                    "WHERE t.ModuleID = ? " +
                    "ORDER BY t.TestOrder";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, moduleID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Module module = new Module();
                module.setModuleID(rs.getInt("ModuleID"));
                module.setModuleName(rs.getString("ModuleName"));
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setCourseName(rs.getString("CourseName"));
                module.setCourse(course);
                Test test = new Test();
                test.setTestID(rs.getInt("TestID"));
                test.setModuleID(moduleID);
                test.setTestLastUpdate(rs.getTimestamp("TestLastUpdate"));
                test.setTestOrder(rs.getInt("TestOrder"));
                test.setPassPercentage(rs.getInt("PassPercentage"));
                test.setRandomize(rs.getBoolean("IsRandomize"));
                test.setShowAnswer(rs.getBoolean("ShowAnswer"));
                test.setModule(module);

                list.add(test);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTestsByModuleID: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get test by ID
     */
    public Test getTestByID(int testID) {
        String sql = "SELECT t.*, m.ModuleName, m.CourseID, c.CourseName " +
                    "FROM Tests t " +
                    "JOIN Modules m ON t.ModuleID = m.ModuleID " +
                    "JOIN Courses c ON m.CourseID = c.CourseID " +
                    "WHERE t.TestID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Module module = new Module();
                module.setModuleID(rs.getInt("ModuleID"));
                module.setModuleName(rs.getString("ModuleName"));
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setCourseName(rs.getString("CourseName"));
                module.setCourse(course);
                Test test = new Test();
                test.setTestID(testID);
                test.setModuleID(rs.getInt("ModuleID"));
                test.setTestLastUpdate(rs.getTimestamp("TestLastUpdate"));
                test.setTestOrder(rs.getInt("TestOrder"));
                test.setPassPercentage(rs.getInt("PassPercentage"));
                test.setRandomize(rs.getBoolean("IsRandomize"));
                test.setShowAnswer(rs.getBoolean("ShowAnswer"));
                test.setModule(module);

                return test;
            }
        } catch (SQLException e) {
            System.out.println("Error in getTestByID: " + e.getMessage());
        }
        return null;
    }

    /**
     * Insert new test
     */
    public int insertTest(Test test) {
        String sql = "INSERT INTO Tests (ModuleID, TestLastUpdate, TestOrder, PassPercentage, IsRandomize, ShowAnswer) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, test.getModuleID());
            ps.setTimestamp(2, Timestamp.from(Instant.now()));
            ps.setInt(3, test.getTestOrder());
            ps.setInt(4, test.getPassPercentage());
            ps.setBoolean(5, test.isRandomize());
            ps.setBoolean(6, test.isShowAnswer());

            int insert = ps.executeUpdate();
            if (insert > 0) {
                // Get the generated test ID
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int testID = generatedKeys.getInt(1);
                    
                    // Update module last update
                    updateModuleLastUpdate(test.getModuleID());
                    
                    return testID;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in insertTest: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Update test
     */
    public int updateTest(Test test) {
        String sql = "UPDATE Tests SET " +
                    "TestOrder = ?, PassPercentage = ?, IsRandomize = ?, ShowAnswer = ?, TestLastUpdate = ? " +
                    "WHERE TestID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, test.getTestOrder());
            ps.setInt(2, test.getPassPercentage());
            ps.setBoolean(3, test.isRandomize());
            ps.setBoolean(4, test.isShowAnswer());
            ps.setTimestamp(5, Timestamp.from(Instant.now()));
            ps.setInt(6, test.getTestID());

            int update = ps.executeUpdate();
            if (update > 0) {
                // Update module last update
                updateModuleLastUpdate(test.getModuleID());
                return 1;
            }
        } catch (SQLException e) {
            System.out.println("Error in updateTest: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Delete test
     */
    public int deleteTest(int testID) {
        String sql = "DELETE FROM Tests WHERE TestID = ?";

        try {
            // Get module ID before deletion for updating module last update
            Test test = getTestByID(testID);
            if (test == null) {
                return 0;
            }

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);

            int delete = ps.executeUpdate();
            if (delete > 0) {
                // Update module last update
                updateModuleLastUpdate(test.getModuleID());
                return 1;
            }
        } catch (SQLException e) {
            System.out.println("Error in deleteTest: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Get next test order for a module
     */
    public int getNextTestOrder(int moduleID) {
        String sql = "SELECT ISNULL(MAX(TestOrder), 0) + 1 as NextOrder FROM Tests WHERE ModuleID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, moduleID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("NextOrder");
            }
        } catch (SQLException e) {
            System.out.println("Error in getNextTestOrder: " + e.getMessage());
        }
        return 1;
    }

    /**
     * Get tests by instructor's courses
     */
    public List<Test> getTestsByInstructorID(int instructorID) {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT t.*, m.ModuleName, c.CourseName, c.CourseID " +
                    "FROM Tests t " +
                    "JOIN Modules m ON t.ModuleID = m.ModuleID " +
                    "JOIN Courses c ON m.CourseID = c.CourseID " +
                    "WHERE c.UserID = ? " +
                    "ORDER BY c.CourseName, m.ModuleName, t.TestOrder";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, instructorID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Module module = new Module();
                module.setModuleID(rs.getInt("ModuleID"));
                module.setModuleName(rs.getString("ModuleName"));
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setCourseName(rs.getString("CourseName"));
                module.setCourse(course);
                Test test = new Test();
                test.setTestID(rs.getInt("TestID"));
                test.setModuleID(rs.getInt("ModuleID"));
                test.setTestLastUpdate(rs.getTimestamp("TestLastUpdate"));
                test.setTestOrder(rs.getInt("TestOrder"));
                test.setPassPercentage(rs.getInt("PassPercentage"));
                test.setRandomize(rs.getBoolean("IsRandomize"));
                test.setShowAnswer(rs.getBoolean("ShowAnswer"));
                test.setModule(module);

                list.add(test);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTestsByInstructorID: " + e.getMessage());
        }
        return list;
    }

    /**
     * Check if test belongs to instructor
     */
    public boolean isTestOwnedByInstructor(int testID, int instructorID) {
        String sql = "SELECT COUNT(*) as count " +
                    "FROM Tests t " +
                    "JOIN Modules m ON t.ModuleID = m.ModuleID " +
                    "JOIN Courses c ON m.CourseID = c.CourseID " +
                    "WHERE t.TestID = ? AND c.UserID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ps.setInt(2, instructorID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error in isTestOwnedByInstructor: " + e.getMessage());
        }
        return false;
    }

    /**
     * Helper method to update module's last update timestamp
     */
    private void updateModuleLastUpdate(int moduleID) {
        String sql = "UPDATE Modules SET ModuleLastUpdate = SYSUTCDATETIME() WHERE ModuleID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, moduleID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error in updateModuleLastUpdate: " + e.getMessage());
        }
    }

    /**
     * Get all tests available to a learner from enrolled courses
     */
    public List<Test> getTestsForLearner(int learnerID) {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT t.*, m.ModuleName, c.CourseName, c.CourseID, " +
                    "(SELECT COUNT(*) FROM Questions q WHERE q.TestID = t.TestID) as QuestionCount " +
                    "FROM Tests t " +
                    "JOIN Modules m ON t.ModuleID = m.ModuleID " +
                    "JOIN Courses c ON m.CourseID = c.CourseID " +
                    "JOIN Enroll e ON c.CourseID = e.CourseID " +
                    "WHERE e.UserID = ? " +
                    "ORDER BY c.CourseName, m.ModuleName, t.TestOrder";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, learnerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Test test = createTestFromResultSet(rs);
                test.setQuestionCount(rs.getInt("QuestionCount"));
                list.add(test);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTestsForLearner: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get tests for learner with filtering by course and module
     */
    public List<Test> getFilteredTestsForLearner(int learnerID, Integer courseID, Integer moduleID) {
        List<Test> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT t.*, m.ModuleName, c.CourseName, c.CourseID, " +
            "(SELECT COUNT(*) FROM Questions q WHERE q.TestID = t.TestID) as QuestionCount " +
            "FROM Tests t " +
            "JOIN Modules m ON t.ModuleID = m.ModuleID " +
            "JOIN Courses c ON m.CourseID = c.CourseID " +
            "JOIN Enroll e ON c.CourseID = e.CourseID " +
            "WHERE e.UserID = ? "
        );

        if (courseID != null) {
            sql.append("AND c.CourseID = ? ");
        }
        if (moduleID != null) {
            sql.append("AND m.ModuleID = ? ");
        }

        sql.append("ORDER BY c.CourseName, m.ModuleName, t.TestOrder");

        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            ps.setInt(paramIndex++, learnerID);
            if (courseID != null) {
                ps.setInt(paramIndex++, courseID);
            }
            if (moduleID != null) {
                ps.setInt(paramIndex++, moduleID);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Test test = createTestFromResultSet(rs);
                test.setQuestionCount(rs.getInt("QuestionCount"));
                list.add(test);
            }
        } catch (SQLException e) {
            System.out.println("Error in getFilteredTestsForLearner: " + e.getMessage());
        }
        return list;
    }

    /**
     * Check if learner is enrolled in the course that contains this test
     */
    public boolean isLearnerEnrolledInTest(int testID, int learnerID) {
        String sql = "SELECT COUNT(*) as count " +
                    "FROM Tests t " +
                    "JOIN Modules m ON t.ModuleID = m.ModuleID " +
                    "JOIN Courses c ON m.CourseID = c.CourseID " +
                    "JOIN Enroll e ON c.CourseID = e.CourseID " +
                    "WHERE t.TestID = ? AND e.UserID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ps.setInt(2, learnerID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error in isLearnerEnrolledInTest: " + e.getMessage());
        }
        return false;
    }

    /**
     * Helper method to create Test object from ResultSet
     */
    private Test createTestFromResultSet(ResultSet rs) throws SQLException {
        Module module = new Module();
        module.setModuleID(rs.getInt("ModuleID"));
        module.setModuleName(rs.getString("ModuleName"));
        
        Course course = new Course();
        course.setCourseID(rs.getInt("CourseID"));
        course.setCourseName(rs.getString("CourseName"));
        module.setCourse(course);

        Test test = new Test();
        test.setTestID(rs.getInt("TestID"));
        test.setModuleID(rs.getInt("ModuleID"));
        test.setTestLastUpdate(rs.getTimestamp("TestLastUpdate"));
        test.setTestOrder(rs.getInt("TestOrder"));
        test.setPassPercentage(rs.getInt("PassPercentage"));
        test.setRandomize(rs.getBoolean("IsRandomize"));
        test.setShowAnswer(rs.getBoolean("ShowAnswer"));
        test.setModule(module);

        return test;
    }
} 