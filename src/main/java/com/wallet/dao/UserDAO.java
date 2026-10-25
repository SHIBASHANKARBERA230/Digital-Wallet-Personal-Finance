package com.wallet.dao;

import com.wallet.model.User;

public interface UserDAO {

    boolean registerUser(User user);

    User getUserByEmail(String email);

    boolean emailExists(String email);

    boolean updatePassword(
            String email,
            String hashedPassword);

    boolean saveResetToken(
            String email,
            String resetToken,
            java.sql.Timestamp resetTokenExpiry);

    User getUserByResetToken(
            String resetToken);

    boolean clearResetToken(
            String email);
    boolean updateUser(User user);
}