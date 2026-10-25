package com.wallet.service;

import com.wallet.dao.BudgetDAO;
import com.wallet.model.Budget;

import java.util.List;

public class BudgetService {

    private final BudgetDAO budgetDAO =
            new BudgetDAO();

    public void addBudget(Budget budget) {

        if (budget == null) {
            throw new IllegalArgumentException(
                    "Budget cannot be null.");
        }

        if (budget.getAmount() <= 0) {
            throw new IllegalArgumentException(
                    "Budget amount must be greater than zero.");
        }

        budgetDAO.save(budget);
    }

    public List<Budget> getUserBudgets(int userId) {

        return budgetDAO.findByUserId(userId);
    }

    public void deleteBudget(
            int budgetId,
            int userId) {

        budgetDAO.delete(
                budgetId,
                userId);
    }
}