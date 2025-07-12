package dao;

import model.UserAnswer;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserAnswerDAO class for CRUD operations on UserAnswer table
 * @author Generated for learner test functionality
 */
public class UserAnswerDAO extends DBContext {

    public UserAnswerDAO() {
        super();
    }

    /**
     * Insert user answer
     */
    public boolean insertUserAnswer(UserAnswer userAnswer) {
        String sql = "INSERT INTO UserAnswer (TestResultID, QuestionID, UserID, Answer, IsCorrected) " +
                    "VALUES (?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userAnswer.getTestResultID());
            ps.setInt(2, userAnswer.getQuestionID());
            ps.setInt(3, userAnswer.getUserID());
            ps.setString(4, userAnswer.getAnswer());
            ps.setBoolean(5, userAnswer.isCorrected());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in insertUserAnswer: " + e.getMessage());
        }
        return false;
    }

    /**
     * Insert multiple user answers in batch
     */
    public boolean insertUserAnswers(List<UserAnswer> userAnswers) {
        String sql = "INSERT INTO UserAnswer (TestResultID, QuestionID, UserID, Answer, IsCorrected) " +
                    "VALUES (?, ?, ?, ?, ?)";

        try {
            conn.setAutoCommit(false);
            PreparedStatement ps = conn.prepareStatement(sql);

            for (UserAnswer userAnswer : userAnswers) {
                ps.setInt(1, userAnswer.getTestResultID());
                ps.setInt(2, userAnswer.getQuestionID());
                ps.setInt(3, userAnswer.getUserID());
                ps.setString(4, userAnswer.getAnswer());
                ps.setBoolean(5, userAnswer.isCorrected());
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            conn.commit();
            conn.setAutoCommit(true);

            // Check if all inserts were successful
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;
        } catch (SQLException e) {
            System.out.println("Error in insertUserAnswers: " + e.getMessage());
            try {
                conn.rollback();
                conn.setAutoCommit(true);
            } catch (SQLException rollbackEx) {
                System.out.println("Error in rollback: " + rollbackEx.getMessage());
            }
        }
        return false;
    }

    /**
     * Get user answers for a test result
     */
    public List<UserAnswer> getUserAnswersByTestResult(int testResultID) {
        List<UserAnswer> list = new ArrayList<>();
        String sql = "SELECT * FROM UserAnswer WHERE TestResultID = ? ORDER BY QuestionID";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testResultID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(createUserAnswerFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error in getUserAnswersByTestResult: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get user answers with question details for a test result
     */
    public List<UserAnswer> getUserAnswersWithQuestions(int testResultID) {
        List<UserAnswer> list = new ArrayList<>();
        String sql = "SELECT ua.*, q.Question, q.Option1, q.Option2, q.Option3, q.Option4, " +
                    "q.RightOption, q.QuestionType, q.Point " +
                    "FROM UserAnswer ua " +
                    "JOIN Questions q ON ua.QuestionID = q.QuestionID " +
                    "WHERE ua.TestResultID = ? " +
                    "ORDER BY q.QuestionOrder";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testResultID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserAnswer userAnswer = createUserAnswerFromResultSet(rs);
                
                // Create and set question details
                model.Question question = new model.Question();
                question.setQuestionID(rs.getInt("QuestionID"));
                question.setQuestion(rs.getString("Question"));
                question.setOption1(rs.getString("Option1"));
                question.setOption2(rs.getString("Option2"));
                question.setOption3(rs.getString("Option3"));
                question.setOption4(rs.getString("Option4"));
                question.setRightOption(rs.getString("RightOption"));
                question.setQuestionType(rs.getString("QuestionType"));
                question.setPoint(rs.getInt("Point"));
                
                userAnswer.setQuestion(question);
                list.add(userAnswer);
            }
        } catch (SQLException e) {
            System.out.println("Error in getUserAnswersWithQuestions: " + e.getMessage());
        }
        return list;
    }

    /**
     * Delete user answers for a test result
     */
    public boolean deleteUserAnswers(int testResultID) {
        String sql = "DELETE FROM UserAnswer WHERE TestResultID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testResultID);
            return ps.executeUpdate() >= 0; // >= 0 because there might be 0 answers to delete
        } catch (SQLException e) {
            System.out.println("Error in deleteUserAnswers: " + e.getMessage());
        }
        return false;
    }

    /**
     * Helper method to create UserAnswer object from ResultSet
     */
    private UserAnswer createUserAnswerFromResultSet(ResultSet rs) throws SQLException {
        UserAnswer userAnswer = new UserAnswer();
        userAnswer.setTestResultID(rs.getInt("TestResultID"));
        userAnswer.setQuestionID(rs.getInt("QuestionID"));
        userAnswer.setUserID(rs.getInt("UserID"));
        userAnswer.setAnswer(rs.getString("Answer"));
        userAnswer.setCorrected(rs.getBoolean("IsCorrected"));
        return userAnswer;
    }
} 