package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final UserServiceImpl userService =
            new UserServiceImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        User user =
                (User) session.getAttribute("user");

        request.setAttribute(
                "profileUser",
                user);

        request.getRequestDispatcher(
                        "/profile.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        User user =
                (User) session.getAttribute("user");

        try {

            String name =
                    request.getParameter("name");

            String phone =
                    request.getParameter("phone");

            if (name == null ||
                    name.trim().isEmpty()) {

                session.setAttribute(
                        "profileError",
                        "Name cannot be empty.");

                response.sendRedirect(
                        request.getContextPath()
                                + "/profile");

                return;
            }

            user.setName(
                    name.trim());

            if (phone != null) {
                user.setPhone(
                        phone.trim());
            }

            boolean updated =
                    userService.updateUser(user);

            if (!updated) {

                session.setAttribute(
                        "profileError",
                        "Unable to update profile. "
                                + "Please check your details.");

                response.sendRedirect(
                        request.getContextPath()
                                + "/profile");

                return;
            }

            session.setAttribute(
                    "user",
                    user);

            session.setAttribute(
                    "profileMessage",
                    "Profile updated successfully.");

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "profileError",
                    "Unable to update profile.");
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/profile");
    }
}