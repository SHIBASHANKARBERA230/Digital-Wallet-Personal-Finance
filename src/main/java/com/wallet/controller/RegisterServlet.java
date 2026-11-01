package com.wallet.controller;

import com.wallet.enums.Role;
import com.wallet.enums.UserStatus;
import com.wallet.model.User;
import com.wallet.service.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {


    private static final long serialVersionUID = 1L;

    private final UserServiceImpl userService = new UserServiceImpl();

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String name = trim(request.getParameter("name"));
        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");
        String phone = trim(request.getParameter("phone"));

        // Validate required fields.
        if (name == null || name.isBlank()) {
            forwardWithError(
                    request, response,
                    "Please enter your full name.");
            return;
        }

        if (name.length() > 100) {
            forwardWithError(
                    request, response,
                    "Name must not exceed 100 characters.");
            return;
        }

        if (email == null || email.isBlank()
                || !EMAIL_PATTERN.matcher(email).matches()
                || email.length() > 254) {

            forwardWithError(
                    request, response,
                    "Please enter a valid email address.");
            return;
        }

        if (password == null
                || password.length() < 12
                || password.length() > 72) {

            forwardWithError(
                    request, response,
                    "Password must contain between 12 and 72 characters.");
            return;
        }

        if (phone != null && !phone.isBlank()
                && phone.length() > 20) {

            forwardWithError(
                    request, response,
                    "Phone number must not exceed 20 characters.");
            return;
        }

        User user = new User();

        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone == null || phone.isBlank() ? null : phone);

        // Never accept role or status from browser parameters.
        user.setRole(Role.USER);
        user.setStatus(UserStatus.ACTIVE);

        try {
            boolean registered = userService.registerUser(user);

            if (registered) {
                // Avoid resubmitting the registration form.
                response.sendRedirect(
                        request.getContextPath()
                                + "/login.jsp?registered=success");
                return;
            }

            forwardWithError(
                    request, response,
                    "Registration could not be completed. "
                            + "Please check your details and try again.");

        } catch (RuntimeException ex) {

            getServletContext().log(
                    "Registration failed for email: " + email, ex);

            // Do not expose SQL errors or internal details to the browser.
            forwardWithError(
                    request, response,
                    "Registration failed. This email may already be registered. "
                            + "Please try again.");
        }
    }

    private static String trim(String value) {
        return value == null ? null : value.trim();
    }

    private static void forwardWithError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {

        request.setAttribute("error", message);

        request.getRequestDispatcher("/register.jsp")
                .forward(request, response);
    }
}
