package com.wallet.service;

import com.wallet.model.User;

import java.sql.Timestamp;

public interface UserService {

    boolean registerUser(User user);

    User loginUser(
            String email,
            String password);

    User getUserByEmail(
            String email);

    boolean updatePassword(
            String email,
            String hashedPassword);

    boolean saveResetToken(
            String email,
            String resetToken,
            Timestamp resetTokenExpiry);

    User getUserByResetToken(
            String resetToken);

    boolean clearResetToken(
            String email);
    boolean updateUser(User user);
}