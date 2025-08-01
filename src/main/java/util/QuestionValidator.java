package util;

import model.Question;
import java.util.List;
import java.util.ArrayList;

/**
 * Utility class for question validation and defensive programming
 * when dynamically adding questions to tests.
 * 
 * @author Generated for defensive question validation
 */
public class QuestionValidator {
    
    // Question type constants
    public static final String QUESTION_TYPE_CHOICE = "CHOICE";
    public static final String QUESTION_TYPE_WRITING = "WRITING";
    public static final String QUESTION_TYPE_MULTIPLE = "MULTIPLE";
    
    /**
     * Validates and assigns sequential names/IDs to questions when dynamically added.
     * Immediately sets or clears required fields based on type and visibility.
     * 
     * @param questions List of questions to validate and process
     * @param testId The test ID to assign to questions
     * @param startingOrder The starting order number for sequential assignment
     * @return List of validated and properly configured questions
     */
    public static List<Question> validateAndConfigureQuestions(List<Question> questions, int testId, int startingOrder) {
        List<Question> validatedQuestions = new ArrayList<>();
        
        if (questions == null || questions.isEmpty()) {
            return validatedQuestions;
        }
        
        int currentOrder = startingOrder;
        
        for (Question question : questions) {
            if (question == null) {
                continue;
            }
            
            // Assign sequential order and test ID
            question.setQuestionOrder(currentOrder++);
            question.setTestID(testId);
            
            // Validate and configure based on question type
            if (validateAndConfigureByType(question)) {
                validatedQuestions.add(question);
            }
        }
        
        return validatedQuestions;
    }
    
    /**
     * Validates a single question when dynamically added.
     * Assigns sequential order and validates required fields based on type.
     * 
     * @param question The question to validate
     * @param testId The test ID to assign
     * @param questionOrder The order number to assign
     * @return true if the question is valid and properly configured
     */
    public static boolean validateAndConfigureSingleQuestion(Question question, int testId, int questionOrder) {
        if (question == null) {
            return false;
        }
        
        // Assign sequential identifiers
        question.setTestID(testId);
        question.setQuestionOrder(questionOrder);
        
        // Validate and configure based on type
        return validateAndConfigureByType(question);
    }
    
    /**
     * Validates and configures a question based on its type.
     * Sets or clears required fields based on question type and visibility requirements.
     * 
     * @param question The question to validate and configure
     * @return true if the question is valid after configuration
     */
    private static boolean validateAndConfigureByType(Question question) {
        if (question == null) {
            return false;
        }
        
        // Ensure question text is not empty
        if (question.getQuestion() == null || question.getQuestion().trim().isEmpty()) {
            return false;
        }
        
        // Normalize question type
        String questionType = question.getQuestionType();
        if (questionType == null || questionType.trim().isEmpty()) {
            questionType = QUESTION_TYPE_CHOICE; // Default type
            question.setQuestionType(questionType);
        }
        
        // Set default point if not specified
        if (question.getPoint() <= 0) {
            question.setPoint(1);
        }
        
        // Configure required fields based on question type
        switch (questionType.toUpperCase()) {
            case QUESTION_TYPE_CHOICE:
                return validateAndConfigureChoiceQuestion(question);
                
            case QUESTION_TYPE_MULTIPLE:
                return validateAndConfigureMultipleChoiceQuestion(question);
                
            case QUESTION_TYPE_WRITING:
                return validateAndConfigureWritingQuestion(question);
                
            default:
                // Unknown type, treat as choice question
                question.setQuestionType(QUESTION_TYPE_CHOICE);
                return validateAndConfigureChoiceQuestion(question);
        }
    }
    
