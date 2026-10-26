package com.wallet.dao;

import com.wallet.model.Budget;
import com.wallet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BudgetDAO {

    public void save(Budget budget) {

        String sql =
                "INSERT INTO budgets " +
                        "(user_id, category, amount, month) " +
                        "VALUES (?, ?, ?, ?)";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, budget.getUserId());
            ps.setString(2, budget.getCategory());
            ps.setDouble(3, budget.getAmount());
            ps.setString(4, budget.getMonth());

            ps.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Unable to save budget.",
                    e);
        }
    }

    public List<Budget> findByUserId(
            int userId) {

        List<Budget> budgets =
                new ArrayList<>();

        String sql =
                "SELECT * FROM budgets " +
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

                    Budget budget =
                            new Budget();

                    budget.setId(
                            rs.getInt("id"));

                    budget.setUserId(
                            rs.getInt("user_id"));

                    budget.setCategory(
                            rs.getString("category"));

                    budget.setAmount(
                            rs.getDouble("amount"));

                    budget.setMonth(
                            rs.getString("month"));

                    budgets.add(budget);
                }
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Unable to load budgets.",
                    e);
        }

        return budgets;
    }

    public void delete(
            int budgetId,
            int userId) {

        String sql =
                "DELETE FROM budgets " +
                        "WHERE id=? AND user_id=?";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, budgetId);
            ps.setInt(2, userId);

            ps.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Unable to delete budget.",
                    e);
        }
    }
}