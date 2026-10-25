package com.wallet.controller;

import com.wallet.dao.UserDAO;
import com.wallet.dao.UserDAOImpl;
import com.wallet.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO =
            new UserDAOImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Check login
        if (session == null ||
                session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        try {

            // Get all users
            List<User> users =
                    userDAO.findAll();

            // Send users to JSP
            request.setAttribute(
                    "users",
                    users);

            // Open admin dashboard
            request.getRequestDispatcher(
                            "/admin/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load admin dashboard.");

            // IMPORTANT:
            // forward() requires request AND response
            request.getRequestDispatcher(
                            "/admin/dashboard.jsp")
                    .forward(request, response);
        }
    }
}