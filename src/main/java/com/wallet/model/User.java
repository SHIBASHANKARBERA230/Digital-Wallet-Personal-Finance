package com.wallet.model;

import com.wallet.enums.UserStatus;

public class User {

    private long id;
    private String name;
    private String email;
    private String password;
    private String phone;
    private UserStatus status;

    private String resetToken;
    private java.sql.Timestamp resetTokenExpiry;

    public User() {
    }

    public User(long id, String name, String email, String password,
                String phone, UserStatus status) {

        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.status = status;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public UserStatus getStatus() {
        return status;
    }

    public void setStatus(UserStatus status) {
        this.status = status;
    }

    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public java.sql.Timestamp getResetTokenExpiry() {
        return resetTokenExpiry;
    }

    public void setResetTokenExpiry(
            java.sql.Timestamp resetTokenExpiry) {

        this.resetTokenExpiry = resetTokenExpiry;
    }
}