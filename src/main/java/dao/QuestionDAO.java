package dao;

import model.Question;
import model.Test;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * QuestionDAO class for CRUD operations on Questions table
 * @author Generated for InstructorTestServlet functionality
 */
public class QuestionDAO extends DBContext {

    public QuestionDAO() {
        super();
    }

    /**
     * Get all questions by test ID
     */
    public List<Question> getQuestionsByTestID(int testID) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT q.*, t.ModuleID " +
                    "FROM Questions q " +
                    "JOIN Tests t ON q.TestID = t.TestID " +
                    "WHERE q.TestID = ? " +
                    "ORDER BY q.QuestionOrder";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Test test = new Test();
                test.setTestID(testID);
                test.setModuleID(rs.getInt("ModuleID"));

                Question question = new Question();
                question.setQuestionID(rs.getInt("QuestionID"));
                question.setTestID(testID);
                question.setPoint(rs.getInt("Point"));
                question.setQuestionOrder(rs.getInt("QuestionOrder"));
                question.setQuestionType(rs.getString("QuestionType"));
                question.setQuestion(rs.getString("Question"));
                question.setOption1(rs.getString("Option1"));
                question.setOption2(rs.getString("Option2"));
                question.setOption3(rs.getString("Option3"));
                question.setOption4(rs.getString("Option4"));
                question.setRightOption(rs.getString("RightOption"));
                question.setTest(test);

