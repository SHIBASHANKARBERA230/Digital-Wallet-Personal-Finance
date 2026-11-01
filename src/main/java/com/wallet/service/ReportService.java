package com.wallet.service;

import com.wallet.enums.TransactionStatus;
import com.wallet.enums.TransactionType;
import com.wallet.model.Transaction;
import com.wallet.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Builds dashboard and report data for one wallet owner.
 *
 * Assumptions based on the current schema:
 * - DEPOSIT: receiver_id is the wallet owner.
 * - WITHDRAW: sender_id is the wallet owner.
 * - TRANSFER: sender_id is the sender and receiver_id is the recipient.
 * - Only SUCCESS transactions affect dashboard totals.
 */
public class ReportService {

    public Map<String, Object> getDashboardSummary(int userId)
            throws SQLException {

        Map<String, Object> result = new HashMap<>();

        YearMonth currentMonth = YearMonth.now();
        LocalDate monthStart = currentMonth.atDay(1);
        LocalDate nextMonthStart = currentMonth.plusMonths(1).atDay(1);
        LocalDate previousMonthStart = currentMonth.minusMonths(1).atDay(1);

        double balance = getWalletBalance(userId);

        double income = getAmountForPeriod(
                userId, "DEPOSIT", monthStart, nextMonthStart);

        double expenses = getAmountForPeriod(
                userId, "WITHDRAW", monthStart, nextMonthStart);

        // Transfers are reported separately; they are not deposits or withdrawals.
        double transfersSent = getTransferAmountForPeriod(
                userId, true, monthStart, nextMonthStart);

        double transfersReceived = getTransferAmountForPeriod(
                userId, false, monthStart, nextMonthStart);

        double previousIncome = getAmountForPeriod(
                userId, "DEPOSIT", previousMonthStart, monthStart);

        double previousExpenses = getAmountForPeriod(
                userId, "WITHDRAW", previousMonthStart, monthStart);

        int transactionCount = getTransactionCount(
                userId, monthStart, nextMonthStart);

        // Savings here means monthly net activity from deposits and withdrawals only.
        // Transfers are displayed separately so they are not silently classified as income/expense.
        double savings = income - expenses;
        double savingsRate = income > 0.0 ? (savings / income) * 100.0 : 0.0;

        result.put("balance", balance);
        result.put("totalIncome", income);
        result.put("totalExpense", expenses);
        result.put("savings", savings);
        result.put("savingsRate", savingsRate);
        result.put("transactionCount", transactionCount);

        result.put("previousIncome", previousIncome);
        result.put("previousExpense", previousExpenses);
        result.put("incomeChange", percentageChange(previousIncome, income));
        result.put("expenseChange", percentageChange(previousExpenses, expenses));

        result.put("transfersSent", transfersSent);
        result.put("transfersReceived", transfersReceived);
        result.put("transfer", transfersSent + transfersReceived);

        result.put("monthlyTrend", getMonthlyTrend(userId, 6));
        result.put("recentTransactions", getRecentTransactions(userId, 8));
        result.put("transactionBreakdown",
                getTransactionBreakdown(userId, monthStart, nextMonthStart));

        // Compatibility keys for existing report pages.
        result.put("income", income);
        result.put("expense", expenses);

        return result;
    }

    public Map<String, Object> getFinancialReport(int userId)
            throws SQLException {
        return getDashboardSummary(userId);
    }

    private double percentageChange(double previous, double current) {
        if (previous == 0.0) {
            return current == 0.0 ? 0.0 : 100.0;
        }
        return ((current - previous) / previous) * 100.0;
    }

