package com.wallet.service;

import com.wallet.dao.ExpenseDAO;
import com.wallet.dao.ExpenseDAOImpl;
import com.wallet.model.Expense;
import com.wallet.model.SpendingAnomaly;

import java.util.Collections;
import java.util.List;

public class ExpenseServiceImpl implements ExpenseService {

    private final ExpenseDAO expenseDAO = new ExpenseDAOImpl();

    private final SpendingAnomalyService anomalyService =
            new SpendingAnomalyService();

    private final WalletNotificationHelper notificationHelper =
            new WalletNotificationHelper();

    @Override
    public boolean addExpense(Expense expense) {
        if (expense == null
                || expense.getUserId() <= 0
                || expense.getCategory() == null
                || expense.getCategory().isBlank()
                || expense.getExpenseDate() == null
                || !Double.isFinite(expense.getAmount())
                || expense.getAmount() <= 0) {
            return false;
        }

        // Commit the expense, wallet deduction and linked withdrawal first.
        boolean saved = expenseDAO.addExpense(expense);
        if (!saved) {
            return false;
        }

        // Notification work is outside the financial transaction. A failure
        // here must not cause the already-saved expense to be submitted again.
        try {
            int savedExpenseId = expense.getId();

            if (savedExpenseId > 0) {
                List<SpendingAnomaly> anomalies =
                        anomalyService.detectAnomalies(expense.getUserId());

                if (anomalies != null) {
                    for (SpendingAnomaly anomaly : anomalies) {
                        if (anomaly != null
                                && anomaly.getExpenseId() == savedExpenseId) {

                            notificationHelper.unusualSpendingDetected(
                                    expense.getUserId(),
                                    anomaly.getExpenseId(),
                                    anomaly.getCategory(),
                                    anomaly.getAmount(),
                                    anomaly.getAverageAmount(),
                                    anomaly.getAlertThreshold(),
                                    String.valueOf(anomaly.getExpenseDate()),
                                    anomaly.getSampleSize()
                            );
                            break;
                        }
                    }
                }
            }
        } catch (Exception notificationError) {
            System.err.println(
                    "Expense was saved, but Smart Spending notification failed. "
                            + "User ID: " + expense.getUserId()
                            + ", expense ID: " + expense.getId()
            );
            notificationError.printStackTrace();
        }

        return true;
    }

    @Override
    public List<Expense> getUserExpenses(int userId) {
        if (userId <= 0) {
            return Collections.emptyList();
        }
        return expenseDAO.getExpensesByUserId(userId);
    }

    @Override
    public boolean deleteExpense(int expenseId, int userId) {
        if (expenseId <= 0 || userId <= 0) {
            return false;
        }
        return expenseDAO.deleteExpense(expenseId, userId);
    }
}
