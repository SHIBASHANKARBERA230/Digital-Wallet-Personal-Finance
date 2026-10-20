package com.wallet.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeRequestUrl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

@WebServlet("/google-login")
public class GoogleLoginServlet extends HttpServlet {

    private static final String CLIENT_ID =
            System.getenv("GOOGLE_CLIENT_ID");

    private static final String REDIRECT_URI =
            "http://localhost:8080/DigitalWalletSystem/google-callback";

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (CLIENT_ID == null || CLIENT_ID.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Google Client ID is not configured.");

            return;
        }

        /*
         * Generate a random state value.
         * This protects the OAuth flow against CSRF attacks.
         */
        byte[] randomBytes = new byte[32];

        new SecureRandom().nextBytes(randomBytes);

        String state =
                Base64.getUrlEncoder()
                        .withoutPadding()
                        .encodeToString(randomBytes);

        /*
         * Store state in the user's session.
         * GoogleCallbackServlet will verify it later.
         */
        HttpSession session =
                request.getSession(true);

        session.setAttribute(
                "GOOGLE_OAUTH_STATE",
                state);

        /*
         * Build Google's authorization URL.
         */
        String authorizationUrl =
                new GoogleAuthorizationCodeRequestUrl(
                        CLIENT_ID,
                        REDIRECT_URI,
                        Arrays.asList(
                                "openid",
                                "email",
                                "profile"
                        ))
                .setAccessType("offline")
                .set("prompt", "select_account")
                .set("state", state)
                .build();

        /*
         * Redirect the user to Google.
         */
        response.sendRedirect(
                authorizationUrl);
    }
}