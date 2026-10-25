package com.wallet.controller;

import com.wallet.enums.UserStatus;
import com.wallet.model.User;
import com.wallet.service.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

@WebServlet("/github-callback")
public class GitHubCallbackServlet extends HttpServlet {

    private static final String CLIENT_ID =
            System.getenv("GITHUB_CLIENT_ID");

    private static final String CLIENT_SECRET =
            System.getenv("GITHUB_CLIENT_SECRET");

    private static final String REDIRECT_URI =
            "http://localhost:8080/DigitalWalletSystem/github-callback";

    private final UserServiceImpl userService =
            new UserServiceImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * Check GitHub configuration
         */
        if (CLIENT_ID == null
                || CLIENT_ID.isEmpty()
                || CLIENT_SECRET == null
                || CLIENT_SECRET.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "GitHub OAuth configuration is missing.");

            return;
        }

        /*
         * Check GitHub returned an error
         */
        String error =
                request.getParameter("error");

        if (error != null) {

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "GitHub login was cancelled or failed: "
                            + error);

            return;
        }

        /*
         * Get authorization code
         */
        String code =
                request.getParameter("code");

        if (code == null
                || code.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "GitHub authorization code is missing.");

            return;
        }

        /*
         * Validate OAuth state
         */
        String state =
                request.getParameter("state");

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "GitHub OAuth session expired.");

            return;
        }

        Object savedStateObject =
                session.getAttribute(
                        "GITHUB_OAUTH_STATE");

        if (savedStateObject == null
                || state == null
                || !state.equals(
                        savedStateObject.toString())) {

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Invalid GitHub OAuth state.");

            return;
        }

        /*
         * Remove state after successful validation
         * so that it cannot be reused.
         */
        session.removeAttribute(
                "GITHUB_OAUTH_STATE");

        /*
         * Exchange authorization code
         * for GitHub access token.
         */
        String accessToken =
                getAccessToken(code);

        if (accessToken == null
                || accessToken.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Unable to obtain GitHub access token.");

            return;
        }

        /*
         * Get GitHub user profile.
         */
        String userJson =
                getGitHubUser(accessToken);

        if (userJson == null
                || userJson.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Unable to retrieve GitHub user information.");

            return;
        }

        /*
         * Extract GitHub profile information.
         */
        String githubName =
                extractJsonValue(
                        userJson,
                        "name");

        String githubLogin =
                extractJsonValue(
                        userJson,
                        "login");

        String email =
                extractJsonValue(
                        userJson,
                        "email");

        /*
         * GitHub may return email = null
         * when the email is private.
         *
         * In that case use /user/emails.
         */
        if (email == null
                || email.trim().isEmpty()) {

            email =
                    getGitHubEmail(accessToken);
        }

        /*
         * Final email validation.
         */
        if (email == null
                || email.trim().isEmpty()
                || !email.contains("@")) {

            System.out.println(
                    "GitHub login failed: "
                            + "Unable to obtain a valid email.");

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unable to obtain a valid email from GitHub.");

            return;
        }

        email = email.trim();

        /*
         * GitHub name can be null.
         *
         * In that case use GitHub username/login.
         */
        if (githubName == null
                || githubName.trim().isEmpty()) {

            githubName = githubLogin;
        }

        if (githubName == null
                || githubName.trim().isEmpty()) {

            githubName = "GitHub User";
        }

        githubName = githubName.trim();

        System.out.println(
                "========== GITHUB LOGIN ==========");

        System.out.println(
                "GitHub name: " + githubName);

        System.out.println(
                "GitHub email: " + email);

        System.out.println(
                "===================================");

        /*
         * Check whether this email already exists.
         */
        User user =
                userService.getUserByEmail(email);

        /*
         * Existing user
         */
        if (user != null) {

            /*
             * Only ACTIVE users can login.
             */
            if (user.getStatus()
                    != UserStatus.ACTIVE) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Your account is not active.");

                return;
            }

        } else {

            /*
             * Create a new user.
             */
            user = new User();

            user.setName(githubName);
            user.setEmail(email);

            /*
             * This is a temporary internal password
             * because GitHub handles authentication.
             *
             * UserServiceImpl.registerUser()
             * will hash this password.
             */
            user.setPassword(
                    "GITHUB_OAUTH_USER");

            /*
             * Phone is optional.
             */
            user.setPhone(null);

            user.setStatus(
                    UserStatus.ACTIVE);

            boolean registered =
                    userService.registerUser(user);

            if (!registered) {

                System.out.println(
                        "GitHub user registration failed.");

                System.out.println(
                        "GitHub email: " + email);

                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to create GitHub user.");

                return;
            }

            /*
             * Get the newly created user again
             * so that we have its database ID.
             */
            user =
                    userService.getUserByEmail(email);

            if (user == null) {

                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "GitHub user was created but "
                                + "could not be loaded.");

                return;
            }
        }

        /*
         * Store authenticated user in session.
         */
        session.setAttribute(
                "user",
                user);

        /*
         * Login successful.
         */
        response.sendRedirect(
                request.getContextPath()
                        + "/dashboard.jsp");
    }

    /*
     * ============================================================
     * GET GITHUB ACCESS TOKEN
     * ============================================================
     */
    private String getAccessToken(
            String code)
            throws IOException {

        String tokenUrl =
                "https://github.com/login/oauth/access_token";

        URL url =
                new URL(tokenUrl);

        HttpURLConnection connection =
                (HttpURLConnection) url.openConnection();

        connection.setRequestMethod("POST");

        connection.setDoOutput(true);

        connection.setRequestProperty(
                "Accept",
                "application/json");

        connection.setRequestProperty(
                "Content-Type",
                "application/x-www-form-urlencoded");

        String parameters =
                "client_id="
                        + URLEncoder.encode(
                                CLIENT_ID,
                                StandardCharsets.UTF_8)
                        + "&client_secret="
                        + URLEncoder.encode(
                                CLIENT_SECRET,
                                StandardCharsets.UTF_8)
                        + "&code="
                        + URLEncoder.encode(
                                code,
                                StandardCharsets.UTF_8)
                        + "&redirect_uri="
                        + URLEncoder.encode(
                                REDIRECT_URI,
                                StandardCharsets.UTF_8);

        connection.getOutputStream()
                .write(parameters.getBytes(
                        StandardCharsets.UTF_8));

        int responseCode =
                connection.getResponseCode();

        InputStream inputStream;

        if (responseCode >= 200
                && responseCode < 300) {

            inputStream =
                    connection.getInputStream();

        } else {

            inputStream =
                    connection.getErrorStream();
        }

        String responseBody =
                readResponse(inputStream);

        connection.disconnect();

        if (responseCode < 200
                || responseCode >= 300) {

            System.out.println(
                    "GitHub token HTTP status: "
                            + responseCode);

            System.out.println(
                    "GitHub token response: "
                            + responseBody);

            return null;
        }

        return extractJsonValue(
                responseBody,
                "access_token");
    }

    /*
     * ============================================================
     * GET GITHUB USER PROFILE
     * ============================================================
     */
    private String getGitHubUser(
            String accessToken)
            throws IOException {

        URL url =
                new URL(
                        "https://api.github.com/user");

        HttpURLConnection connection =
                (HttpURLConnection)
                        url.openConnection();

        connection.setRequestMethod("GET");

        connection.setRequestProperty(
                "Authorization",
                "Bearer " + accessToken);

        connection.setRequestProperty(
                "Accept",
                "application/vnd.github+json");

        connection.setRequestProperty(
                "User-Agent",
                "DigitalWalletSystem");

        int responseCode =
                connection.getResponseCode();

        InputStream inputStream;

        if (responseCode >= 200
                && responseCode < 300) {

            inputStream =
                    connection.getInputStream();

        } else {

            inputStream =
                    connection.getErrorStream();
        }

        String responseBody =
                readResponse(inputStream);

        connection.disconnect();

        System.out.println(
                "GitHub User HTTP Status: "
                        + responseCode);

        if (responseCode >= 200
                && responseCode < 300) {

            return responseBody;
        }

        System.out.println(
                "GitHub User Response: "
                        + responseBody);

        return null;
    }

    /*
     * ============================================================
     * GET GITHUB EMAIL
     * ============================================================
     *
     * GitHub can return:
     *
     * "email": null
     *
     * from /user when the user's email is private.
     *
     * Therefore we call /user/emails.
     */
    private String getGitHubEmail(
            String accessToken)
            throws IOException {

        URL url =
                new URL(
                        "https://api.github.com/user/emails");

        HttpURLConnection connection =
                (HttpURLConnection)
                        url.openConnection();

        connection.setRequestMethod("GET");

        connection.setRequestProperty(
                "Authorization",
                "Bearer " + accessToken);

        connection.setRequestProperty(
                "Accept",
                "application/vnd.github+json");

        connection.setRequestProperty(
                "User-Agent",
                "DigitalWalletSystem");

        int responseCode =
                connection.getResponseCode();

        InputStream inputStream;

        if (responseCode >= 200
                && responseCode < 300) {

            inputStream =
                    connection.getInputStream();

        } else {

            inputStream =
                    connection.getErrorStream();
        }

        String responseBody =
                readResponse(inputStream);

        connection.disconnect();

        System.out.println(
                "GitHub Email HTTP Status: "
                        + responseCode);

        if (responseCode < 200
                || responseCode >= 300) {

            System.out.println(
                    "GitHub Email Response: "
                            + responseBody);

            return null;
        }

        /*
         * First try to find the primary
         * and verified email.
         */
        String primaryEmail =
                extractPrimaryVerifiedEmail(
                        responseBody);

        if (primaryEmail != null
                && !primaryEmail.isEmpty()) {

            return primaryEmail;
        }

        /*
         * If no primary verified email was found,
         * use the first email available.
         */
        return extractFirstEmail(
                responseBody);
    }

    /*
     * ============================================================
     * FIND PRIMARY + VERIFIED EMAIL
     * ============================================================
     */
    private String extractPrimaryVerifiedEmail(
            String json) {

        if (json == null
                || json.isEmpty()) {

            return null;
        }

        /*
         * Find every email value in the response.
         *
         * Example:
         *
         * "email":"example@gmail.com",
         * "primary":true,
         * "verified":true
         */
        String[] parts =
                json.split("\\},\\s*\\{");

        for (String part : parts) {

            String email =
                    extractJsonValue(
                            part,
                            "email");

            if (email == null
                    || email.trim().isEmpty()) {

                continue;
            }

            boolean primary =
                    part.contains(
                            "\"primary\":true")
                    || part.contains(
                            "\"primary\": true");

            boolean verified =
                    part.contains(
                            "\"verified\":true")
                    || part.contains(
                            "\"verified\": true");

            if (primary && verified) {

                return email.trim();
            }
        }

        return null;
    }

    /*
     * ============================================================
     * FIND FIRST EMAIL
     * ============================================================
     */
    private String extractFirstEmail(
            String json) {

        if (json == null
                || json.isEmpty()) {

            return null;
        }

        String searchKey =
                "\"email\"";

        int index =
                json.indexOf(searchKey);

        while (index != -1) {

            int colon =
                    json.indexOf(
                            ":",
                            index + searchKey.length());

            if (colon == -1) {
                return null;
            }

            int valueStart =
                    colon + 1;

            while (valueStart < json.length()
                    && Character.isWhitespace(
                            json.charAt(valueStart))) {

                valueStart++;
            }

            /*
             * Ignore:
             *
             * "email": null
             */
            if (json.startsWith(
                    "null",
                    valueStart)) {

                index =
                        json.indexOf(
                                searchKey,
                                index + searchKey.length());

                continue;
            }

            if (valueStart < json.length()
                    && json.charAt(valueStart) == '"') {

                int firstQuote =
                        valueStart;

                int secondQuote =
                        json.indexOf(
                                "\"",
                                firstQuote + 1);

                if (secondQuote != -1) {

                    return json.substring(
                            firstQuote + 1,
                            secondQuote);
                }
            }

            index =
                    json.indexOf(
                            searchKey,
                            index + searchKey.length());
        }

        return null;
    }

    /*
     * ============================================================
     * EXTRACT JSON STRING VALUE
     * ============================================================
     *
     * Correctly handles:
     *
     * "email": "abc@gmail.com"
     *
     * and:
     *
     * "email": null
     *
     * without accidentally reading another field such as
     * "hireable".
     */
    private String extractJsonValue(
            String json,
            String key) {

        if (json == null
                || key == null) {

            return null;
        }

        String searchKey =
                "\"" + key + "\"";

        int keyIndex =
                json.indexOf(searchKey);

        while (keyIndex != -1) {

            int colonIndex =
                    json.indexOf(
                            ":",
                            keyIndex + searchKey.length());

            if (colonIndex == -1) {
                return null;
            }

            int valueStart =
                    colonIndex + 1;

            while (valueStart < json.length()
                    && Character.isWhitespace(
                            json.charAt(valueStart))) {

                valueStart++;
            }

            /*
             * Handle:
             *
             * "email": null
             */
            if (json.startsWith(
                    "null",
                    valueStart)) {

                return null;
            }

            /*
             * We only want quoted strings.
             */
            if (valueStart < json.length()
                    && json.charAt(valueStart) == '"') {

                int firstQuote =
                        valueStart;

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
             * The value is not a string.
             * Search for another occurrence.
             */
            keyIndex =
                    json.indexOf(
                            searchKey,
                            keyIndex + searchKey.length());
        }

        return null;
    }

    /*
     * ============================================================
     * READ HTTP RESPONSE
     * ============================================================
     */
    private String readResponse(
            InputStream inputStream)
            throws IOException {

        if (inputStream == null) {
            return "";
        }

        StringBuilder response =
                new StringBuilder();

        try (BufferedReader reader =
                     new BufferedReader(
                             new InputStreamReader(
                                     inputStream,
                                     StandardCharsets.UTF_8))) {

            String line;

            while ((line =
                    reader.readLine()) != null) {

                response.append(line);
            }
        }

        return response.toString();
    }
}