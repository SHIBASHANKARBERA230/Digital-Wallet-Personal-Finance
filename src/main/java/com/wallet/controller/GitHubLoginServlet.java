package com.wallet.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

@WebServlet("/github-login")
public class GitHubLoginServlet extends HttpServlet {

    private static final String CLIENT_ID =
            System.getenv("GITHUB_CLIENT_ID");

    private static final String REDIRECT_URI =
            "http://localhost:8080/DigitalWalletSystem/github-callback";

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (CLIENT_ID == null || CLIENT_ID.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "GitHub Client ID is not configured.");

            return;
        }

        // Generate random state value
        byte[] randomBytes = new byte[32];

        new SecureRandom().nextBytes(randomBytes);

        String state =
                Base64.getUrlEncoder()
                        .withoutPadding()
                        .encodeToString(randomBytes);

        // Store state in session
        HttpSession session =
                request.getSession(true);

        session.setAttribute(
                "GITHUB_OAUTH_STATE",
                state);

        // GitHub authorization URL
        String authorizationUrl =
                "https://github.com/login/oauth/authorize"
                + "?client_id="
                + CLIENT_ID
                + "&redirect_uri="
                + REDIRECT_URI
                + "&scope=user:email"
                + "&state="
                + state;

        // Redirect user to GitHub
        response.sendRedirect(
                authorizationUrl);
    }
}