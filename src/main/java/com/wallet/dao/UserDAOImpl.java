package com.wallet.dao;

import com.wallet.model.User;
import com.wallet.enums.UserStatus;
import com.wallet.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class UserDAOImpl implements UserDAO {

    @Override
    public boolean registerUser(User user) {

        String sql = "INSERT INTO users (name, email, password, phone, status) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, user.getName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword());
            statement.setString(4, user.getPhone());
            statement.setString(5, user.getStatus().name());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public User getUserByEmail(String email) {

        String sql = "SELECT id, name, email, password, phone, status, "
                   + "reset_token, reset_token_expiry "
                   + "FROM users WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, email);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapUser(resultSet);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean emailExists(String email) {

        String sql =
                "SELECT 1 FROM users WHERE email = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, email);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                return resultSet.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private User mapUser(ResultSet resultSet)
            throws SQLException {

        User user = new User();

        user.setId(
                resultSet.getLong("id"));

        user.setName(
                resultSet.getString("name"));

        user.setEmail(
                resultSet.getString("email"));

        user.setPassword(
                resultSet.getString("password"));

        user.setPhone(
                resultSet.getString("phone"));

        String status =
                resultSet.getString("status");

        if (status != null) {

            user.setStatus(
                    UserStatus.valueOf(status));
        }

        user.setResetToken(
                resultSet.getString(
                        "reset_token"));

        user.setResetTokenExpiry(
                resultSet.getTimestamp(
                        "reset_token_expiry"));

        return user;
    }

    @Override
    public boolean updatePassword(
            String email,
            String hashedPassword) {

        String sql =
                "UPDATE users SET password = ? "
                + "WHERE email = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(
                    1,
                    hashedPassword);

            statement.setString(
                    2,
                    email);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }

    @Override
    public boolean saveResetToken(
            String email,
            String resetToken,
            Timestamp resetTokenExpiry) {

        String sql =
                "UPDATE users "
                + "SET reset_token = ?, "
                + "reset_token_expiry = ? "
                + "WHERE email = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(
                    1,
                    resetToken);

            statement.setTimestamp(
                    2,
                    resetTokenExpiry);

            statement.setString(
                    3,
                    email);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }

    @Override
    public User getUserByResetToken(
            String resetToken) {

        String sql =
                "SELECT id, name, email, password, phone, "
                + "status, reset_token, reset_token_expiry "
                + "FROM users "
                + "WHERE reset_token = ? "
                + "AND reset_token_expiry > CURRENT_TIMESTAMP";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(
                    1,
                    resetToken);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    return mapUser(resultSet);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean clearResetToken(
            String email) {

        String sql =
                "UPDATE users "
                + "SET reset_token = NULL, "
                + "reset_token_expiry = NULL "
                + "WHERE email = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(
                    1,
                    email);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }
    @Override
    public boolean updateUser(User user) {

        String sql =
                "UPDATE users "
                + "SET name = ?, phone = ? "
                + "WHERE id = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(
                    1,
                    user.getName());

            statement.setString(
                    2,
                    user.getPhone());

            statement.setLong(
                    3,
                    user.getId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }
}