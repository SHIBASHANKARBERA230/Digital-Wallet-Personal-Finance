package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.TransactionServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/transactions")
public class TransactionServlet
        extends HttpServlet {

    private final TransactionServiceImpl
            transactionService =
            new TransactionServiceImpl();


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
                "transactions",
                transactionService
                        .getUserTransactions(
                                user.getId()));

        request.getRequestDispatcher(
                        "/transactions.jsp")
                .forward(request, response);
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

        if ("income".equals(action)) {

            handleIncome(
                    request,
                    response,
                    session,
                    user);

        } else if ("expense".equals(action)) {

            handleExpense(
                    request,
                    response,
                    session,
                    user);

        } else if ("transfer".equals(action)) {

            handleTransfer(
                    request,
                    response,
                    session,
                    user);

        } else {

            session.setAttribute(
                    "transactionError",
                    "Invalid transaction operation.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/transactions");

        }
    }


    private void handleIncome(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            User user)
            throws IOException {

        double amount;

        try {

            amount =
                    Double.parseDouble(
                            request.getParameter(
                                    "amount"));

        } catch (Exception e) {

            session.setAttribute(
                    "transactionError",
                    "Invalid amount.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/transactions");

            return;
        }

        if (amount <= 0) {

            session.setAttribute(
                    "transactionError",
                    "Amount must be greater than zero.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/transactions");

            return;
        }

        boolean result =
                transactionService.addIncome(
                        user.getId(),
                        amount);

        if (result) {

            session.setAttribute(
                    "transactionMessage",
                    "Income added successfully.");

        } else {

            session.setAttribute(
                    "transactionError",
                    "Unable to add income.");
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/transactions");
    }


    private void handleExpense(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            User user)
            throws IOException {

        double amount;

        try {

            amount =
                    Double.parseDouble(
                            request.getParameter(
                                    "amount"));

        } catch (Exception e) {

            session.setAttribute(
                    "transactionError",
                    "Invalid amount.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/transactions");

            return;
        }

        if (amount <= 0) {

            session.setAttribute(
                    "transactionError",
                    "Amount must be greater than zero.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/transactions");

            return;
        }

        boolean result =
                transactionService.addExpense(
                        user.getId(),
                        amount);

        if (result) {

            session.setAttribute(
                    "transactionMessage",
                    "Expense transaction added.");

        } else {

            session.setAttribute(
                    "transactionError",
                    "Insufficient balance or transaction failed.");
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/transactions");
    }


    private void handleTransfer(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            User user)
            throws IOException {

        int receiverId;

        double amount;

        try {

            receiverId =
                    Integer.parseInt(
                            request.getParameter(
                                    "receiverId"));

            amount =
                    Double.parseDouble(
                            request.getParameter(
                                    "amount"));

        } catch (Exception e) {

            session.setAttribute(
                    "transactionError",
                    "Invalid receiver ID or amount.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/transactions");

            return;
        }

        if (receiverId <= 0 ||
                amount <= 0) {

            session.setAttribute(
                    "transactionError",
                    "Receiver and amount must be valid.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/transactions");

            return;
        }

        if (receiverId == user.getId()) {

            session.setAttribute(
                    "transactionError",
                    "You cannot transfer money to yourself.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/transactions");

            return;
        }

        boolean result =
                transactionService.transferMoney(
                        user.getId(),
                        receiverId,
                        amount);

        if (result) {

            session.setAttribute(
                    "transactionMessage",
                    "Money transferred successfully.");

        } else {

            session.setAttribute(
                    "transactionError",
                    "Transfer failed. "
                            + "Check receiver and balance.");
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/transactions");
    }
}