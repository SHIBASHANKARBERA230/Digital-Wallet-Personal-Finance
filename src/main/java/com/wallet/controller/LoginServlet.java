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

    private final UserServiceImpl userService =
            new UserServiceImpl();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        if (email == null ||
                email.trim().isEmpty() ||
                password == null ||
                password.isEmpty()) {

            request.setAttribute(
                    "error",
                    "Email and password are required.");

            request.getRequestDispatcher(
                            "/login.jsp")
                    .forward(request, response);

            return;
        }

        User user =
                userService.loginUser(
                        email.trim(),
                        password);

        if (user == null) {

            request.setAttribute(
                    "error",
                    "Invalid email or password.");

            request.getRequestDispatcher(
                            "/login.jsp")
                    .forward(request, response);

            return;
        }

        HttpSession session =
                request.getSession(true);

        session.setAttribute(
                "user",
                user);

        response.sendRedirect(
                request.getContextPath()
                        + "/dashboard.jsp");
    }
}