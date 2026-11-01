package com.wallet.controller;

import com.wallet.model.Expense;
import com.wallet.model.User;
import com.wallet.service.ExpenseService;
import com.wallet.service.ExpenseServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;

@WebServlet("/expenses")
public class ExpenseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ExpenseService expenseService = new ExpenseServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = getAuthenticatedUser(session);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.setAttribute("expenses", expenseService.getUserExpenses(user.getId()));
        request.getRequestDispatcher("/expenses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = getAuthenticatedUser(session);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addExpense(request, response, session, user);
        } else if ("delete".equals(action)) {
            deleteExpense(request, response, session, user);
        } else {
            session.setAttribute("expenseError", "Invalid expense operation.");
            redirectToExpenses(request, response);
        }
    }

    private void addExpense(HttpServletRequest request,
                            HttpServletResponse response,
                            HttpSession session,
                            User user) throws IOException {

        String category = request.getParameter("category");
        String amountText = request.getParameter("amount");
        String dateText = request.getParameter("expenseDate");

        if (category == null || category.isBlank()) {
            session.setAttribute("expenseError", "Please select an expense category.");
            redirectToExpenses(request, response);
            return;
        }

        BigDecimal amount;
        try {
            if (amountText == null || amountText.isBlank()) {
                throw new NumberFormatException();
            }

            amount = new BigDecimal(amountText.trim())
                    .setScale(2, RoundingMode.UNNECESSARY);

            if (amount.compareTo(BigDecimal.ZERO) <= 0
                    || amount.compareTo(new BigDecimal("9999999999999.99")) > 0) {
                throw new IllegalArgumentException("Enter an amount greater than zero.");
            }
        } catch (NumberFormatException | ArithmeticException e) {
            session.setAttribute(
                    "expenseError",
                    "Enter a valid amount with no more than two decimal places."
            );
            redirectToExpenses(request, response);
            return;
        } catch (IllegalArgumentException e) {
            session.setAttribute("expenseError", e.getMessage());
            redirectToExpenses(request, response);
            return;
        }

        Date expenseDate;
        try {
            if (dateText == null || dateText.isBlank()) {
                throw new IllegalArgumentException();
            }
            expenseDate = Date.valueOf(dateText);
        } catch (IllegalArgumentException e) {
            session.setAttribute("expenseError", "Please select a valid expense date.");
            redirectToExpenses(request, response);
            return;
        }

        Expense expense = new Expense();
        expense.setUserId(user.getId());
        expense.setCategory(category.trim());
        expense.setAmount(amount.doubleValue());
        expense.setExpenseDate(expenseDate);

        boolean success = expenseService.addExpense(expense);

        if (success) {
            session.setAttribute(
                    "expenseMessage",
                    "Expense recorded and wallet balance updated successfully."
            );
        } else {
            session.setAttribute(
                    "expenseError",
                    "Expense was not recorded. Check your wallet balance and try again."
            );
        }

        redirectToExpenses(request, response);
    }

    private void deleteExpense(HttpServletRequest request,
                               HttpServletResponse response,
                               HttpSession session,
                               User user) throws IOException {

        int expenseId;
        try {
            expenseId = Integer.parseInt(request.getParameter("expenseId"));
        } catch (Exception e) {
            session.setAttribute("expenseError", "Invalid expense ID.");
            redirectToExpenses(request, response);
            return;
        }

        boolean success = expenseService.deleteExpense(expenseId, user.getId());

        if (success) {
            session.setAttribute(
                    "expenseMessage",
                    "Expense deleted and the amount refunded to your wallet."
            );
        } else {
            session.setAttribute(
                    "expenseError",
                    "Expense could not be deleted. No refund was made."
            );
        }

        redirectToExpenses(request, response);
    }

    private User getAuthenticatedUser(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute("user");
        return value instanceof User ? (User) value : null;
    }

    private void redirectToExpenses(HttpServletRequest request,
                                    HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/expenses");
    }
}
