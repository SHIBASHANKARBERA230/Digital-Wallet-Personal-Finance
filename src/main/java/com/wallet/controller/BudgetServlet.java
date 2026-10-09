package com.wallet.controller;

import com.wallet.model.Budget;
import com.wallet.model.User;
import com.wallet.service.BudgetService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/budget")
public class BudgetServlet extends HttpServlet {

    private final BudgetService budgetService =
            new BudgetService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");

            return;
        }

        User user =
                (User) session.getAttribute("user");

        try {

            List<Budget> budgets =
                    budgetService.getUserBudgets(
                            user.getId());

            request.setAttribute(
                    "budgets",
                    budgets);

            request.getRequestDispatcher(
                            "/budget.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load budgets.");

            request.getRequestDispatcher(
                            "/budget.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");

            return;
        }

        User user =
                (User) session.getAttribute("user");

        String action =
                request.getParameter("action");

        try {

            if ("add".equals(action)) {

                String category =
                        request.getParameter("category");

                double amount =
                        Double.parseDouble(
                                request.getParameter("amount"));

                String month =
                        request.getParameter("month");

                Budget budget = new Budget();

                budget.setUserId(user.getId());
                budget.setCategory(category);
                budget.setAmount(amount);
                budget.setMonth(month);

                budgetService.addBudget(budget);

                session.setAttribute(
                        "budgetMessage",
                        "Budget added successfully.");

            } else if ("delete".equals(action)) {

                int budgetId =
                        Integer.parseInt(
                                request.getParameter("budgetId"));

                budgetService.deleteBudget(
                        budgetId,
                        user.getId());

                session.setAttribute(
                        "budgetMessage",
                        "Budget deleted successfully.");
            }

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "budgetError",
                    "Unable to process budget.");
        }

        response.sendRedirect(
                request.getContextPath() + "/budget");
    }
}