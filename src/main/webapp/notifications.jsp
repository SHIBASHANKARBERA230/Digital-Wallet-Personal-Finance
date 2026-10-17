<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.wallet.model.User" %>
<%@ page import="com.wallet.model.Notification" %>

<%
    User user =
            (User) session.getAttribute("user");

    if (user == null) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp");

        return;
    }
 List<Notification> notifications =
            (List<Notification>)
                    request.getAttribute("notifications");
%><!DOCTYPE html>

<html>

<head>
<meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width,
                   initial-scale=1.0">

    <title>Notifications - Digital Wallet</title>