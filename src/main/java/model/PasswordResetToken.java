package model;

import java.sql.Timestamp;

/**
 *
 * @author NgoThinh1902
 */
public class PasswordResetToken {
    private int id;
    private int userId;
    private String token;
    private Timestamp created_at;
    private Timestamp expires_at;

    public PasswordResetToken() {
    }

    public PasswordResetToken(int id, int userId, String token, Timestamp created_at, Timestamp expires_at) {
        this.id = id;
        this.userId = userId;
        this.token = token;
        this.created_at = created_at;
        this.expires_at = expires_at;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getExpires_at() {
        return expires_at;
    }

    public void setExpires_at(Timestamp expires_at) {
        this.expires_at = expires_at;
    }

    @Override
    public String toString() {
        return "PasswordResetToken{" + "id=" + id + ", userId=" + userId + ", token=" + token + ", created_at=" + created_at + ", expires_at=" + expires_at + '}';
    }
}