    private double getAmountForPeriod(
            int userId, String type, LocalDate from, LocalDate to)
            throws SQLException {

        final String sql;

        if ("DEPOSIT".equals(type)) {
            sql = "SELECT COALESCE(SUM(amount), 0) " +
                    "FROM transactions " +
                    "WHERE receiver_id = ? " +
                    "AND transaction_type = 'DEPOSIT' " +
                    "AND status = 'SUCCESS' " +
                    "AND transaction_date >= ? " +
                    "AND transaction_date < ?";
        } else if ("WITHDRAW".equals(type)) {
            sql = "SELECT COALESCE(SUM(amount), 0) " +
                    "FROM transactions " +
                    "WHERE sender_id = ? " +
                    "AND transaction_type = 'WITHDRAW' " +
                    "AND status = 'SUCCESS' " +
                    "AND transaction_date >= ? " +
                    "AND transaction_date < ?";
        } else {
            throw new IllegalArgumentException("Unsupported transaction type: " + type);
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setDate(2, java.sql.Date.valueOf(from));
            ps.setDate(3, java.sql.Date.valueOf(to));

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0.0;
            }
        }
    }

    private double getTransferAmountForPeriod(
            int userId, boolean sent, LocalDate from, LocalDate to)
            throws SQLException {

        String ownerColumn = sent ? "sender_id" : "receiver_id";

        String sql = "SELECT COALESCE(SUM(amount), 0) " +
                "FROM transactions " +
                "WHERE " + ownerColumn + " = ? " +
                "AND transaction_type = 'TRANSFER' " +
                "AND status = 'SUCCESS' " +
                "AND transaction_date >= ? " +
                "AND transaction_date < ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setDate(2, java.sql.Date.valueOf(from));
            ps.setDate(3, java.sql.Date.valueOf(to));

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0.0;
            }
        }
    }

    private int getTransactionCount(
            int userId, LocalDate from, LocalDate to) throws SQLException {

        String sql = "SELECT COUNT(*) FROM transactions " +
                "WHERE (sender_id = ? OR receiver_id = ?) " +
                "AND status = 'SUCCESS' " +
                "AND transaction_date >= ? " +
                "AND transaction_date < ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setDate(3, java.sql.Date.valueOf(from));
            ps.setDate(4, java.sql.Date.valueOf(to));

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private List<Map<String, Object>> getMonthlyTrend(
            int userId, int months) throws SQLException {

        List<Map<String, Object>> trend = new ArrayList<>();
        YearMonth currentMonth = YearMonth.now();

        for (int i = months - 1; i >= 0; i--) {
            YearMonth month = currentMonth.minusMonths(i);
            LocalDate from = month.atDay(1);
            LocalDate to = month.plusMonths(1).atDay(1);

            double income = getAmountForPeriod(userId, "DEPOSIT", from, to);
            double expenses = getAmountForPeriod(userId, "WITHDRAW", from, to);
            double transfersSent = getTransferAmountForPeriod(
                    userId, true, from, to);
            double transfersReceived = getTransferAmountForPeriod(
                    userId, false, from, to);

            Map<String, Object> row = new HashMap<>();
            row.put("label", month.getMonth().toString().substring(0, 3)
                    + " " + month.getYear());
            row.put("income", income);
            row.put("expense", expenses);
            row.put("savings", income - expenses);
            row.put("transfersSent", transfersSent);
            row.put("transfersReceived", transfersReceived);

            trend.add(row);
        }

        return trend;
    }

    private List<Transaction> getRecentTransactions(int userId, int limit)
            throws SQLException {

        List<Transaction> transactions = new ArrayList<>();

        String sql = "SELECT id, sender_id, receiver_id, amount, " +
                "transaction_type, status, transaction_date " +
                "FROM transactions " +
                "WHERE (sender_id = ? OR receiver_id = ?) " +
                "ORDER BY transaction_date DESC, id DESC LIMIT ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transaction transaction = new Transaction();
                    transaction.setId(rs.getInt("id"));

                    int sender = rs.getInt("sender_id");
                    transaction.setSenderId(rs.wasNull() ? 0 : sender);

                    int receiver = rs.getInt("receiver_id");
                    transaction.setReceiverId(rs.wasNull() ? 0 : receiver);

                    transaction.setAmount(rs.getDouble("amount"));

                    String type = rs.getString("transaction_type");
                    if (type != null) {
                        transaction.setTransactionType(TransactionType.valueOf(type));
                    }

                    String status = rs.getString("status");
                    if (status != null) {
                        transaction.setStatus(TransactionStatus.valueOf(status));
                    }

                    transaction.setTransactionDate(rs.getTimestamp("transaction_date"));
                    transactions.add(transaction);
                }
            }
        }

        return transactions;
    }

    /**
     * Returns the current user's monthly breakdown. Deposits are counted by
     * receiver_id; withdrawals and outgoing transfers are counted by sender_id.
     * Incoming transfers are counted by receiver_id.
     */
    private List<Map<String, Object>> getTransactionBreakdown(
            int userId, LocalDate from, LocalDate to) throws SQLException {

        List<Map<String, Object>> breakdown = new ArrayList<>();

        String sql = "SELECT transaction_type, " +
                "SUM(CASE " +
                "WHEN transaction_type = 'DEPOSIT' AND receiver_id = ? THEN amount " +
                "WHEN transaction_type = 'WITHDRAW' AND sender_id = ? THEN amount " +
                "WHEN transaction_type = 'TRANSFER' AND sender_id = ? THEN amount " +
                "WHEN transaction_type = 'TRANSFER' AND receiver_id = ? THEN amount " +
                "ELSE 0 END) AS total, " +
                "COUNT(*) AS transaction_count " +
                "FROM transactions " +
                "WHERE status = 'SUCCESS' " +
                "AND transaction_date >= ? AND transaction_date < ? " +
                "AND ((transaction_type = 'DEPOSIT' AND receiver_id = ?) " +
                "OR (transaction_type = 'WITHDRAW' AND sender_id = ?) " +
                "OR (transaction_type = 'TRANSFER' AND (sender_id = ? OR receiver_id = ?))) " +
                "GROUP BY transaction_type";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ps.setInt(4, userId);
            ps.setDate(5, java.sql.Date.valueOf(from));
            ps.setDate(6, java.sql.Date.valueOf(to));
            ps.setInt(7, userId);
            ps.setInt(8, userId);
            ps.setInt(9, userId);
            ps.setInt(10, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("label", rs.getString("transaction_type"));
                    item.put("amount", rs.getDouble("total"));
                    item.put("count", rs.getInt("transaction_count"));
                    breakdown.add(item);
                }
            }
        }

        return breakdown;
    }

    private double getWalletBalance(int userId) throws SQLException {
        String sql = "SELECT COALESCE(balance, 0) FROM wallets WHERE user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0.0;
            }
        }
    }
}
