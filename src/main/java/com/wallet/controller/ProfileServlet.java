package com.wallet.controller;

import com.wallet.dao.UserDAO;
import com.wallet.dao.UserDAOImpl;
import com.wallet.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAOImpl();

    // ==========================================
    // DISPLAY PROFILE
    // ==========================================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // Check authentication.
        if (session == null
                || !(session.getAttribute("user") instanceof User)) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");

        try {
            // Load the latest user information from the database.
            User latestUser = userDAO.findByEmail(sessionUser.getEmail());

            if (latestUser == null) {
                session.invalidate();

                response.sendRedirect(
                        request.getContextPath() + "/login.jsp");
                return;
            }

            // Never keep the password hash in the session object.
            latestUser.setPassword(null);

            // Refresh the session with the latest profile image,
            // name, phone number, email, role and status.
            session.setAttribute("user", latestUser);

            // Display the profile page.
            request.getRequestDispatcher("/profile.jsp")
                    .forward(request, response);

        } catch (RuntimeException ex) {

            getServletContext().log(
                    "Failed to load profile for user ID "
                            + sessionUser.getId(),
                    ex);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load your profile. Please try again.");
        }
    }

    // ==========================================
    // UPDATE PROFILE
    // ==========================================
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // Check authentication.
        if (session == null
                || !(session.getAttribute("user") instanceof User)) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");

        // Validate name.
        if (name == null || name.isBlank()) {

            session.setAttribute(
                    "profileError",
                    "Full name is required.");

            redirectToProfile(request, response);
            return;
        }

        name = name.trim();

        if (name.length() > 100) {

            session.setAttribute(
                    "profileError",
                    "Full name cannot exceed 100 characters.");

            redirectToProfile(request, response);
            return;
        }

        // Normalize an empty phone number to null.
        if (phone != null) {
            phone = phone.trim();

            if (phone.isEmpty()) {
                phone = null;
            }
        }

        // Validate phone number.
        if (phone != null
                && !phone.matches("[0-9+() .-]{7,20}")) {

            session.setAttribute(
                    "profileError",
                    "Please enter a valid phone number.");

            redirectToProfile(request, response);
            return;
        }

        try {
            // Create an object containing only editable fields.
            User updatedUser = new User();

            updatedUser.setId(sessionUser.getId());
            updatedUser.setName(name);
            updatedUser.setPhone(phone);

            boolean updated = userDAO.updateUser(updatedUser);

            if (updated) {

                // Fetch the latest database record so the
                // existing profile image is preserved.
                User latestUser =
                        userDAO.findByEmail(sessionUser.getEmail());

                if (latestUser != null) {
                    latestUser.setPassword(null);
                    session.setAttribute("user", latestUser);
                }

                session.setAttribute(
                        "profileMessage",
                        "Your profile has been updated successfully.");

            } else {

                session.setAttribute(
                        "profileError",
                        "No profile changes were saved. Please try again.");
            }

        } catch (RuntimeException ex) {

            getServletContext().log(
                    "Failed to update profile for user ID "
                            + sessionUser.getId(),
                    ex);

            session.setAttribute(
                    "profileError",
                    "An error occurred while updating your profile.");
        }

        redirectToProfile(request, response);
    }

    // ==========================================
    // REDIRECT HELPER
    // ==========================================
    private void redirectToProfile(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath() + "/profile");
    }
}

