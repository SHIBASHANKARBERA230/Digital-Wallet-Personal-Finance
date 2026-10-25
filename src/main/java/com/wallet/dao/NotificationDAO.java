package com.wallet.dao;

import com.wallet.model.Notification;
import com.wallet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public void save(Notification notification) {

        String sql =
                "INSERT INTO notifications " +
                        "(user_id, message, type, is_read) " +
                        "VALUES (?, ?, ?, ?)";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    notification.getUserId());

            ps.setString(
                    2,
                    notification.getMessage());

            ps.setString(
                    3,
                    notification.getType());

            ps.setBoolean(
                    4,
                    false);

            ps.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Unable to create notification.",
                    e);
        }
    }

    public List<Notification> findByUserId(
            int userId) {

        List<Notification> list =
                new ArrayList<>();

        String sql =
                "SELECT * FROM notifications " +
                        "WHERE user_id=? " +
                        "ORDER BY id DESC";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs =
                         ps.executeQuery()) {

                while (rs.next()) {

                    Notification n =
                            new Notification();

                    n.setId(
                            rs.getInt("id"));

                    n.setUserId(
                            rs.getInt("user_id"));

                    n.setMessage(
                            rs.getString("message"));

                    n.setType(
                            rs.getString("type"));

                    n.setRead(
                            rs.getBoolean("is_read"));

                    list.add(n);
                }
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Unable to load notifications.",
                    e);
        }

        return list;
    }

    public void markAsRead(
            int id,
            int userId) {

        String sql =
                "UPDATE notifications " +
                        "SET is_read=true " +
                        "WHERE id=? AND user_id=?";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, userId);

            ps.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Unable to update notification.",
                    e);
        }
    }

    public void markAllAsRead(
            int userId) {

        String sql =
                "UPDATE notifications " +
                        "SET is_read=true " +
                        "WHERE user_id=?";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ps.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Unable to update notifications.",
                    e);
        }
    }
}