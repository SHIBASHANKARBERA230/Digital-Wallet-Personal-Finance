package com.wallet.controller;

import com.wallet.dao.UserDAO;
import com.wallet.dao.UserDAOImpl;
import com.wallet.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

@WebServlet("/upload-profile-image")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 2 * 1024 * 1024,
        maxRequestSize = 3 * 1024 * 1024
)
public class ProfileImageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int MAX_IMAGE_BYTES = 2 * 1024 * 1024;
    private static final Set<String> ALLOWED_TYPES =
            Set.of("image/jpeg", "image/png", "image/webp");

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            Part part = request.getPart("profileImage");

            if (part == null || part.getSize() <= 0) {
                fail(session, "Please select an image to upload.");
                redirect(request, response);
                return;
            }

            if (part.getSize() > MAX_IMAGE_BYTES) {
                fail(session, "Image size must not exceed 2 MB.");
                redirect(request, response);
                return;
            }

            String contentType = part.getContentType();
            if (contentType == null ||
                    !ALLOWED_TYPES.contains(contentType.toLowerCase(Locale.ROOT))) {
                fail(session, "Upload a JPG, PNG, or WebP image.");
                redirect(request, response);
                return;
            }

            byte[] bytes;
            try (var input = part.getInputStream()) {
                bytes = input.readNBytes(MAX_IMAGE_BYTES + 1);
            }

            if (bytes.length == 0 || bytes.length > MAX_IMAGE_BYTES) {
                fail(session, "Image size must not exceed 2 MB.");
                redirect(request, response);
                return;
            }

            BufferedImage decoded = ImageIO.read(new ByteArrayInputStream(bytes));
            if (decoded == null || decoded.getWidth() > 5000 || decoded.getHeight() > 5000) {
                fail(session, "The selected file is not a valid supported image.");
                redirect(request, response);
                return;
            }

            String extension = switch (contentType.toLowerCase(Locale.ROOT)) {
                case "image/jpeg" -> ".jpg";
                case "image/png" -> ".png";
                case "image/webp" -> ".webp";
                default -> throw new IllegalArgumentException("Unsupported image type.");
            };

            Path uploadDirectory = uploadDirectory();
            Files.createDirectories(uploadDirectory);

            String fileName = UUID.randomUUID() + extension;
            Path destination = uploadDirectory.resolve(fileName).normalize();

            if (!destination.startsWith(uploadDirectory)) {
                throw new IOException("Invalid upload destination.");
            }

            Files.write(destination, bytes);
            String imagePath = "/profile-image/" + fileName;

            boolean updated = userDAO.updateProfileImage(user.getId(), imagePath);
            if (!updated) {
                Files.deleteIfExists(destination);
                fail(session, "Could not update your profile photo.");
            } else {
                user.setProfileImage(imagePath);
                session.setAttribute("user", user);
                session.setAttribute("profileMessage", "Profile photo updated successfully.");
            }
        } catch (IllegalStateException ex) {
            fail(session, "Image is too large. Maximum size is 2 MB.");
        } catch (Exception ex) {
            getServletContext().log("Profile image upload failed for user ID " + user.getId(), ex);
            fail(session, "Unable to upload your profile photo. Please try again.");
        }

        redirect(request, response);
    }

    static Path uploadDirectory() {
        String configured = System.getProperty("digitalwallet.upload.dir");
        if (configured == null || configured.isBlank()) {
            configured = System.getProperty("user.home") + "/digital-wallet-uploads";
        }
        return Paths.get(configured).toAbsolutePath().normalize();
    }

    private static void fail(HttpSession session, String message) {
        session.setAttribute("profileError", message);
    }

    private static void redirect(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
