package com.wallet.service;

import com.wallet.dao.IncomeDAO;
import com.wallet.dao.IncomeDAOImpl;
import com.wallet.model.Income;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class IncomeServiceImpl implements IncomeService {
    private final IncomeDAO incomeDAO = new IncomeDAOImpl();

    private static final List<String> CATEGORIES = Arrays.asList(
            "Salary", "Freelancing", "Business", "Investment",
            "Bonus", "Rental Income", "Interest", "Other"
    );

    @Override
    public boolean addIncome(int userId, String category, double amount, String incomeDate) {
        if (userId <= 0 || category == null || !CATEGORIES.contains(category.trim())
                || !Double.isFinite(amount) || amount <= 0 || incomeDate == null) {
            return false;
        }
        try {
            java.sql.Date.valueOf(incomeDate);
        } catch (IllegalArgumentException e) {
            return false;
        }
        return incomeDAO.addIncome(userId, category.trim(), amount, incomeDate);
    }

    @Override
    public List<Income> getIncomes(int userId) {
        if (userId <= 0) return Collections.emptyList();
        return incomeDAO.getIncomesByUserId(userId);
    }
}
