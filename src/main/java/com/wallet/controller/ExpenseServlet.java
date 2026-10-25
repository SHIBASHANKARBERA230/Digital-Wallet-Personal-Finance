package com.wallet.controller;

import com.wallet.model.Expense;
import com.wallet.model.User;
import com.wallet.service.ExpenseServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/expenses")
public class ExpenseServlet
        extends HttpServlet {

    private final ExpenseServiceImpl
            expenseService =
            new ExpenseServiceImpl();


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
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        User user =
                (User) session.getAttribute("user");

        request.setAttribute(
                "expenses",
                expenseService
                        .getUserExpenses(
                                user.getId()));

        request.getRequestDispatcher(
                        "/expenses.jsp")
                .forward(
                        request,
                        response);
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

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

        if ("add".equals(action)) {

            addExpense(
                    request,
                    response,
                    session,
                    user);

        } else if ("delete".equals(action)) {

            deleteExpense(
                    request,
                    response,
                    session,
                    user);

        } else {

            session.setAttribute(
                    "expenseError",
                    "Invalid expense operation.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/expenses");
        }
    }


    private void addExpense(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            User user)
            throws IOException {

        String category =
                request.getParameter("category");

        String amountText =
                request.getParameter("amount");

        String dateText =
                request.getParameter("expenseDate");

        if (category == null ||
                category.trim().isEmpty()) {

            session.setAttribute(
                    "expenseError",
                    "Category is required.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/expenses");

            return;
        }

        double amount;

        try {

            amount =
                    Double.parseDouble(
                            amountText);

        } catch (Exception e) {

            session.setAttribute(
                    "expenseError",
                    "Invalid amount.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/expenses");

            return;
        }

        if (amount <= 0) {

            session.setAttribute(
                    "expenseError",
                    "Amount must be greater than zero.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/expenses");

            return;
        }

        Date expenseDate;

        try {

            expenseDate =
                    Date.valueOf(dateText);

        } catch (Exception e) {

            session.setAttribute(
                    "expenseError",
                    "Invalid expense date.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/expenses");

            return;
        }

        Expense expense =
                new Expense();

        expense.setUserId(
                user.getId());

        expense.setCategory(
                category.trim());

        expense.setAmount(
                amount);

        expense.setExpenseDate(
                expenseDate);

        boolean result =
                expenseService
                        .addExpense(expense);

        if (result) {

            session.setAttribute(
                    "expenseMessage",
                    "Expense added successfully.");

        } else {

            session.setAttribute(
                    "expenseError",
                    "Unable to save expense.");
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/expenses");
    }


    private void deleteExpense(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            User user)
            throws IOException {

        int expenseId;

        try {

            expenseId =
                    Integer.parseInt(
                            request.getParameter(
                                    "expenseId"));

        } catch (Exception e) {

            session.setAttribute(
                    "expenseError",
                    "Invalid expense ID.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/expenses");

            return;
        }

        boolean result =
                expenseService.deleteExpense(
                        expenseId,
                        user.getId());

        if (result) {

            session.setAttribute(
                    "expenseMessage",
                    "Expense deleted successfully.");

        } else {

            session.setAttribute(
                    "expenseError",
                    "Expense could not be deleted.");
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/expenses");
    }
}