package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.WalletServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/wallet")
public class WalletServlet extends HttpServlet {

    private final WalletServiceImpl walletService =
            new WalletServiceImpl();

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

        String amountParameter =
                request.getParameter("amount");

        double amount;

        try {

            amount =
                    Double.parseDouble(
                            amountParameter);

        } catch (NumberFormatException e) {

            session.setAttribute(
                    "walletError",
                    "Please enter a valid amount.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/wallet.jsp");

            return;
        }

        if (amount <= 0) {

            session.setAttribute(
                    "walletError",
                    "Amount must be greater than zero.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/wallet.jsp");

            return;
        }

        boolean success;

        if ("deposit".equals(action)) {

            success =
                    walletService.addMoney(
                            user.getId(),
                            amount);

        } else if ("withdraw".equals(action)) {

            success =
                    walletService.withdrawMoney(
                            user.getId(),
                            amount);

        } else {

            session.setAttribute(
                    "walletError",
                    "Invalid wallet operation.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/wallet.jsp");

            return;
        }

        if (success) {

            session.setAttribute(
                    "walletMessage",
                    "Wallet updated successfully.");

        } else {

            session.setAttribute(
                    "walletError",
                    "Transaction failed. Check your balance.");
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/wallet.jsp");
    }
}