package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserServiceImpl userService = new UserServiceImpl();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isBlank()
                || password == null || password.isEmpty()) {

            request.setAttribute(
                    "error",
                    "Email and password are required."
            );

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
            return;
        }

        User user;

        try {
            user = userService.login(email.trim(), password);
        } catch (RuntimeException ex) {
            getServletContext().log("Login verification failed.", ex);

            request.setAttribute(
                    "error",
                    "Unable to log in right now. Please try again."
            );

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
            return;
        }

        if (user == null) {
            request.setAttribute(
                    "error",
                    "Invalid email or password."
            );

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
            return;
        }

        if (user.getStatus() == null
                || !"ACTIVE".equals(user.getStatus().name())) {

            request.setAttribute(
                    "error",
                    "Your account is not active."
            );

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
            return;
        }

        // Prevent session fixation.
        HttpSession oldSession = request.getSession(false);

        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);

        response.sendRedirect(
                request.getContextPath() + "/dashboard.jsp"
        );
    }
}