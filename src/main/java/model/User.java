/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author NgoThinh1902
 */
public class User {
    private int userId;
    private String userName;
    private String displayName;
    private String email;
    private String password;
    private int role;
    private Boolean gender;
    private Timestamp birthOfDay;
    private Timestamp timeCreate;
    private String avatar;
    private String info;
    private Boolean ban;
    private int reportAmount;
    private String phoneNumber;

    public User(int userId, String userName, String displayName) {
        this.userId = userId;
        this.userName = userName;
        this.displayName = displayName;
    }

    public User() {
    }

    public User(int userId, String userName, String displayName, String email, String password, int role, Boolean gender, Timestamp birthOfDay, Timestamp timeCreate, String avatar, String info, Boolean ban, int reportAmount, String phoneNumber) {
        this.userId = userId;
        this.userName = userName;
        this.displayName = displayName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.gender = gender;
        this.birthOfDay = birthOfDay;
        this.timeCreate = timeCreate;
        this.avatar = avatar;
        this.info = info;
        this.ban = ban;
        this.reportAmount = reportAmount;
        this.phoneNumber = phoneNumber;
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

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    public Boolean getGender() {
        return gender;
    }

    public void setGender(Boolean gender) {
        this.gender = gender;
    }

    public Timestamp getBirthOfDay() {
        return birthOfDay;
    }

    public void setBirthOfDay(Timestamp birthOfDay) {
        this.birthOfDay = birthOfDay;
    }

    public Timestamp getTimeCreate() {
        return timeCreate;
    }

    public void setTimeCreate(Timestamp timeCreate) {
        this.timeCreate = timeCreate;
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

    public Boolean getBan() {
        return ban;
    }

    public void setBan(Boolean ban) {
        this.ban = ban;
    }

    public int getReportAmount() {
        return reportAmount;
    }

    public void setReportAmount(int reportAmount) {
        this.reportAmount = reportAmount;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    @Override
    public String toString() {
        return "User{" + "userId=" + userId + ", userName=" + userName + ", displayName=" + displayName + ", email=" + email + ", password=" + password + ", role=" + role + ", gender=" + gender + ", birthOfDay=" + birthOfDay + ", timeCreate=" + timeCreate + ", avatar=" + avatar + ", info=" + info + ", ban=" + ban + ", reportAmount=" + reportAmount + ", phoneNumber=" + phoneNumber + '}';
    }
    
    
    
}
