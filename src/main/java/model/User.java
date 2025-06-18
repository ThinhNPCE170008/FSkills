/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author DELL
 */
public class User {

    private int userId;
    private String userName;
    private String displayName;
    private String email;
    private String password;
    private Role role;
    private int gender;
    private Timestamp dateOfBirth;
    private Timestamp userCreateDate;
    private String avatar;
    private String info;
    private Ban ban;
    private int reports;
    private String phone;
    private boolean isVerified;
    private String googleID;

    public User() {

    }

    public User(int userId, String userName, String displayName, String email, String password, Role role, int gender, Timestamp dateOfBirth, Timestamp userCreateDate, String avatar, String info, Ban ban, int reports, String phone, boolean isVerified, String googleID) {
        this.userId = userId;
        this.userName = userName;
        this.displayName = displayName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.userCreateDate = userCreateDate;
        this.avatar = avatar;
        this.info = info;
        this.ban = ban;
        this.reports = reports;
        this.phone = phone;
        this.isVerified = isVerified;
        this.googleID = googleID;
    }


    public User(String userName, String displayName, String email, String password, Role role, String avatar, boolean isVerified, String googleID) {
        this.userName = userName;
        this.displayName = displayName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.avatar = avatar;
        this.isVerified = isVerified;
        this.googleID = googleID;
    }

    public User(int userId, String userName, String displayName, String avatar) {
        this.userId = userId;
        this.userName = userName;
        this.displayName = displayName;
        // Gán giá trị mặc định cho các thuộc tính còn lại
        this.email = null;
        this.password = null;
        this.role = role; // Hoặc một Role mặc định khác, ví dụ: Role.UNKNOWN
        this.gender = 0; // Hoặc một giá trị mặc định khác
        this.dateOfBirth = null;
        this.userCreateDate = null;
        this.avatar = avatar;
        this.info = null;
        this.ban = ban; // Hoặc một Ban mặc định khác
        this.reports = 0;
        this.phone = "0999111111"; // Hoặc một giá trị mặc định khác
    }

    public User(int userId, String userName, String displayName) {
        this.userId = userId;
        this.userName = userName;
        this.displayName = displayName;
        // Gán giá trị mặc định cho các thuộc tính còn lại
        this.email = null;
        this.password = null;
        this.role = role; // Hoặc một Role mặc định khác, ví dụ: Role.UNKNOWN
        this.gender = 0; // Hoặc một giá trị mặc định khác
        this.dateOfBirth = null;
        this.userCreateDate = null;
        this.avatar = null;
        this.info = null;
        this.ban = ban; // Hoặc một Ban mặc định khác
        this.reports = 0;
        this.phone = "0999111111"; // Hoặc một giá trị mặc định khác
    }

    public User(int userId, String displayName, String email, int gender, Timestamp dateOfBirth, String avatar, String info) {
        this.userId = userId;
        this.displayName = displayName;
        this.email = email;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.avatar = avatar;
        this.info = info;
    }
    
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
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
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
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
        return "User{" + "userId=" + userId + ", userName=" + userName + ", displayName=" + displayName + ", email=" + email + ", password=" + password + ", role=" + role + ", gender=" + gender + ", dateOfBirth=" + dateOfBirth + ", userCreateDate=" + userCreateDate + ", avatar=" + avatar + ", info=" + info + ", ban=" + ban + ", reports=" + reports + ", phone=" + phone + ", isVerified=" + isVerified + ", googleID=" + googleID + '}';
    }

}