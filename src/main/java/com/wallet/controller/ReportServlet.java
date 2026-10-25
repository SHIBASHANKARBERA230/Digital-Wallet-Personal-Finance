package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.ReportService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    private final ReportService reportService =
            new ReportService();

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

            Map<String, Object> report =
                    reportService.getFinancialReport(
                            user.getId());

            request.setAttribute(
                    "report",
                    report);

            request.getRequestDispatcher(
                            "/reports.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to generate report.");

            request.getRequestDispatcher(
                            "/reports.jsp")
                    .forward(request, response);
        }
    }
}