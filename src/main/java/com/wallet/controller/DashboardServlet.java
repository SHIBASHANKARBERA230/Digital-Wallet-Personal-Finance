package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.ReportService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ReportService reportService =
            new ReportService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * Check login
         */
        if (session == null ||
                session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        /*
         * Get logged-in user
         */
        User user =
                (User) session.getAttribute("user");

        try {

            /*
             * Load dashboard information
             */
            Map<String, Object> summary =
                    reportService.getDashboardSummary(
                            user.getId());

            /*
             * Send summary to JSP
             */
            request.setAttribute(
                    "summary",
                    summary);

            /*
             * Also send user explicitly
             */
            request.setAttribute(
                    "user",
                    user);

            /*
             * Open dashboard
             */
            request.getRequestDispatcher(
                            "/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load dashboard data. "
                            + "Please try again.");

            request.setAttribute(
                    "user",
                    user);

            request.getRequestDispatcher(
                            "/dashboard.jsp")
                    .forward(request, response);
        }
    }
}