package com.wallet.filter;

import com.wallet.model.User;
import com.wallet.enums.UserStatus;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter(urlPatterns = {
        "/profile",
        "/profile.jsp"
})
public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        HttpSession session =
                httpRequest.getSession(false);

        /*
         * No active session means the user
         * is not authenticated.
         */
        if (session == null) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                            + "/login.jsp");

            return;
        }

        Object sessionUser =
                session.getAttribute("user");

        /*
         * Session does not contain a valid User.
         */
        if (!(sessionUser instanceof User)) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                            + "/login.jsp");

            return;
        }

        User user =
                (User) sessionUser;

        /*
         * Only ACTIVE users are allowed
         * to access their profile.
         */
        if (user.getStatus() != UserStatus.ACTIVE) {

            session.invalidate();

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                            + "/login.jsp");

            return;
        }

        /*
         * User is authenticated and active.
         * Allow the request to continue.
         */
        chain.doFilter(
                request,
                response);
    }
}