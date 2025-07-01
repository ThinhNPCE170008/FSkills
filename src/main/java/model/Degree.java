package model;

import java.sql.Timestamp;
import util.ImageBase64;

/**
 *
 * @author huakh
 */
public class Degree {
    private int degreeId;
    private int status;
    private Timestamp submitDate;
    private Timestamp ApprovalDate;
    private byte[] image;
    private String link;
    private User userId;

    public Degree() {
    }

    public Degree(int degreeId, int status, Timestamp submitDate, Timestamp ApprovalDate, byte[] image, String link, User userId) {
        this.degreeId = degreeId;
        this.status = status;
        this.submitDate = submitDate;
        this.ApprovalDate = ApprovalDate;
        this.image = image;
        this.link = link;
        this.userId = userId;
    }

    public int getDegreeId() {
        return degreeId;
    }

    public void setDegreeId(int degreeId) {
        this.degreeId = degreeId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Timestamp getSubmitDate() {
        return submitDate;
    }

    public void setSubmitDate(Timestamp submitDate) {
        this.submitDate = submitDate;
    }

    public Timestamp getApprovalDate() {
        return ApprovalDate;
    }

    public void setApprovalDate(Timestamp ApprovalDate) {
        this.ApprovalDate = ApprovalDate;
    }

    public byte[] getImage() {
        return image;
    }

    public void setImage(byte[] image) {
        this.image = image;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public User getUserId() {
        return userId;
    }

    public void setUserId(User userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "Degree{" + "degreeId=" + degreeId + ", status=" + status + ", submitDate=" + submitDate + ", ApprovalDate=" + ApprovalDate + ", image=" + image + ", link=" + link + ", userId=" + userId + '}';
    }
    
    public String getImageDataURI() {
        return ImageBase64.toDataURI(image, "image/jpeg");
    }
}
