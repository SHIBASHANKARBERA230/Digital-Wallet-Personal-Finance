package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.IncomeService;
import com.wallet.service.IncomeServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/income")
public class IncomeServlet extends HttpServlet {
    private final IncomeService incomeService = new IncomeServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        request.setAttribute("incomes", incomeService.getIncomes(user.getId()));
        request.setAttribute("today", LocalDate.now().toString());
        request.getRequestDispatcher("/income.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String category = request.getParameter("category");
        String amountText = request.getParameter("amount");
        String incomeDate = request.getParameter("incomeDate");

        try {
            double amount = Double.parseDouble(amountText);
            boolean success = incomeService.addIncome(
                    user.getId(), category, amount, incomeDate
            );
            if (success) {
                session.setAttribute("incomeMessage", "Income recorded successfully.");
            } else {
                session.setAttribute("incomeError",
                        "Unable to record income. Check the category, date and amount.");
            }
        } catch (Exception e) {
            session.setAttribute("incomeError", "Please enter a valid income amount.");
        }

        response.sendRedirect(request.getContextPath() + "/income");
    }
}
