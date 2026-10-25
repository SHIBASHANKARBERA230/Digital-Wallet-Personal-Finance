package com.wallet.dao;

import com.wallet.model.Goal;
import com.wallet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GoalDAO {

    public void save(Goal goal) {

        String sql =
                "INSERT INTO goals " +
                        "(user_id, goal_name, target_amount, " +
                        "saved_amount, deadline, status) " +
                        "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, goal.getUserId());
            ps.setString(2, goal.getGoalName());
            ps.setDouble(3, goal.getTargetAmount());
            ps.setDouble(4, goal.getSavedAmount());
            ps.setString(5, goal.getDeadline());
            ps.setString(6, "ACTIVE");

            ps.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Unable to save goal.",
                    e);
        }
    }

    public List<Goal> findByUserId(
            int userId) {

        List<Goal> goals =
                new ArrayList<>();

        String sql =
                "SELECT * FROM goals " +
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

                    Goal goal =
                            new Goal();

                    goal.setId(
                            rs.getInt("id"));

                    goal.setUserId(
                            rs.getInt("user_id"));

                    goal.setGoalName(
                            rs.getString("goal_name"));

                    goal.setTargetAmount(
                            rs.getDouble(
                                    "target_amount"));

                    goal.setSavedAmount(
                            rs.getDouble(
                                    "saved_amount"));

                    goal.setDeadline(
                            rs.getString("deadline"));

                    goal.setStatus(
                            rs.getString("status"));

                    goals.add(goal);
                }
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Unable to load goals.",
                    e);
        }

        return goals;
    }

    public void addMoney(
            int goalId,
            int userId,
            double amount) {

        String sql =
                "UPDATE goals " +
                        "SET saved_amount = saved_amount + ?, " +
                        "status = CASE " +
                        "WHEN saved_amount + ? >= target_amount " +
                        "THEN 'COMPLETED' ELSE status END " +
                        "WHERE id=? AND user_id=?";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setDouble(1, amount);
            ps.setDouble(2, amount);
            ps.setInt(3, goalId);
            ps.setInt(4, userId);

            ps.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Unable to add money.",
                    e);
        }
    }

    public void delete(
            int goalId,
            int userId) {

        String sql =
                "DELETE FROM goals " +
                        "WHERE id=? AND user_id=?";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, goalId);
            ps.setInt(2, userId);

            ps.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Unable to delete goal.",
                    e);
        }
    }
}