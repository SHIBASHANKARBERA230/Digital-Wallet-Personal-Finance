package com.wallet.dao;

import com.wallet.model.Transaction;

import java.util.List;

public interface TransactionDAO {

    boolean addIncome(
            int userId,
            double amount);

    boolean addExpense(
            int userId,
            double amount);

    boolean transferMoney(
            int senderId,
            int receiverId,
            double amount);

    List<Transaction> getTransactionsByUserId(
            int userId);
}