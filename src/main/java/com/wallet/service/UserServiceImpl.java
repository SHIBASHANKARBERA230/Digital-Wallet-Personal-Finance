package com.wallet.service;

import com.wallet.dao.UserDAO;
import com.wallet.dao.UserDAOImpl;
import com.wallet.enums.UserStatus;
import com.wallet.model.User;
import com.wallet.util.PasswordUtil;
import com.wallet.util.ValidationUtil;

import java.sql.Timestamp;

public class UserServiceImpl implements UserService {

    private final UserDAO userDAO;

    public UserServiceImpl() {
        this.userDAO = new UserDAOImpl();
    }

    @Override
    public boolean registerUser(User user) {

        if (user == null) {
            return false;
        }

        if (!ValidationUtil.isValidName(user.getName())) {
            return false;
        }

        if (!ValidationUtil.isValidEmail(user.getEmail())) {
            return false;
        }

        if (!ValidationUtil.isValidPassword(user.getPassword())) {
            return false;
        }

        if (!ValidationUtil.isValidPhone(user.getPhone())) {
            return false;
        }

        if (userDAO.emailExists(user.getEmail())) {
            return false;
        }

        String hashedPassword =
                PasswordUtil.hashPassword(
                        user.getPassword());

        user.setPassword(hashedPassword);

        user.setStatus(
                UserStatus.ACTIVE);

        return userDAO.registerUser(user);
    }

    @Override
    public User loginUser(
            String email,
            String password) {

        if (!ValidationUtil.isValidEmail(email)
                || password == null
                || password.isEmpty()) {

            return null;
        }

        User user =
                userDAO.getUserByEmail(email);

        if (user == null) {
            return null;
        }

        if (user.getStatus()
                != UserStatus.ACTIVE) {

            return null;
        }

        if (!PasswordUtil.verifyPassword(
                password,
                user.getPassword())) {

            return null;
        }

        return user;
    }

    @Override
    public User getUserByEmail(
            String email) {

        if (!ValidationUtil.isValidEmail(email)) {
            return null;
        }

        return userDAO.getUserByEmail(email);
    }

    @Override
    public boolean updatePassword(
            String email,
            String hashedPassword) {

        if (!ValidationUtil.isValidEmail(email)
                || hashedPassword == null
                || hashedPassword.isEmpty()) {

            return false;
        }

        return userDAO.updatePassword(
                email,
                hashedPassword);
    }

    @Override
    public boolean saveResetToken(
            String email,
            String resetToken,
            Timestamp resetTokenExpiry) {

        if (!ValidationUtil.isValidEmail(email)
                || resetToken == null
                || resetToken.isEmpty()
                || resetTokenExpiry == null) {

            return false;
        }

        return userDAO.saveResetToken(
                email,
                resetToken,
                resetTokenExpiry);
    }

    @Override
    public User getUserByResetToken(
            String resetToken) {

        if (resetToken == null
                || resetToken.isEmpty()) {

            return null;
        }

        return userDAO.getUserByResetToken(
                resetToken);
    }

    @Override
    public boolean clearResetToken(
            String email) {

        if (!ValidationUtil.isValidEmail(email)) {
            return false;
        }

        return userDAO.clearResetToken(
                email);
    }
    @Override
    public boolean updateUser(User user) {

        if (user == null) {
            return false;
        }

        if (user.getId() <= 0) {
            return false;
        }

        if (!ValidationUtil.isValidName(user.getName())) {
            return false;
        }

        if (!ValidationUtil.isValidPhone(user.getPhone())) {
            return false;
        }

        return userDAO.updateUser(user);
    }
}