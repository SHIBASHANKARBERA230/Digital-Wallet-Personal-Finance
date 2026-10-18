package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.UserServiceImpl;
import com.wallet.util.PasswordUtil;
import com.wallet.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final UserServiceImpl userService =
            new UserServiceImpl();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/forgot-password.jsp");

            return;
        }

        // Get token from the reset page
        String requestToken =
                request.getParameter("token");

        // Get token stored in the session
        Object sessionTokenObject =
                session.getAttribute("RESET_TOKEN");

        Object expiryObject =
                session.getAttribute(
                        "RESET_TOKEN_EXPIRY");

        if (requestToken == null
                || sessionTokenObject == null
                || expiryObject == null) {

            request.setAttribute(
                    "error",
                    "Invalid or expired password reset request.");

            request.getRequestDispatcher(
                    "/forgot-password.jsp")
                    .forward(request, response);

            return;
        }

        String sessionToken =
                sessionTokenObject.toString();

        long expiryTime;

        try {

            expiryTime =
                    Long.parseLong(
                            expiryObject.toString());

        } catch (NumberFormatException e) {

            clearResetSession(session);

            request.setAttribute(
                    "error",
                    "Invalid password reset request.");

            request.getRequestDispatcher(
                    "/forgot-password.jsp")
                    .forward(request, response);

            return;
        }

        // Check whether the token matches
        if (!requestToken.equals(sessionToken)) {

            request.setAttribute(
                    "error",
                    "Invalid password reset token.");

            request.getRequestDispatcher(
                    "/forgot-password.jsp")
                    .forward(request, response);

            return;
        }

        // Check whether the token has expired
        if (System.currentTimeMillis()
                > expiryTime) {

            clearResetSession(session);

            request.setAttribute(
                    "error",
                    "Password reset token has expired. "
                            + "Please request a new one.");

            request.getRequestDispatcher(
                    "/forgot-password.jsp")
                    .forward(request, response);

            return;
        }

        // Verify token against the database
        User user =
                userService.getUserByResetToken(
                        requestToken);

        if (user == null) {

            clearResetSession(session);

            request.setAttribute(
                    "error",
                    "Invalid or expired password reset token.");

            request.getRequestDispatcher(
                    "/forgot-password.jsp")
                    .forward(request, response);

            return;
        }

        String email =
                user.getEmail();

        String newPassword =
                request.getParameter(
                        "newPassword");

        String confirmPassword =
                request.getParameter(
                        "confirmPassword");

        if (newPassword == null
                || confirmPassword == null
                || newPassword.isEmpty()
                || confirmPassword.isEmpty()) {

            request.setAttribute(
                    "error",
                    "Both password fields are required.");

            request.getRequestDispatcher(
                    "/reset-password.jsp?token="
                            + requestToken)
                    .forward(request, response);

            return;
        }

        if (!ValidationUtil.isValidPassword(
                newPassword)) {

            request.setAttribute(
                    "error",
                    "Password must contain at least 6 characters.");

            request.getRequestDispatcher(
                    "/reset-password.jsp?token="
                            + requestToken)
                    .forward(request, response);

            return;
        }

        if (!newPassword.equals(
                confirmPassword)) {

            request.setAttribute(
                    "error",
                    "Passwords do not match.");

            request.getRequestDispatcher(
                    "/reset-password.jsp?token="
                            + requestToken)
                    .forward(request, response);

            return;
        }

        // Hash the new password
        String hashedPassword =
                PasswordUtil.hashPassword(
                        newPassword);

        // Update password
        boolean updated =
                userService.updatePassword(
                        email,
                        hashedPassword);

        if (!updated) {

            request.setAttribute(
                    "error",
                    "Unable to reset password. "
                            + "Please try again.");

            request.getRequestDispatcher(
                    "/reset-password.jsp?token="
                            + requestToken)
                    .forward(request, response);

            return;
        }

        // Clear token from database
        userService.clearResetToken(email);

        // Clear reset information from session
        clearResetSession(session);

        // Password successfully changed
        response.sendRedirect(
                request.getContextPath()
                        + "/login.jsp?reset=success");
    }

    private void clearResetSession(
            HttpSession session) {

        session.removeAttribute(
                "RESET_EMAIL");

        session.removeAttribute(
                "RESET_TOKEN");

        session.removeAttribute(
                "RESET_TOKEN_EXPIRY");
    }
}