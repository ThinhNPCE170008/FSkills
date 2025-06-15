package model;

import java.sql.Timestamp;
import java.util.regex.Pattern;

public class Profile {
    private int userID; // Sửa tên viết hoa
    private String displayName; // Sửa từ chữ cái viết hoa ở đầu
    private String email;
    private String phoneNumber; // Sửa tên viết hoa
    private String info; // Sửa tên viết hoa
    private Timestamp dateOfBirth;
    private String avatar;
    private boolean gender;

    public Profile() {}

    public Profile(int userID, String displayName, String email, String phoneNumber,
                   String info, Timestamp dateOfBirth, String avatar, boolean gender) {
        this.userID = userID;
        this.displayName = displayName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.info = info;
        this.dateOfBirth = dateOfBirth;
        this.avatar = avatar;
        this.gender = gender;
    }

    public int getUserID() { // Getter tuân thủ chuẩn JavaBeans
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
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

    public boolean getGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

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
}