                list.add(question);
            }
        } catch (SQLException e) {
            System.out.println("Error in getQuestionsByTestID: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get question by ID
     */
    public Question getQuestionByID(int questionID) {
        String sql = "SELECT q.*, t.ModuleID " +
                    "FROM Questions q " +
                    "JOIN Tests t ON q.TestID = t.TestID " +
                    "WHERE q.QuestionID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, questionID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Test test = new Test();
                test.setTestID(rs.getInt("TestID"));
                test.setModuleID(rs.getInt("ModuleID"));

                Question question = new Question();
                question.setQuestionID(questionID);
                question.setTestID(rs.getInt("TestID"));
                question.setPoint(rs.getInt("Point"));
                question.setQuestionOrder(rs.getInt("QuestionOrder"));
                question.setQuestionType(rs.getString("QuestionType"));
                question.setQuestion(rs.getString("Question"));
                question.setOption1(rs.getString("Option1"));
                question.setOption2(rs.getString("Option2"));
                question.setOption3(rs.getString("Option3"));
                question.setOption4(rs.getString("Option4"));
                question.setRightOption(rs.getString("RightOption"));
                question.setTest(test);

                return question;
            }
        } catch (SQLException e) {
            System.out.println("Error in getQuestionByID: " + e.getMessage());
        }
        return null;
    }

    /**
     * Insert new question
     */
    public int insertQuestion(Question question) {
        String sql = "INSERT INTO Questions (TestID, Point, QuestionOrder, QuestionType, Question, " +
                    "Option1, Option2, Option3, Option4, RightOption) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, question.getTestID());
            ps.setInt(2, question.getPoint());
            ps.setInt(3, question.getQuestionOrder());
            ps.setString(4, question.getQuestionType());
            ps.setString(5, question.getQuestion());
            ps.setString(6, question.getOption1());
            ps.setString(7, question.getOption2());
            ps.setString(8, question.getOption3());
            ps.setString(9, question.getOption4());
            ps.setString(10, question.getRightOption());

            int insert = ps.executeUpdate();
            if (insert > 0) {
                // Get the generated question ID
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int questionID = generatedKeys.getInt(1);
                    
                    // Update test last update
                    updateTestLastUpdate(question.getTestID());
                    
                    return questionID;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in insertQuestion: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Update question
     */
    public int updateQuestion(Question question) {
        String sql = "UPDATE Questions SET " +
                    "Point = ?, QuestionOrder = ?, QuestionType = ?, Question = ?, " +
                    "Option1 = ?, Option2 = ?, Option3 = ?, Option4 = ?, RightOption = ? " +
                    "WHERE QuestionID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, question.getPoint());
            ps.setInt(2, question.getQuestionOrder());
            ps.setString(3, question.getQuestionType());
            ps.setString(4, question.getQuestion());
            ps.setString(5, question.getOption1());
            ps.setString(6, question.getOption2());
            ps.setString(7, question.getOption3());
            ps.setString(8, question.getOption4());
            ps.setString(9, question.getRightOption());
            ps.setInt(10, question.getQuestionID());

            int update = ps.executeUpdate();
            if (update > 0) {
                // Update test last update
                updateTestLastUpdate(question.getTestID());
                return 1;
            }
        } catch (SQLException e) {
            System.out.println("Error in updateQuestion: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Delete question
     */
    public int deleteQuestion(int questionID) {
        String sql = "DELETE FROM Questions WHERE QuestionID = ?";

        try {
            // Get test ID before deletion for updating test last update
            Question question = getQuestionByID(questionID);
            if (question == null) {
                return 0;
            }

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, questionID);

            int delete = ps.executeUpdate();
            if (delete > 0) {
                // Update test last update
                updateTestLastUpdate(question.getTestID());
                return 1;
            }
        } catch (SQLException e) {
            System.out.println("Error in deleteQuestion: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Delete all questions for a test
     */
    public int deleteQuestionsByTestID(int testID) {
        String sql = "DELETE FROM Questions WHERE TestID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);

            int delete = ps.executeUpdate();
            // Update test last update
            updateTestLastUpdate(testID);
            return delete;
        } catch (SQLException e) {
            System.out.println("Error in deleteQuestionsByTestID: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Get next question order for a test
     */
    public int getNextQuestionOrder(int testID) {
        String sql = "SELECT ISNULL(MAX(QuestionOrder), 0) + 1 as NextOrder FROM Questions WHERE TestID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("NextOrder");
            }
        } catch (SQLException e) {
            System.out.println("Error in getNextQuestionOrder: " + e.getMessage());
        }
        return 1;
    }

    /**
     * Get total points for a test
     */
    public int getTotalPointsForTest(int testID) {
        String sql = "SELECT ISNULL(SUM(Point), 0) as TotalPoints FROM Questions WHERE TestID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("TotalPoints");
            }
        } catch (SQLException e) {
            System.out.println("Error in getTotalPointsForTest: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Get question count for a test
     */
    public int getQuestionCountForTest(int testID) {
        String sql = "SELECT COUNT(*) as QuestionCount FROM Questions WHERE TestID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("QuestionCount");
            }
        } catch (SQLException e) {
            System.out.println("Error in getQuestionCountForTest: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Batch insert questions
     */
    public int insertQuestions(List<Question> questions) {
        String sql = "INSERT INTO Questions (TestID, Point, QuestionOrder, QuestionType, Question, " +
                    "Option1, Option2, Option3, Option4, RightOption) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            conn.setAutoCommit(false);
            PreparedStatement ps = conn.prepareStatement(sql);

            int testID = -1;
            for (Question question : questions) {
                testID = question.getTestID();
                ps.setInt(1, question.getTestID());
                ps.setInt(2, question.getPoint());
                ps.setInt(3, question.getQuestionOrder());
                ps.setString(4, question.getQuestionType());
                ps.setString(5, question.getQuestion());
                ps.setString(6, question.getOption1());
                ps.setString(7, question.getOption2());
                ps.setString(8, question.getOption3());
                ps.setString(9, question.getOption4());
                ps.setString(10, question.getRightOption());
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            conn.commit();
            conn.setAutoCommit(true);

            // Update test last update
            if (testID != -1) {
                updateTestLastUpdate(testID);
            }

            return results.length;
        } catch (SQLException e) {
            try {
                conn.rollback();
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                System.out.println("Error in rollback: " + ex.getMessage());
            }
            System.out.println("Error in insertQuestions: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Helper method to update test's last update timestamp
     */
    private void updateTestLastUpdate(int testID) {
        String sql = "UPDATE Tests SET TestLastUpdate = SYSUTCDATETIME() WHERE TestID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error in updateTestLastUpdate: " + e.getMessage());
        }
    }

    /**
     * Get questions for test in randomized order (for learners taking test)
     */
    public List<Question> getQuestionsForTest(int testID, boolean randomize) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT q.*, t.ModuleID " +
                    "FROM Questions q " +
                    "JOIN Tests t ON q.TestID = t.TestID " +
                    "WHERE q.TestID = ? " +
                    "ORDER BY " + (randomize ? "NEWID()" : "q.QuestionOrder");

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Test test = new Test();
                test.setTestID(testID);
                test.setModuleID(rs.getInt("ModuleID"));

                Question question = new Question();
                question.setQuestionID(rs.getInt("QuestionID"));
                question.setTestID(testID);
                question.setPoint(rs.getInt("Point"));
                question.setQuestionOrder(rs.getInt("QuestionOrder"));
                question.setQuestionType(rs.getString("QuestionType"));
                question.setQuestion(rs.getString("Question"));
                question.setOption1(rs.getString("Option1"));
                question.setOption2(rs.getString("Option2"));
                question.setOption3(rs.getString("Option3"));
                question.setOption4(rs.getString("Option4"));
                question.setRightOption(rs.getString("RightOption"));
                question.setTest(test);

                list.add(question);
            }
        } catch (SQLException e) {
            System.out.println("Error in getQuestionsForTest: " + e.getMessage());
        }
        return list;
    }
} 