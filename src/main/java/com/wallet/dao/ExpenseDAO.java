package com.wallet.dao;

import com.wallet.model.Expense;

import java.util.List;

public interface ExpenseDAO {

    boolean addExpense(
            Expense expense);

    List<Expense>
    getExpensesByUserId(int userId);

    boolean deleteExpense(
            int expenseId,
            int userId);
}