    /**
     * Validates and configures a CHOICE type question.
     * Sets required fields and clears unnecessary ones.
     */
    private static boolean validateAndConfigureChoiceQuestion(Question question) {
        // For choice questions, at least option1 and option2 are required
        if (isEmptyOrNull(question.getOption1()) || isEmptyOrNull(question.getOption2())) {
            return false;
        }
        
        // Ensure options are trimmed
        question.setOption1(question.getOption1().trim());
        question.setOption2(question.getOption2().trim());
        
        // Set option3 and option4 to empty string if null
        question.setOption3(question.getOption3() != null ? question.getOption3().trim() : "");
        question.setOption4(question.getOption4() != null ? question.getOption4().trim() : "");
        
        // Validate right option (should be A, B, C, or D)
        String rightOption = question.getRightOption();
        if (isEmptyOrNull(rightOption)) {
            question.setRightOption("A"); // Default to A
        } else {
            rightOption = rightOption.trim().toUpperCase();
            if (!rightOption.matches("[ABCD]")) {
                question.setRightOption("A"); // Default to A if invalid
            } else {
                question.setRightOption(rightOption);
            }
        }
        
        return true;
    }
    
    /**
     * Validates and configures a MULTIPLE type question.
     * Sets required fields and clears unnecessary ones.
     */
    private static boolean validateAndConfigureMultipleChoiceQuestion(Question question) {
        // For multiple choice questions, at least option1 and option2 are required
        if (isEmptyOrNull(question.getOption1()) || isEmptyOrNull(question.getOption2())) {
            return false;
        }
        
        // Ensure options are trimmed
        question.setOption1(question.getOption1().trim());
        question.setOption2(question.getOption2().trim());
        question.setOption3(question.getOption3() != null ? question.getOption3().trim() : "");
        question.setOption4(question.getOption4() != null ? question.getOption4().trim() : "");
        
        // For multiple choice, rightOption should be comma-separated indices or letters
        String rightOption = question.getRightOption();
        if (isEmptyOrNull(rightOption)) {
            question.setRightOption("A"); // Default to A
        } else {
            // Validate format (comma-separated letters or numbers)
            rightOption = rightOption.trim();
            if (!rightOption.matches("^[ABCD0-9,\\s]+$")) {
                question.setRightOption("A"); // Default if invalid format
            } else {
                question.setRightOption(rightOption);
            }
        }
        
        return true;
    }
    
    /**
     * Validates and configures a WRITING type question.
     * Sets required fields and clears unnecessary ones.
     */
    private static boolean validateAndConfigureWritingQuestion(Question question) {
        // For writing questions, rightOption contains the expected answer
        if (isEmptyOrNull(question.getRightOption())) {
            return false;
        }
        
        // Clear options for writing questions as they're not needed
        question.setOption1("");
        question.setOption2("");
        question.setOption3("");
        question.setOption4("");
        
        // Trim the right answer
        question.setRightOption(question.getRightOption().trim());
        
        return true;
    }
    
    /**
     * Helper method to check if a string is null or empty
     */
    private static boolean isEmptyOrNull(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    /**
     * Validates if a question type is supported
     * 
     * @param questionType The question type to validate
     * @return true if the question type is supported
     */
    public static boolean isValidQuestionType(String questionType) {
        if (questionType == null) {
            return false;
        }
        
        String type = questionType.trim().toUpperCase();
        return QUESTION_TYPE_CHOICE.equals(type) || 
               QUESTION_TYPE_WRITING.equals(type) || 
               QUESTION_TYPE_MULTIPLE.equals(type);
    }
    
    /**
     * Gets the next sequential question order for a test
     * This method should be used with QuestionDAO.getNextQuestionOrder() for consistency
     * 
     * @param existingQuestions List of existing questions
     * @return The next sequential order number
     */
    public static int getNextSequentialOrder(List<Question> existingQuestions) {
        if (existingQuestions == null || existingQuestions.isEmpty()) {
            return 1;
        }
        
        int maxOrder = 0;
        for (Question question : existingQuestions) {
            if (question.getQuestionOrder() > maxOrder) {
                maxOrder = question.getQuestionOrder();
            }
        }
        
        return maxOrder + 1;
    }
}

