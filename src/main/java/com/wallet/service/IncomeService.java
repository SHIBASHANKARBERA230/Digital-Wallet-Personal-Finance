package com.wallet.service;

import com.wallet.model.Income;
import java.util.List;

public interface IncomeService {
    boolean addIncome(int userId, String category, double amount, String incomeDate);
    List<Income> getIncomes(int userId);
}
