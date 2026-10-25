package com.wallet.service;

import com.wallet.dao.ExpenseDAOImpl;
import com.wallet.model.Expense;

import java.util.List;

public class ExpenseServiceImpl
        implements ExpenseService {

    private final ExpenseDAOImpl expenseDAO =
            new ExpenseDAOImpl();

    @Override
    public boolean addExpense(
            Expense expense) {

        if (expense == null) {
            return false;
        }

        if (expense.getUserId() <= 0) {
            return false;
        }

        if (expense.getAmount() <= 0) {
            return false;
        }

        if (expense.getCategory() == null ||
                expense.getCategory()
                        .trim()
                        .isEmpty()) {

            return false;
        }

        if (expense.getExpenseDate() == null) {
            return false;
        }

        return expenseDAO.addExpense(expense);
    }

    @Override
    public List<Expense> getUserExpenses(
            int userId) {

        if (userId <= 0) {
            return List.of();
        }

        return expenseDAO
                .getExpensesByUserId(userId);
    }

    @Override
    public boolean deleteExpense(
            int expenseId,
            int userId) {

        if (expenseId <= 0 ||
                userId <= 0) {

            return false;
        }

        return expenseDAO.deleteExpense(
                expenseId,
                userId);
    }
}