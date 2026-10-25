package com.wallet.service;

import com.wallet.model.Expense;

import java.util.List;

public interface ExpenseService {

    boolean addExpense(Expense expense);

    List<Expense> getUserExpenses(int userId);

    boolean deleteExpense(
            int expenseId,
            int userId);
}