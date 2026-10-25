package com.wallet.filter;

import com.wallet.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter(urlPatterns = {
        "/dashboard.jsp",
        "/dashboard",
        "/profile",
        "/profile.jsp",
        "/wallet",
        "/wallet.jsp",
        "/transactions",
        "/transactions.jsp",
        "/expenses",
        "/expenses.jsp"
})
public class AuthenticationFilter implements Filter {

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

        /*
         * Prevent browser from displaying
         * protected pages after logout.
         */
        httpResponse.setHeader(
                "Cache-Control",
                "no-cache, no-store, must-revalidate");

        httpResponse.setHeader(
                "Pragma",
                "no-cache");

        httpResponse.setDateHeader(
                "Expires",
                0);

        HttpSession session =
                httpRequest.getSession(false);

        User user = null;

        if (session != null) {

            Object sessionUser =
                    session.getAttribute("user");

            if (sessionUser instanceof User) {

                user = (User) sessionUser;
            }
        }

        /*
         * User is not logged in.
         * Redirect to login page.
         */
        if (user == null) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                            + "/login.jsp");

            return;
        }

        /*
         * User is authenticated.
         * Continue to the requested resource.
         */
        chain.doFilter(
                request,
                response);
    }
}