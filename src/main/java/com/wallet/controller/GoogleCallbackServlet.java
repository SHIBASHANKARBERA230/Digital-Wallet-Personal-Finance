package com.wallet.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.GenericUrl;
import com.google.api.client.http.HttpRequest;
import com.google.api.client.http.HttpRequestFactory;
import com.google.api.client.http.HttpResponse;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.gson.GsonFactory;

import com.wallet.dao.UserDAO;
import com.wallet.dao.UserDAOImpl;
import com.wallet.enums.UserStatus;
import com.wallet.model.User;
import com.wallet.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

@WebServlet("/google-callback")
public class GoogleCallbackServlet extends HttpServlet {

    private static final String CLIENT_ID =
            System.getenv("GOOGLE_CLIENT_ID");

    private static final String CLIENT_SECRET =
            System.getenv("GOOGLE_CLIENT_SECRET");

    private static final String REDIRECT_URI =
            "http://localhost:8080/DigitalWalletSystem/google-callback";

    private static final String USER_INFO_URL =
            "https://www.googleapis.com/oauth2/v2/userinfo";

    private final UserDAO userDAO =
            new UserDAOImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");
            return;
        }

        String savedState =
                (String) session.getAttribute(
                        "GOOGLE_OAUTH_STATE");

        String returnedState =
                request.getParameter("state");

        if (savedState == null
                || returnedState == null
                || !savedState.equals(returnedState)) {

            session.removeAttribute(
                    "GOOGLE_OAUTH_STATE");

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Invalid Google OAuth state.");

            return;
        }

        session.removeAttribute(
                "GOOGLE_OAUTH_STATE");

        String code =
                request.getParameter("code");

        if (code == null || code.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Google authorization code is missing.");

            return;
        }

        if (CLIENT_ID == null
                || CLIENT_ID.isEmpty()
                || CLIENT_SECRET == null
                || CLIENT_SECRET.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Google OAuth credentials are not configured.");

            return;
        }

        try {

            HttpTransport transport =
                    GoogleNetHttpTransport.newTrustedTransport();

            /*
             * Exchange authorization code
             * for access token.
             */
            GoogleTokenResponse tokenResponse =
                    new GoogleAuthorizationCodeTokenRequest(
                            transport,
                            GsonFactory.getDefaultInstance(),
                            CLIENT_ID,
                            CLIENT_SECRET,
                            code,
                            REDIRECT_URI)
                            .execute();

            String accessToken =
                    tokenResponse.getAccessToken();

            if (accessToken == null
                    || accessToken.isEmpty()) {

                response.sendError(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Unable to obtain Google access token.");

                return;
            }

            /*
             * Request Google UserInfo.
             */
            HttpRequestFactory requestFactory =
                    transport.createRequestFactory();

            GenericUrl userInfoUrl =
                    new GenericUrl(USER_INFO_URL);

            HttpRequest userInfoRequest =
                    requestFactory.buildGetRequest(
                            userInfoUrl);

            userInfoRequest.getHeaders()
                    .setAuthorization(
                            "Bearer " + accessToken);

            HttpResponse userInfoResponse =
                    userInfoRequest.execute();

            String userInfoJson =
                    userInfoResponse.parseAsString();

            /*
             * Diagnostic information.
             */
            System.out.println(
                    "Google UserInfo HTTP Status: "
                            + userInfoResponse.getStatusCode());

            System.out.println(
                    "Google UserInfo Response: "
                            + userInfoJson);

            if (userInfoResponse.getStatusCode() != 200) {

                response.sendError(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Google UserInfo request failed. HTTP Status: "
                                + userInfoResponse.getStatusCode());

                return;
            }

            /*
             * Extract email directly from Google's JSON.
             */
            String email =
                    extractJsonValue(
                            userInfoJson,
                            "email");

            /*
             * Extract name directly from Google's JSON.
             */
            String name =
                    extractJsonValue(
                            userInfoJson,
                            "name");

            /*
             * Verify email.
             */
            if (email == null
                    || email.trim().isEmpty()) {

                response.sendError(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Google account email could not be obtained.");

                return;
            }

            email =
                    email.trim();

            /*
             * If Google does not provide a name,
             * use the part before @.
             */
            if (name == null
                    || name.trim().isEmpty()) {

                name =
                        email.substring(
                                0,
                                email.indexOf("@"));
            }

            name =
                    name.trim();

            /*
             * Check whether user already exists.
             */
            User user =
                    userDAO.getUserByEmail(email);

            /*
             * Create new user if necessary.
             */
            if (user == null) {

                user =
                        createGoogleUser(
                                name,
                                email);

                if (user == null) {

                    response.sendError(
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                            "Unable to create Google user account.");

                    return;
                }
            }

            /*
             * Only ACTIVE users can login.
             */
            if (user.getStatus()
                    != UserStatus.ACTIVE) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Your Digital Wallet account is not active.");

                return;
            }

            /*
             * Store user in session.
             */
            session.setAttribute(
                    "user",
                    user);

            /*
             * Redirect to dashboard.
             */
            response.sendRedirect(
                    request.getContextPath()
                            + "/dashboard.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Google login failed: "
                            + e.getMessage());
        }
    }

    /*
     * Extracts a simple string value from JSON.
     *
     * Example:
     * "email": "example@gmail.com"
     */
    private String extractJsonValue(
            String json,
            String key) {

        String searchKey =
                "\"" + key + "\"";

        int keyIndex =
                json.indexOf(searchKey);

        if (keyIndex == -1) {
            return null;
        }

        int colonIndex =
                json.indexOf(
                        ":",
                        keyIndex + searchKey.length());

        if (colonIndex == -1) {
            return null;
        }

        int firstQuote =
                json.indexOf(
                        "\"",
                        colonIndex + 1);

        if (firstQuote == -1) {
            return null;
        }

        int secondQuote =
                json.indexOf(
                        "\"",
                        firstQuote + 1);

        if (secondQuote == -1) {
            return null;
        }

        return json.substring(
                firstQuote + 1,
                secondQuote);
    }

    /*
     * Creates a Digital Wallet user
     * for a Google account.
     */
    private User createGoogleUser(
            String name,
            String email) {

        try {

            String randomPassword =
                    generateRandomPassword();

            String hashedPassword =
                    PasswordUtil.hashPassword(
                            randomPassword);

            User user =
                    new User();

            user.setName(name);
            user.setEmail(email);
            user.setPassword(hashedPassword);
            user.setPhone(null);
            user.setStatus(UserStatus.ACTIVE);

            boolean registered =
                    userDAO.registerUser(user);

            if (!registered) {
                return null;
            }

            return userDAO.getUserByEmail(email);

        } catch (Exception e) {

            e.printStackTrace();

            return null;
        }
    }

    /*
     * Generates a random internal password.
     */
    private String generateRandomPassword() {

        byte[] bytes =
                new byte[32];

        new SecureRandom()
                .nextBytes(bytes);

        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(bytes);
    }
}