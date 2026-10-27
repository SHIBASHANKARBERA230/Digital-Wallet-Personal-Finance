package com.wallet.service;

import com.wallet.util.DBConnection;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class ReportService {

    public Map<String, Object> getDashboardSummary(
            int userId) throws SQLException {

        Map<String, Object> result =
                new HashMap<>();

        // Money added to wallet
        double income =
                getIncome(userId);

        // Money spent from wallet
        double expense =
                getExpense(userId);

        // Transfer activity of this user
        double transfer =
                getTransfer(userId);

        // Actual current wallet balance
        double balance =
                getWalletBalance(userId);

        // Savings = income - expenses
        // Transfers are not treated as expenses
        double savings =
                income - expense;

        result.put("income", income);
        result.put("expense", expense);
        result.put("transfer", transfer);
        result.put("balance", balance);
        result.put("savings", savings);

        return result;
    }


    public Map<String, Object> getFinancialReport(
            int userId) throws SQLException {

        return getDashboardSummary(userId);
    }


    /*
     * --------------------------------------------------
     * INCOME
     * --------------------------------------------------
     *
     * Income is stored as:
     *
     * transaction_type = DEPOSIT
     * receiver_id = userId
     * sender_id = NULL
     */
    private double getIncome(
            int userId) throws SQLException {

        String sql =
                "SELECT COALESCE(SUM(amount), 0) " +
                        "FROM transactions " +
                        "WHERE receiver_id = ? " +
                        "AND transaction_type = 'DEPOSIT' " +
                        "AND status = 'SUCCESS'";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }

        return 0;
    }


    /*
     * --------------------------------------------------
     * EXPENSE
     * --------------------------------------------------
     *
     * Expense is stored as:
     *
     * transaction_type = WITHDRAW
     * sender_id = userId
     * receiver_id = NULL
     */
    private double getExpense(
            int userId) throws SQLException {

        String sql =
                "SELECT COALESCE(SUM(amount), 0) " +
                        "FROM transactions " +
                        "WHERE sender_id = ? " +
                        "AND transaction_type = 'WITHDRAW' " +
                        "AND status = 'SUCCESS'";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }

        return 0;
    }


    /*
     * --------------------------------------------------
     * TRANSFERS
     * --------------------------------------------------
     *
     * A transfer can involve the user as:
     *
     * sender OR receiver.
     *
     * Each transfer exists as ONE row, so using
     * OR does not double-count that row.
     */
    private double getTransfer(
            int userId) throws SQLException {

        String sql =
                "SELECT COALESCE(SUM(amount), 0) " +
                        "FROM transactions " +
                        "WHERE (sender_id = ? OR receiver_id = ?) " +
                        "AND transaction_type = 'TRANSFER' " +
                        "AND status = 'SUCCESS'";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);

            try (ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }

        return 0;
    }


    /*
     * --------------------------------------------------
     * CURRENT WALLET BALANCE
     * --------------------------------------------------
     *
     * The wallet table already stores the actual balance.
     * Therefore dashboard balance should come directly
     * from wallets instead of calculating:
     *
     * income - expense
     *
     * because transfers also change the wallet balance.
     */
    private double getWalletBalance(
            int userId) throws SQLException {

        String sql =
                "SELECT COALESCE(balance, 0) " +
                        "FROM wallets " +
                        "WHERE user_id = ?";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }

        return 0;
    }
}