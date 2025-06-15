package model;

import java.sql.Timestamp;

public class User {

    private int UserID; // Đổi userId -> UserID
    private String userName;
    private String DisplayName; // Đổi displayName -> DisplayName (giữ nguyên tên này vì bạn muốn DisplayName)
    private String Email; // Đổi email -> Email
    private String password;
    private Role role;
    private int gender;
    private Timestamp dateOfBirth;
    private Timestamp userCreateDate;
    private String avatar;
    private String Info; // Đổi info -> Info
    private Ban ban;
    private int reports;
    private String PhoneNumber; // Đổi phone -> PhoneNumber
    private boolean isVerified;
    private String googleID;

    public User() {

    }

    public User(int UserID, String userName, String DisplayName, String Email, String password, Role role, int gender, Timestamp dateOfBirth, Timestamp userCreateDate, String avatar, String Info, Ban ban, int reports, String PhoneNumber, boolean isVerified, String googleID) {
        this.UserID = UserID;
        this.userName = userName;
        this.DisplayName = DisplayName;
        this.Email = Email;
        this.password = password;
        this.role = role;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.userCreateDate = userCreateDate;
        this.avatar = avatar;
        this.Info = Info;
        this.ban = ban;
        this.reports = reports;
        this.PhoneNumber = PhoneNumber;
        this.isVerified = isVerified;
        this.googleID = googleID;
    }

    public User(String userName, String DisplayName, String Email, String password, Role role, String avatar, boolean isVerified, String googleID) {
        this.userName = userName;
        this.DisplayName = DisplayName;
        this.Email = Email;
        this.password = password;
        this.role = role;
        this.avatar = avatar;
        this.isVerified = isVerified;
        this.googleID = googleID;
    }

    public User(int UserID, String userName, String DisplayName) {
        this.UserID = UserID;
        this.userName = userName;
        this.DisplayName = DisplayName;
        this.Email = null;
        this.password = null;
        this.role = role;
        this.gender = 0;
        this.dateOfBirth = null;
        this.userCreateDate = null;
        this.avatar = null;
        this.Info = null;
        this.ban = ban;
        this.reports = 0;
        this.PhoneNumber = "0999111111";
    }

    public int getUserID() {
        return UserID;
    }

    public void setUserID(int UserID) {
        this.UserID = UserID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getDisplayName() {
        return DisplayName;
    }

    public void setDisplayName(String DisplayName) {
        this.DisplayName = DisplayName;
    }

    public String getEmail() {
        return Email;
    }

    public void setEmail(String Email) {
        this.Email = Email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public int getGender() {
        return gender;
    }

    public void setGender(int gender) {
        this.gender = gender;
    }

    public Timestamp getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Timestamp dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Timestamp getUserCreateDate() {
        return userCreateDate;
    }

    public void setUserCreateDate(Timestamp userCreateDate) {
        this.userCreateDate = userCreateDate;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getInfo() {
        return Info;
    }

    public void setInfo(String Info) {
        this.Info = Info;
    }

    public Ban getBan() {
        return ban;
    }

    public void setBan(Ban ban) {
        this.ban = ban;
    }

    public int getReports() {
        return reports;
    }

    public void setReports(int reports) {
        this.reports = reports;
    }

    public String getPhoneNumber() {
        return PhoneNumber;
    }

    public void setPhoneNumber(String PhoneNumber) {
        this.PhoneNumber = PhoneNumber;
    }

    public boolean isIsVerified() {
        return isVerified;
    }

    public void setIsVerified(boolean isVerified) {
        this.isVerified = isVerified;
    }

    public String getGoogleID() {
        return googleID;
    }

    public void setGoogleID(String googleID) {
        this.googleID = googleID;
    }

    @Override
    public String toString() {
        return "User{" + "UserID=" + UserID + ", userName=" + userName + ", DisplayName=" + DisplayName + ", Email=" + Email + ", password=" + password + ", role=" + role + ", gender=" + gender + ", dateOfBirth=" + dateOfBirth + ", userCreateDate=" + userCreateDate + ", avatar=" + avatar + ", Info=" + Info + ", ban=" + ban + ", reports=" + reports + ", PhoneNumber=" + PhoneNumber + ", isVerified=" + isVerified + ", googleID=" + googleID + '}';
    }
}