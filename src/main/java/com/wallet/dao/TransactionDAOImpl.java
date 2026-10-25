package com.wallet.dao;

import com.wallet.enums.TransactionStatus;
import com.wallet.enums.TransactionType;
import com.wallet.model.Transaction;
import com.wallet.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAOImpl implements TransactionDAO {

    @Override
    public boolean addIncome(int userId, double amount) {

        Connection connection = null;

        try {
            connection = DBConnection.getConnection();

            connection.setAutoCommit(false);

            // 1. Lock and get current wallet balance
            String walletSQL =
                    "SELECT balance FROM wallets " +
                            "WHERE user_id = ? FOR UPDATE";

            double currentBalance;

            try (PreparedStatement ps =
                         connection.prepareStatement(walletSQL)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        connection.rollback();
                        return false;
                    }

                    currentBalance =
                            rs.getDouble("balance");
                }
            }

            // 2. Calculate new balance
            double newBalance =
                    currentBalance + amount;

            // 3. Update wallet
            String updateWalletSQL =
                    "UPDATE wallets " +
                            "SET balance = ? " +
                            "WHERE user_id = ?";

            try (PreparedStatement ps =
                         connection.prepareStatement(
                                 updateWalletSQL)) {

                ps.setDouble(1, newBalance);
                ps.setInt(2, userId);

                if (ps.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }
            }

            // 4. Insert DEPOSIT transaction
            String transactionSQL =
                    "INSERT INTO transactions " +
                            "(sender_id, receiver_id, amount, " +
                            "transaction_type, status) " +
                            "VALUES (NULL, ?, ?, ?, ?)";

            try (PreparedStatement ps =
                         connection.prepareStatement(
                                 transactionSQL)) {

                ps.setInt(1, userId);
                ps.setDouble(2, amount);

                ps.setString(
                        3,
                        TransactionType.DEPOSIT.name());

                ps.setString(
                        4,
                        TransactionStatus.SUCCESS.name());

                if (ps.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }
            }

            connection.commit();

            return true;

        } catch (Exception e) {

            rollback(connection);

            e.printStackTrace();

            return false;

        } finally {

            close(connection);
        }
    }

    @Override
    public boolean addExpense(
            int userId,
            double amount) {

        Connection connection = null;

        try {
            connection = DBConnection.getConnection();

            connection.setAutoCommit(false);

            // 1. Lock and get wallet balance
            String walletSQL =
                    "SELECT balance FROM wallets " +
                            "WHERE user_id = ? FOR UPDATE";

            double balance;

            try (PreparedStatement ps =
                         connection.prepareStatement(walletSQL)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        connection.rollback();
                        return false;
                    }

                    balance =
                            rs.getDouble("balance");
                }
            }

            // 2. Check sufficient balance
            if (balance < amount) {
                connection.rollback();
                return false;
            }

            // 3. Calculate new balance
            double newBalance =
                    balance - amount;

            // 4. Update wallet
            String updateWalletSQL =
                    "UPDATE wallets " +
                            "SET balance = ? " +
                            "WHERE user_id = ?";

            try (PreparedStatement ps =
                         connection.prepareStatement(
                                 updateWalletSQL)) {

                ps.setDouble(1, newBalance);
                ps.setInt(2, userId);

                if (ps.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }
            }

            // 5. Insert WITHDRAW transaction
            String transactionSQL =
                    "INSERT INTO transactions " +
                            "(sender_id, receiver_id, amount, " +
                            "transaction_type, status) " +
                            "VALUES (?, NULL, ?, ?, ?)";

            try (PreparedStatement ps =
                         connection.prepareStatement(
                                 transactionSQL)) {

                ps.setInt(1, userId);
                ps.setDouble(2, amount);

                ps.setString(
                        3,
                        TransactionType.WITHDRAW.name());

                ps.setString(
                        4,
                        TransactionStatus.SUCCESS.name());

                if (ps.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }
            }

            connection.commit();

            return true;

        } catch (Exception e) {

            rollback(connection);

            e.printStackTrace();

            return false;

        } finally {

            close(connection);
        }
    }

    @Override
    public boolean transferMoney(
            int senderId,
            int receiverId,
            double amount) {

        Connection connection = null;

        try {
            connection = DBConnection.getConnection();

            connection.setAutoCommit(false);

            // 1. Get sender balance
            String senderSQL =
                    "SELECT balance FROM wallets " +
                            "WHERE user_id = ? FOR UPDATE";

            double senderBalance;

            try (PreparedStatement ps =
                         connection.prepareStatement(senderSQL)) {

                ps.setInt(1, senderId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        connection.rollback();
                        return false;
                    }

                    senderBalance =
                            rs.getDouble("balance");
                }
            }

            // 2. Check sender balance
            if (senderBalance < amount) {
                connection.rollback();
                return false;
            }

            // 3. Check receiver wallet
            String receiverSQL =
                    "SELECT id FROM wallets " +
                            "WHERE user_id = ? FOR UPDATE";

            try (PreparedStatement ps =
                         connection.prepareStatement(
                                 receiverSQL)) {

                ps.setInt(1, receiverId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        connection.rollback();
                        return false;
                    }
                }
            }

            // 4. Deduct money from sender
            String deductSQL =
                    "UPDATE wallets " +
                            "SET balance = balance - ? " +
                            "WHERE user_id = ?";

            try (PreparedStatement ps =
                         connection.prepareStatement(deductSQL)) {

                ps.setDouble(1, amount);
                ps.setInt(2, senderId);

                if (ps.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }
            }

            // 5. Add money to receiver
            String addSQL =
                    "UPDATE wallets " +
                            "SET balance = balance + ? " +
                            "WHERE user_id = ?";

            try (PreparedStatement ps =
                         connection.prepareStatement(addSQL)) {

                ps.setDouble(1, amount);
                ps.setInt(2, receiverId);

                if (ps.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }
            }

            // 6. Insert TRANSFER transaction
            String transactionSQL =
                    "INSERT INTO transactions " +
                            "(sender_id, receiver_id, amount, " +
                            "transaction_type, status) " +
                            "VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement ps =
                         connection.prepareStatement(
                                 transactionSQL)) {

                ps.setInt(1, senderId);
                ps.setInt(2, receiverId);
                ps.setDouble(3, amount);

                ps.setString(
                        4,
                        TransactionType.TRANSFER.name());

                ps.setString(
                        5,
                        TransactionStatus.SUCCESS.name());

                if (ps.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }
            }

            connection.commit();

            return true;

        } catch (Exception e) {

            rollback(connection);

            e.printStackTrace();

            return false;

        } finally {

            close(connection);
        }
    }

    @Override
    public List<Transaction> getTransactionsByUserId(
            int userId) {

        List<Transaction> transactions =
                new ArrayList<>();

        String sql =
                "SELECT * FROM transactions " +
                        "WHERE sender_id = ? " +
                        "OR receiver_id = ? " +
                        "ORDER BY transaction_date DESC";

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        connection.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);

            try (ResultSet rs =
                         ps.executeQuery()) {

                while (rs.next()) {

                    Transaction transaction =
                            new Transaction();

                    transaction.setId(
                            rs.getInt("id"));

                    int senderId =
                            rs.getInt("sender_id");

                    if (!rs.wasNull()) {
                        transaction.setSenderId(
                                senderId);
                    }

                    int receiverId =
                            rs.getInt("receiver_id");

                    if (!rs.wasNull()) {
                        transaction.setReceiverId(
                                receiverId);
                    }

                    transaction.setAmount(
                            rs.getDouble("amount"));

                    String type =
                            rs.getString(
                                    "transaction_type");

                    if (type != null) {

                        transaction.setTransactionType(
                                TransactionType.valueOf(
                                        type));
                    }

                    String status =
                            rs.getString("status");

                    if (status != null) {

                        transaction.setStatus(
                                TransactionStatus.valueOf(
                                        status));
                    }

                    transaction.setTransactionDate(
                            rs.getTimestamp(
                                    "transaction_date"));

                    transactions.add(transaction);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return transactions;
    }

    private void rollback(
            Connection connection) {

        if (connection != null) {

            try {
                connection.rollback();

            } catch (SQLException ignored) {
            }
        }
    }

    private void close(
            Connection connection) {

        if (connection != null) {

            try {

                connection.setAutoCommit(true);
                connection.close();

            } catch (SQLException ignored) {
            }
        }
    }
}