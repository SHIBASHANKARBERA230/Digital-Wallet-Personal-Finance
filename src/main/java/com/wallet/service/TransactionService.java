package com.wallet.service;

import com.wallet.model.Transaction;

import java.util.List;

public interface TransactionService {

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

    List<Transaction> getUserTransactions(
            int userId);
}