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
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object sessionUser = session.getAttribute("user");

        if (!(sessionUser instanceof User)) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) sessionUser;

        try {
            Map<String, Object> summary =
                    reportService.getDashboardSummary(user.getId());

            request.setAttribute("summary", summary);
            request.setAttribute("user", user);

            request.getRequestDispatcher("/dashboard.jsp")
                    .forward(request, response);

        } catch (SQLException | RuntimeException e) {
            getServletContext().log(
                    "ERROR loading dashboard for user ID: " + user.getId(), e);

            request.setAttribute("error",
                    "Dashboard data could not be loaded. Please check the server log.");

            request.setAttribute("user", user);
            request.getRequestDispatcher("/dashboard.jsp")
                    .forward(request, response);
        }
    }
}
