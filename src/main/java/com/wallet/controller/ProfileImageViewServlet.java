package com.wallet.controller;

import com.wallet.dao.UserDAO;
import com.wallet.dao.UserDAOImpl;
import com.wallet.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet("/profile-image/*")
public class ProfileImageViewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("user") instanceof User)) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        String pathInfo = request.getPathInfo();

        if (pathInfo == null
                || !pathInfo.matches("/[a-fA-F0-9-]{36}\\.(jpg|png|webp)")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            // Fetch the latest image path from the database.
            User latestUser = userDAO.login(sessionUser.getEmail());

            if (latestUser == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            String expectedPath = "/profile-image/" + pathInfo.substring(1);

            if (latestUser.getProfileImage() == null
                    || !expectedPath.equals(latestUser.getProfileImage())) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Refresh the session's profile information.
            latestUser.setPassword(null);
            session.setAttribute("user", latestUser);

            Path directory = ProfileImageServlet.uploadDirectory();
            Path image = directory.resolve(pathInfo.substring(1)).normalize();

            if (!image.startsWith(directory)
                    || !Files.isRegularFile(image)) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            String extension = pathInfo.substring(
                    pathInfo.lastIndexOf('.') + 1
            );

            response.setContentType(switch (extension) {
                case "jpg" -> "image/jpeg";
                case "png" -> "image/png";
                case "webp" -> "image/webp";
                default -> "application/octet-stream";
            });

            response.setHeader("X-Content-Type-Options", "nosniff");
            response.setHeader("Cache-Control", "private, no-cache, no-store");

            Files.copy(image, response.getOutputStream());

        } catch (Exception ex) {
            getServletContext().log("Failed to retrieve profile image.", ex);

            if (!response.isCommitted()) {
                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to retrieve profile image."
                );
            }
        }
    }
}