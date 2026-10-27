package com.wallet.service;

import com.wallet.dao.GoalDAO;
import com.wallet.model.Goal;

import java.util.List;

public class GoalService {

    private final GoalDAO goalDAO =
            new GoalDAO();

    // =========================
    // ADD GOAL
    // =========================
    public void addGoal(Goal goal) {

        if (goal == null) {
            throw new IllegalArgumentException(
                    "Goal cannot be null.");
        }

        if (goal.getTargetAmount() <= 0) {
            throw new IllegalArgumentException(
                    "Target amount must be greater than zero.");
        }

        goalDAO.save(goal);
    }

    // =========================
    // GET USER GOALS
    // =========================
    public List<Goal> getUserGoals(int userId) {

        return goalDAO.findByUserId(userId);
    }

    // =========================
    // ADD MONEY TO GOAL
    // =========================
    public void addMoney(
            int goalId,
            int userId,
            double amount) {

        if (amount <= 0) {
            throw new IllegalArgumentException(
                    "Amount must be greater than zero.");
        }

        goalDAO.addMoney(
                goalId,
                userId,
                amount);
    }

    // =========================
    // DELETE GOAL
    // =========================
    public void deleteGoal(
            int goalId,
            int userId) {

        goalDAO.delete(
                goalId,
                userId);
    }
}