package com.wallet.service;

import com.wallet.dao.GoalDAO;
import com.wallet.model.Goal;

import java.util.List;

public class GoalService {

    private final GoalDAO goalDAO = new GoalDAO();

    public void addGoal(Goal goal) {

        if (goal == null) {
            throw new IllegalArgumentException(
                    "Goal is required.");
        }

        if (goal.getUserId() <= 0) {
            throw new IllegalArgumentException(
                    "Invalid user.");
        }

        if (goal.getGoalName() == null
                || goal.getGoalName().isBlank()) {

            throw new IllegalArgumentException(
                    "Goal name is required.");
        }

        if (goal.getGoalName().trim().length() > 150) {
            throw new IllegalArgumentException(
                    "Goal name cannot exceed 150 characters.");
        }

        if (goal.getTargetAmount() <= 0
                || !Double.isFinite(goal.getTargetAmount())) {

            throw new IllegalArgumentException(
                    "Target amount must be greater than zero.");
        }

        if (goal.getSavedAmount() < 0
                || !Double.isFinite(goal.getSavedAmount())) {

            throw new IllegalArgumentException(
                    "Saved amount cannot be negative.");
        }

        if (goal.getSavedAmount() > goal.getTargetAmount()) {
            throw new IllegalArgumentException(
                    "Saved amount cannot exceed the target.");
        }

        if (goal.getStatus() == null
                || goal.getStatus().isBlank()) {

            goal.setStatus("ACTIVE");
        }

        goalDAO.save(goal);
    }

    public List<Goal> getUserGoals(int userId) {

        if (userId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid user.");
        }

        return goalDAO.findByUserId(userId);
    }

    public void addMoney(
            int goalId,
            int userId,
            double amount) {

        if (goalId <= 0 || userId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid goal or user.");
        }

        if (amount <= 0 || !Double.isFinite(amount)) {
            throw new IllegalArgumentException(
                    "Amount must be greater than zero.");
        }

        goalDAO.addMoney(goalId, userId, amount);
    }

    public void deleteGoal(int goalId, int userId) {

        if (goalId <= 0 || userId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid goal or user.");
        }

        goalDAO.delete(goalId, userId);
    }
}