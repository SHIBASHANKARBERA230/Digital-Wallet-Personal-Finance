package com.wallet.dao;

import com.wallet.model.Expense;
import com.wallet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExpenseDAOImpl
        implements ExpenseDAO {

    @Override
    public boolean addExpense(
            Expense expense) {

        String sql =
                "INSERT INTO expenses "
                        + "(user_id, category, amount, expense_date) "
                        + "VALUES (?, ?, ?, ?)";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    expense.getUserId());

            ps.setString(
                    2,
                    expense.getCategory());

            ps.setDouble(
                    3,
                    expense.getAmount());

            ps.setDate(
                    4,
                    expense.getExpenseDate());

            return ps.executeUpdate() == 1;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }


    @Override
    public List<Expense>
    getExpensesByUserId(int userId) {

        List<Expense> expenses =
                new ArrayList<>();

        String sql =
                "SELECT * FROM expenses "
                        + "WHERE user_id = ? "
                        + "ORDER BY expense_date DESC, id DESC";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Expense expense =
                        new Expense();

                expense.setId(
                        rs.getInt("id"));

                expense.setUserId(
                        rs.getInt("user_id"));

                expense.setCategory(
                        rs.getString("category"));

                expense.setAmount(
                        rs.getDouble("amount"));

                expense.setExpenseDate(
                        rs.getDate("expense_date"));

                expenses.add(expense);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return expenses;
    }


    @Override
    public boolean deleteExpense(
            int expenseId,
            int userId) {

        String sql =
                "DELETE FROM expenses "
                        + "WHERE id = ? "
                        + "AND user_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(sql)) {

            ps.setInt(1, expenseId);
            ps.setInt(2, userId);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }
}