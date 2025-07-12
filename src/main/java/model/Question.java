package model;

/**
 * Question model class representing the Questions table
 * @author Generated for InstructorTestServlet functionality
 */
public class Question {
    private int questionID;
    private int testID;
    private int point;
    private int questionOrder;
    private String questionType;
    private String question;
    private String option1;
    private String option2;
    private String option3;
    private String option4;
    private String rightOption;
    
    // For relationships
    private Test test;

    public Question() {
    }

    public Question(int testID, int point, int questionOrder, String questionType, String question, 
                   String option1, String option2, String option3, String option4, String rightOption) {
        this.testID = testID;
        this.point = point;
        this.questionOrder = questionOrder;
        this.questionType = questionType;
        this.question = question;
        this.option1 = option1;
        this.option2 = option2;
        this.option3 = option3;
        this.option4 = option4;
        this.rightOption = rightOption;
    }

    public Question(int questionID, int testID, int point, int questionOrder, String questionType, 
                   String question, String option1, String option2, String option3, String option4, String rightOption) {
        this.questionID = questionID;
        this.testID = testID;
        this.point = point;
        this.questionOrder = questionOrder;
        this.questionType = questionType;
        this.question = question;
        this.option1 = option1;
        this.option2 = option2;
        this.option3 = option3;
        this.option4 = option4;
        this.rightOption = rightOption;
    }

    // Getters and Setters
    public int getQuestionID() {
        return questionID;
    }

    public void setQuestionID(int questionID) {
        this.questionID = questionID;
    }

    public int getTestID() {
        return testID;
    }

    public void setTestID(int testID) {
        this.testID = testID;
    }

    public int getPoint() {
        return point;
    }

    public void setPoint(int point) {
        this.point = point;
    }

    public int getQuestionOrder() {
        return questionOrder;
    }

    public void setQuestionOrder(int questionOrder) {
        this.questionOrder = questionOrder;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getOption1() {
        return option1;
    }

    public void setOption1(String option1) {
        this.option1 = option1;
    }

    public String getOption2() {
        return option2;
    }

    public void setOption2(String option2) {
        this.option2 = option2;
    }

    public String getOption3() {
        return option3;
    }

    public void setOption3(String option3) {
        this.option3 = option3;
    }

    public String getOption4() {
        return option4;
    }

    public void setOption4(String option4) {
        this.option4 = option4;
    }

    public String getRightOption() {
        return rightOption;
    }

    public void setRightOption(String rightOption) {
        this.rightOption = rightOption;
    }

    public Test getTest() {
        return test;
    }

    public void setTest(Test test) {
        this.test = test;
    }

    @Override
    public String toString() {
        return "Question{" +
                "questionID=" + questionID +
                ", testID=" + testID +
                ", point=" + point +
                ", questionOrder=" + questionOrder +
                ", questionType='" + questionType + '\'' +
                ", question='" + question + '\'' +
                ", option1='" + option1 + '\'' +
                ", option2='" + option2 + '\'' +
                ", option3='" + option3 + '\'' +
                ", option4='" + option4 + '\'' +
                ", rightOption='" + rightOption + '\'' +
                '}';
    }
} 