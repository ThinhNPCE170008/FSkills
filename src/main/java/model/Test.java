package model;

import java.sql.Timestamp;

/**
 * Test model class representing the Tests table
 * @author Generated for InstructorTestServlet functionality
 */
public class Test {
    private int testID;
    private int moduleID;
    private Timestamp testLastUpdate;
    private int testOrder;
    private int passPercentage;
    private boolean isRandomize;
    private boolean showAnswer;
    
    // For relationships
    private Module module;
    
    // For displaying additional information
    private int questionCount;

    public Test() {
    }

    public Test(int moduleID, int testOrder, int passPercentage, boolean isRandomize, boolean showAnswer) {
        this.moduleID = moduleID;
        this.testOrder = testOrder;
        this.passPercentage = passPercentage;
        this.isRandomize = isRandomize;
        this.showAnswer = showAnswer;
    }

    public Test(int testID, int moduleID, Timestamp testLastUpdate, int testOrder, int passPercentage, boolean isRandomize, boolean showAnswer) {
        this.testID = testID;
        this.moduleID = moduleID;
        this.testLastUpdate = testLastUpdate;
        this.testOrder = testOrder;
        this.passPercentage = passPercentage;
        this.isRandomize = isRandomize;
        this.showAnswer = showAnswer;
    }

    // Getters and Setters
    public int getTestID() {
        return testID;
    }

    public void setTestID(int testID) {
        this.testID = testID;
    }

    public int getModuleID() {
        return moduleID;
    }

    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
    }

    public Timestamp getTestLastUpdate() {
        return testLastUpdate;
    }

    public void setTestLastUpdate(Timestamp testLastUpdate) {
        this.testLastUpdate = testLastUpdate;
    }

    public int getTestOrder() {
        return testOrder;
    }

    public void setTestOrder(int testOrder) {
        this.testOrder = testOrder;
    }

    public int getPassPercentage() {
        return passPercentage;
    }

    public void setPassPercentage(int passPercentage) {
        this.passPercentage = passPercentage;
    }

    public boolean isRandomize() {
        return isRandomize;
    }

    public void setRandomize(boolean randomize) {
        isRandomize = randomize;
    }

    public boolean isShowAnswer() {
        return showAnswer;
    }

    public void setShowAnswer(boolean showAnswer) {
        this.showAnswer = showAnswer;
    }

    public Module getModule() {
        return module;
    }

    public void setModule(Module module) {
        this.module = module;
    }

    public int getQuestionCount() {
        return questionCount;
    }

    public void setQuestionCount(int questionCount) {
        this.questionCount = questionCount;
    }

    @Override
    public String toString() {
        return "Test{" +
                "testID=" + testID +
                ", moduleID=" + moduleID +
                ", testLastUpdate=" + testLastUpdate +
                ", testOrder=" + testOrder +
                ", passPercentage=" + passPercentage +
                ", isRandomize=" + isRandomize +
                ", showAnswer=" + showAnswer +
                '}';
    }
} 