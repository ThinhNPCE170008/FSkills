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

        if (email == null) {
            return false;
        }

        // Check if email starts with a letter or underscore
        if (!email.matches("^[a-zA-Z_].*")) {
            return false;
        }

        // Split email into local part and domain part
        String[] parts = email.split("@");
        if (parts.length != 2) {
            return false;
        }

        String localPart = parts[0];
        String domainPart = parts[1];

        // Check if local part contains only allowed characters
        if (!localPart.matches("^[a-zA-Z0-9_.-]*$")) {
            return false;
        }

        // Check if email contains at least one letter
        if (!email.matches(".*[a-zA-Z].*")) {
            return false;
        }

        // Check domain part format and TLD length (2-4 characters)
        if (!domainPart.matches(".*\\.[a-zA-Z]{2,4}$")) {
            return false;
        }

        return true;
    }

    public boolean validatePhoneNumber() {
        // Validate Vietnamese phone number format
        // Must be 10 digits, start with 0, and second digit must be 3, 5, 7, 8, or 9
        if (phoneNumber == null || phoneNumber.length() != 10) {
            return false;
        }

        // Check if it's all digits
        if (!phoneNumber.matches("^[0-9]{10}$")) {
            return false;
        }

        // Check if it starts with 0
        if (phoneNumber.charAt(0) != '0') {
            return false;
        }

        // Check if second digit is valid (3, 5, 7, 8, 9)
        char secondDigit = phoneNumber.charAt(1);
        if (secondDigit != '3' && secondDigit != '5' && secondDigit != '7' && 
            secondDigit != '8' && secondDigit != '9') {
            return false;
        }

        // Check for 5 consecutive occurrences of the same digit
        for (int i = 0; i <= phoneNumber.length() - 5; i++) {
            char currentDigit = phoneNumber.charAt(i);
            boolean hasFiveConsecutive = true;

            for (int j = 1; j < 5; j++) {
                if (phoneNumber.charAt(i + j) != currentDigit) {
                    hasFiveConsecutive = false;
                    break;
                }
            }

            if (hasFiveConsecutive) {
                return false;
            }
        }

        // Check for any digit appearing 6 or more times in total
        int[] digitCount = new int[10]; // Count occurrences of each digit (0-9)

        for (int i = 0; i < phoneNumber.length(); i++) {
            int digit = phoneNumber.charAt(i) - '0';
            digitCount[digit]++;

            if (digitCount[digit] >= 6) {
                return false;
            }
        }

        return true;
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
