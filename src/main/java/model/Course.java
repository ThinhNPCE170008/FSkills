package model;

import java.sql.Timestamp;
import util.ImageBase64;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
public class Course {
    private int courseID;
    private String courseName;
    private Category category;
    private User user;
    private int approveStatus;
    private Timestamp publicDate;
    private Timestamp courseLastUpdate;
    private int salePrice;
    private int originalPrice;
    private int isSale;
    private byte[] courseImageLocation;
    private String courseSummary;
    private String courseHighlight;
    private int status;
    private  int totalEnrolled;

    public Course() {
    }

    public Course(int courseID, String courseName) {
        this.courseID = courseID;
        this.courseName = courseName;
    }

    public Course(int courseID, String courseName, Category category, User user, int approveStatus, Timestamp publicDate, Timestamp courseLastUpdate, int salePrice, int originalPrice, int isSale, byte[] courseImageLocation, String courseSummary, String courseHighlight, int status, int totalEnrolled) {
        this.courseID = courseID;
        this.courseName = courseName;
        this.category = category;
        this.user = user;
        this.approveStatus = approveStatus;
        this.publicDate = publicDate;
        this.courseLastUpdate = courseLastUpdate;
        this.salePrice = salePrice;
        this.originalPrice = originalPrice;
        this.isSale = isSale;
        this.courseImageLocation = courseImageLocation;
        this.courseSummary = courseSummary;
        this.courseHighlight = courseHighlight;
        this.status = status;
        this.totalEnrolled = totalEnrolled;
    }

    public Course(int courseID, String courseName, Category category, User user, int approveStatus, Timestamp publicDate, Timestamp courseLastUpdate, byte[] courseImageLocation) {
        this.courseID = courseID;
        this.courseName = courseName;
        this.category = category;
        this.user = user;
        this.approveStatus = approveStatus;
        this.publicDate = publicDate;
        this.courseLastUpdate = courseLastUpdate;
        this.courseImageLocation = courseImageLocation;
    }

    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public int getApproveStatus() {
        return approveStatus;
    }

    public void setApproveStatus(int approveStatus) {
        this.approveStatus = approveStatus;
    }

    public Timestamp getPublicDate() {
        return publicDate;
    }

    public void setPublicDate(Timestamp publicDate) {
        this.publicDate = publicDate;
    }

    public Timestamp getCourseLastUpdate() {
        return courseLastUpdate;
    }

    public void setCourseLastUpdate(Timestamp courseLastUpdate) {
        this.courseLastUpdate = courseLastUpdate;
    }

    public int getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(int salePrice) {
        this.salePrice = salePrice;
    }

    public int getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(int originalPrice) {
        this.originalPrice = originalPrice;
    }

    public int getIsSale() {
        return isSale;
    }

    public void setIsSale(int isSale) {
        this.isSale = isSale;
    }

    public byte[] getCourseImageLocation() {
        return courseImageLocation;
    }

    public void setCourseImageLocation(byte[] courseImageLocation) {
        this.courseImageLocation = courseImageLocation;
    }

    public String getCourseSummary() {
        return courseSummary;
    }

    public void setCourseSummary(String courseSummary) {
        this.courseSummary = courseSummary;
    }

    public String getCourseHighlight() {
        return courseHighlight;
    }

    public void setCourseHighlight(String courseHighlight) {
        this.courseHighlight = courseHighlight;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getTotalEnrolled() {
        return totalEnrolled;
    }

    public void setTotalEnrolled(int totalEnrolled) {
        this.totalEnrolled = totalEnrolled;
    }

    @Override
    public String toString() {
        return "Course{" +
                "courseID:" + courseID +
                ", courseName='" + courseName + '\'' +
                ", category=" + category +
                ", user=" + user +
                ", approveStatus=" + approveStatus +
                ", publicDate=" + publicDate +
                ", courseLastUpdate=" + courseLastUpdate +
                ", salePrice=" + salePrice +
                ", originalPrice=" + originalPrice +
                ", isSale=" + isSale +
                ", courseImageLocation='" + courseImageLocation + '\'' +
                ", courseSummary='" + courseSummary + '\'' +
                ", courseHighlight='" + courseHighlight + '\'' +
                ", status=" + status +
                ", totalEnrolled=" + totalEnrolled +
                '}';
    }

    public String getImageDataURI() {
        return ImageBase64.toDataURI(courseImageLocation, "image/jpeg");
    }
}