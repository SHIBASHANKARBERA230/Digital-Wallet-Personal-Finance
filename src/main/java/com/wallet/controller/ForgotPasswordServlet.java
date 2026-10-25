package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.UserServiceImpl;
import com.wallet.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Timestamp;
import java.util.Base64;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final long RESET_TOKEN_VALIDITY =
            10 * 60 * 1000;

    private final UserServiceImpl userService =
            new UserServiceImpl();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String email =
                request.getParameter("email");

        if (!ValidationUtil.isValidEmail(email)) {

            request.setAttribute(
                    "error",
                    "Please enter a valid email address.");

            request.getRequestDispatcher(
                    "/forgot-password.jsp")
                    .forward(request, response);

            return;
        }

        email = email.trim();

        User user =
                userService.getUserByEmail(email);

        if (user == null) {

            request.setAttribute(
                    "error",
                    "No account found with this email address.");

            request.getRequestDispatcher(
                    "/forgot-password.jsp")
                    .forward(request, response);

            return;
        }

        // Generate a secure random reset token
        byte[] randomBytes =
                new byte[32];

        new SecureRandom()
                .nextBytes(randomBytes);

        String resetToken =
                Base64.getUrlEncoder()
                        .withoutPadding()
                        .encodeToString(randomBytes);

        // Token will remain valid for 10 minutes
        Timestamp resetTokenExpiry =
                new Timestamp(
                        System.currentTimeMillis()
                                + RESET_TOKEN_VALIDITY);

        boolean saved =
                userService.saveResetToken(
                        email,
                        resetToken,
                        resetTokenExpiry);

        if (!saved) {

            request.setAttribute(
                    "error",
                    "Unable to create password reset request. "
                            + "Please try again.");

            request.getRequestDispatcher(
                    "/forgot-password.jsp")
                    .forward(request, response);

            return;
        }

        /*
         * Store the email and token in the session.
         * The next step will verify this token
         * before allowing the password to be changed.
         */
        request.getSession(true)
                .setAttribute(
                        "RESET_EMAIL",
                        email);

        request.getSession()
                .setAttribute(
                        "RESET_TOKEN",
                        resetToken);

        request.getSession()
                .setAttribute(
                        "RESET_TOKEN_EXPIRY",
                        resetTokenExpiry.getTime());

        /*
         * For local project testing, the token is passed
         * to the reset page. Later the reset servlet will
         * verify the token and expiry before changing
         * the password.
         */
        response.sendRedirect(
                request.getContextPath()
                        + "/reset-password.jsp?token="
                        + resetToken);
    }
}