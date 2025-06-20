package model;

import java.sql.Timestamp;
import java.util.regex.Pattern; // Cần thiết cho validateEmail và validatePhoneNumber

public class Profile {
    private int userId;
    private String displayName;
    private String email;
    private String phoneNumber;
    private String info;
    private Timestamp dateOfBirth;
    private String avatar;
    private boolean gender; // Giữ boolean cho gender như trong Profile cũ

    public Profile() {
    }

    public Profile(int userId, String displayName, String email, String phoneNumber,
                   String info, Timestamp dateOfBirth, String avatar, boolean gender) {
        this.userId = userId;
        this.displayName = displayName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.info = info;
        this.dateOfBirth = dateOfBirth;
        this.avatar = avatar;
        this.gender = gender;
    }

    // Getters và Setters

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public Timestamp getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Timestamp dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public boolean getGender() { // Getter cho boolean thường là getPropertyName() hoặc isPropertyName()
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    // Các phương thức validation (giữ nguyên từ Profile cũ vì chúng hữu ích)
    public boolean validateEmail() {
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        return email != null && Pattern.matches(emailRegex, email);
    }

    public boolean validatePhoneNumber() {
        String phoneRegex = "^[0-9]{10}$";
        return phoneNumber != null && Pattern.matches(phoneRegex, phoneNumber);
    }

    public boolean validateDisplayName() {
        return displayName != null && displayName.length() >= 2;
    }

    @Override
    public String toString() {
        return "Profile{" +
                "userId=" + userId +
                ", displayName='" + displayName + '\'' +
                ", email='" + email + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", info='" + info + '\'' +
                ", dateOfBirth=" + dateOfBirth +
                ", avatar='" + avatar + '\'' +
                ", gender=" + gender +
                '}';
    }
}