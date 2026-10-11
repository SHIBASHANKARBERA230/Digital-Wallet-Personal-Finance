package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.NotificationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final NotificationService notificationService =
            new NotificationService();

    // ==========================================
    // GET - VIEW NOTIFICATIONS
    // ==========================================
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
                    "notifications",
                    notificationService.getUserNotifications(
                            user.getId()));

            request.getRequestDispatcher(
                            "/notifications.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load notifications.");

            request.getRequestDispatcher(
                            "/notifications.jsp")
                    .forward(request, response);
        }
    }

    // ==========================================
    // POST - NOTIFICATION ACTIONS
    // ==========================================
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

            // ==========================================
            // MARK ALL AS READ
            // ==========================================
            if ("markAllRead".equals(action)) {

                notificationService.markAllAsRead(
                        user.getId());

                session.setAttribute(
                        "notificationMessage",
                        "All notifications marked as read.");
            }

            // ==========================================
            // INVALID ACTION
            // ==========================================
            else {

                session.setAttribute(
                        "notificationError",
                        "Invalid notification action.");
            }

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "notificationError",
                    "Unable to update notifications.");
        }

        // Redirect back to notifications
        response.sendRedirect(
                request.getContextPath()
                        + "/notifications");
    }
}