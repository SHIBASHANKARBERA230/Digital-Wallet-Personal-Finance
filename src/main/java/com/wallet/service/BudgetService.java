package com.wallet.service;

import com.wallet.dao.BudgetDAO;
import com.wallet.model.Budget;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class BudgetService {

    private final BudgetDAO budgetDAO = new BudgetDAO();
    private final WalletNotificationHelper notificationHelper =
            new WalletNotificationHelper();

    public void addBudget(Budget budget) {

        if (budget == null) {
            throw new IllegalArgumentException("Budget is required.");
        }

        if (budget.getUserId() <= 0) {
            throw new IllegalArgumentException("Invalid user.");
        }

        if (budget.getCategory() == null ||
                budget.getCategory().trim().isEmpty()) {
            throw new IllegalArgumentException("Please select a category.");
        }

        if (!Double.isFinite(budget.getAmount()) ||
                budget.getAmount() <= 0) {
            throw new IllegalArgumentException(
                    "Budget amount must be greater than zero.");
        }

        if (budget.getMonth() == null) {
            throw new IllegalArgumentException("Please select a month.");
        }

        try {
            YearMonth.parse(budget.getMonth());
        } catch (RuntimeException e) {
            throw new IllegalArgumentException(
                    "Please provide a valid month in YYYY-MM format.");
        }

        budget.setCategory(budget.getCategory().trim());
        budgetDAO.save(budget);
    }

    public List<Budget> getUserBudgets(int userId) {
        return budgetDAO.findByUserId(userId);
    }

    public void deleteBudget(int budgetId, int userId) {

        if (budgetId <= 0 || userId <= 0) {
            throw new IllegalArgumentException("Invalid budget or user.");
        }

        budgetDAO.delete(budgetId, userId);
    }

    /**
     * Returns only the selected month's budgets, enriched with spending data.
     */
    public List<Budget> analyzeBudgets(int userId, String month) {

        if (userId <= 0) {
            throw new IllegalArgumentException("Invalid user.");
        }

        final YearMonth selectedMonth;
        try {
            selectedMonth = YearMonth.parse(month);
        } catch (RuntimeException e) {
            throw new IllegalArgumentException("Invalid month.", e);
        }

        List<Budget> allBudgets = budgetDAO.findByUserId(userId);
        List<Budget> result = new ArrayList<>();

        LocalDate today = LocalDate.now();
        LocalDate firstDay = selectedMonth.atDay(1);
        LocalDate lastDay = selectedMonth.atEndOfMonth();

        int daysRemaining;
        if (today.isBefore(firstDay)) {
            daysRemaining = selectedMonth.lengthOfMonth();
        } else if (today.isAfter(lastDay)) {
            daysRemaining = 0;
        } else {
            daysRemaining = (int) ChronoUnit.DAYS.between(today, lastDay) + 1;
        }

        for (Budget budget : allBudgets) {

            if (!selectedMonth.toString().equals(budget.getMonth())) {
                continue;
            }

            double spent = budgetDAO.getMonthlyCategoryExpenses(
                    userId, budget.getCategory(), selectedMonth.toString());

            double amount = budget.getAmount();
            double remaining = amount - spent;
            double percentage = amount > 0 ? (spent / amount) * 100.0 : 0.0;

            budget.setSpentAmount(spent);
            budget.setRemainingAmount(remaining);
            budget.setUsagePercentage(roundTwoDecimals(percentage));

            if (percentage >= 100.0) {
                budget.setStatus("EXCEEDED");
            } else if (percentage >= 90.0) {
                budget.setStatus("CRITICAL");
            } else if (percentage >= 75.0) {
                budget.setStatus("WARNING");
            } else if (percentage >= 50.0) {
                budget.setStatus("CAUTION");
            } else {
                budget.setStatus("NORMAL");
            }

            double dailyLimit = 0.0;
            if (daysRemaining > 0 && remaining > 0) {
                dailyLimit = remaining / daysRemaining;
            }

            budget.setDailyLimit(roundTwoDecimals(dailyLimit));

            // Notify only at 75%, 90% and 100%+.
            // Notification title deduplication prevents repeated alerts
            // whenever the user refreshes or reopens the Budget page.
            if ("WARNING".equals(budget.getStatus())
                    || "CRITICAL".equals(budget.getStatus())
                    || "EXCEEDED".equals(budget.getStatus())) {

                java.math.BigDecimal spentValue =
                        java.math.BigDecimal.valueOf(spent)
                                .setScale(2, java.math.RoundingMode.HALF_UP);

                java.math.BigDecimal limitValue =
                        java.math.BigDecimal.valueOf(amount)
                                .setScale(2, java.math.RoundingMode.HALF_UP);

                notificationHelper.budgetThresholdAlert(
                        userId,
                        budget.getCategory(),
                        selectedMonth.toString(),
                        budget.getStatus(),
                        spentValue,
                        limitValue,
                        budget.getUsagePercentage());
            }

            result.add(budget);
        }

        return result;
    }

    private double roundTwoDecimals(double value) {
        return Math.round(value * 100.0) / 100.0;
    }
}
