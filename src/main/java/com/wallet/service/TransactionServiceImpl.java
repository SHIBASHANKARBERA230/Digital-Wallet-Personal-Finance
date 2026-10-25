package com.wallet.service;

import com.wallet.dao.TransactionDAOImpl;
import com.wallet.model.Transaction;

import java.util.Collections;
import java.util.List;

public class TransactionServiceImpl
        implements TransactionService {

    private final TransactionDAOImpl transactionDAO =
            new TransactionDAOImpl();

    @Override
    public boolean addIncome(
            int userId,
            double amount) {

        if (userId <= 0 ||
                amount <= 0) {

            return false;
        }

        return transactionDAO.addIncome(
                userId,
                amount);
    }

    @Override
    public boolean addExpense(
            int userId,
            double amount) {

        if (userId <= 0 ||
                amount <= 0) {

            return false;
        }

        return transactionDAO.addExpense(
                userId,
                amount);
    }

    @Override
    public boolean transferMoney(
            int senderId,
            int receiverId,
            double amount) {

        if (senderId <= 0 ||
                receiverId <= 0 ||
                senderId == receiverId ||
                amount <= 0) {

            return false;
        }

        return transactionDAO.transferMoney(
                senderId,
                receiverId,
                amount);
    }

    @Override
    public List<Transaction> getUserTransactions(
            int userId) {

        if (userId <= 0) {
            return Collections.emptyList();
        }

        return transactionDAO
                .getTransactionsByUserId(userId);
    }
}