package com.wallet.controller;

import com.wallet.model.Goal;
import com.wallet.model.User;
import com.wallet.service.GoalService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/goals")
public class GoalServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final GoalService goalService =
            new GoalService();

    // =========================
    // GET - VIEW GOALS
    // =========================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Check login
        if (session == null ||
                session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        User user =
                (User) session.getAttribute("user");

        try {

            request.setAttribute(
                    "goals",
                    goalService.getUserGoals(
                            user.getId()));

            request.getRequestDispatcher(
                            "/goals.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load goals.");

            request.getRequestDispatcher(
                            "/goals.jsp")
                    .forward(request, response);
        }
    }

    // =========================
    // POST - GOAL OPERATIONS
    // =========================
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Check login
        if (session == null ||
                session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        User user =
                (User) session.getAttribute("user");

        String action =
                request.getParameter("action");

        try {

            // =========================
            // ADD GOAL
            // =========================
            if ("add".equals(action)) {

                String goalName =
                        request.getParameter("goalName");

                String targetAmount =
                        request.getParameter(
                                "targetAmount");

                if (goalName == null ||
                        goalName.trim().isEmpty()) {

                    throw new IllegalArgumentException(
                            "Goal name is required.");
                }

                if (targetAmount == null ||
                        targetAmount.trim().isEmpty()) {

                    throw new IllegalArgumentException(
                            "Target amount is required.");
                }

                double amount =
                        Double.parseDouble(
                                targetAmount);

                if (amount <= 0) {

                    throw new IllegalArgumentException(
                            "Target amount must be greater than zero.");
                }

                Goal goal =
                        new Goal();

                goal.setUserId(
                        user.getId());

                goal.setGoalName(
                        goalName.trim());

                goal.setTargetAmount(
                        amount);

                goalService.addGoal(goal);

                session.setAttribute(
                        "goalMessage",
                        "Goal added successfully.");
            }

            // =========================
            // DELETE GOAL
            // =========================
            else if ("delete".equals(action)) {

                String goalId =
                        request.getParameter("goalId");

                if (goalId == null ||
                        goalId.trim().isEmpty()) {

                    throw new IllegalArgumentException(
                            "Goal ID is required.");
                }

                int id =
                        Integer.parseInt(goalId);

                goalService.deleteGoal(
                        id,
                        user.getId());

                session.setAttribute(
                        "goalMessage",
                        "Goal deleted successfully.");
            }

            // =========================
            // INVALID ACTION
            // =========================
            else {

                session.setAttribute(
                        "goalError",
                        "Invalid goal action.");
            }

        } catch (NumberFormatException e) {

            e.printStackTrace();

            session.setAttribute(
                    "goalError",
                    "Please enter a valid amount or goal ID.");

        } catch (IllegalArgumentException e) {

            e.printStackTrace();

            session.setAttribute(
                    "goalError",
                    e.getMessage());

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "goalError",
                    "Unable to process goal.");
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/goals");
    }
}