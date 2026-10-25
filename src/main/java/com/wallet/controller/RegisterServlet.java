package com.wallet.controller;

import com.wallet.enums.UserStatus;
import com.wallet.model.User;
import com.wallet.service.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserServiceImpl userService =
            new UserServiceImpl();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String name =
                request.getParameter("name");

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        String phone =
                request.getParameter("phone");

        if (name == null ||
                name.trim().isEmpty() ||
                email == null ||
                email.trim().isEmpty() ||
                password == null ||
                password.length() < 6) {

            request.setAttribute(
                    "error",
                    "Please provide valid details. "
                            + "Password must contain at least 6 characters.");

            request.getRequestDispatcher(
                            "/register.jsp")
                    .forward(request, response);

            return;
        }

        User user = new User();

        user.setName(name.trim());
        user.setEmail(email.trim());
        user.setPassword(password);
        user.setPhone(phone);

        user.setStatus(UserStatus.ACTIVE);

        boolean result =
                userService.registerUser(user);

        if (result) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

        } else {

            request.setAttribute(
                    "error",
                    "Registration failed. "
                            + "Email may already exist.");

            request.getRequestDispatcher(
                            "/register.jsp")
                    .forward(request, response);
        }
    }
}