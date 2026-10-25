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
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width,
                   initial-scale=1.0">

    <title>Notifications - Digital Wallet</title>


    <style>

        /* =====================================================
           GLOBAL
           ===================================================== */

        * {
            box-sizing: border-box;
        }


        html,
        body {

            margin: 0;

            padding: 0;

            width: 100%;

            min-height: 100%;

            font-family:
                Arial,
                Helvetica,
                sans-serif;

            background:
                #f4f7fb;

            color:
                #172033;

        }


        /* =====================================================
           PAGE
           ===================================================== */

        .page {

            width: 100%;

            min-height: 100vh;

            display:
                flex;

            flex-direction:
                column;

        }


        /* =====================================================
           HEADER
           ===================================================== */

        .header {

            width: 100%;

            min-height: 85px;

            padding:
                15px 5%;

            background:
                white;

            border-bottom:
                1px solid #e3e8f0;

            display:
                flex;

            align-items:
                center;

            justify-content:
                space-between;

        }


        .brand {

            display:
                flex;

            align-items:
                center;

            gap:
                13px;

        }


        .brand-logo {

            width:
                52px;

            height:
                52px;

            object-fit:
                contain;

        }


        .brand-name {

            color:
                #1268f3;

            font-size:
                22px;

            font-weight:
                bold;

        }


        .brand-subtitle {

            margin-top:
                3px;

            color:
                #7a8495;

            font-size:
                11px;

        }


        .profile-area {

            display:
                flex;

            align-items:
                center;

            gap:
                12px;

        }


        .user-name {

            font-size:
                13px;

            color:
                #555f70;

        }


        .logout {

            padding:
                9px 17px;

            border:
                1px solid #dc3545;

            border-radius:
                7px;

            color:
                #dc3545;

            text-decoration:
                none;

            font-size:
                12px;

            font-weight:
                bold;

        }


        .logout:hover {

            background:
                #dc3545;

            color:
                white;

        }


        /* =====================================================
           NAVIGATION
           ===================================================== */

        .nav {

            width: 100%;

            padding:
                13px 5%;

            background:
                white;

            border-bottom:
                1px solid #e5e9f0;

            display:
                flex;

            justify-content:
                center;

            gap:
                8px;

            flex-wrap:
                wrap;

        }


        .nav a {

            padding:
                9px 15px;

            border-radius:
                7px;

            color:
                #566174;

            text-decoration:
                none;

            font-size:
                12px;

            font-weight:
                bold;

        }


        .nav a:hover {

            background:
                #eef4ff;

            color:
                #1268f3;

        }


        .nav .active {

            background:
                #1268f3;

            color:
                white;

        }


        /* =====================================================
           MAIN
           ===================================================== */

        .main {

            width:
                100%;

            padding:
                35px 5% 60px;

            flex:
                1;

        }


        .content {

            width:
                100%;

            max-width:
                1600px;

            margin:
                auto;

        }


        /* =====================================================
           PAGE HEADER
           ===================================================== */

        .page-header {

            padding:
                30px;

            background:
                linear-gradient(
                    135deg,
                    #1268f3,
                    #0649b9
                );

            color:
                white;

            border-radius:
                15px;

            display:
                flex;

            justify-content:
                space-between;

            align-items:
                center;

            gap:
                20px;

        }


        .page-header h1 {

            margin:
                0;

            font-size:
                30px;

        }


        .page-header p {

            margin:
                8px 0 0;

            color:
                #e5efff;

            font-size:
                13px;

        }


        .notification-icon {

            width:
                65px;

            height:
                65px;

            background:
                rgba(255,255,255,.15);

            border:
                1px solid
                rgba(255,255,255,.2);

            border-radius:
                15px;

            display:
                flex;

            align-items:
                center;

            justify-content:
                center;

            font-size:
                30px;

        }


        /* =====================================================
           CARD
           ===================================================== */

        .card {

            margin-top:
                25px;

            padding:
                28px;

            background:
                white;

            border:
                1px solid #e4e9f0;

            border-radius:
                14px;

            box-shadow:
                0 5px 18px
                rgba(0,0,0,.04);

        }


        .card-top {

            display:
                flex;

            justify-content:
                space-between;

            align-items:
                center;

            gap:
                20px;

            margin-bottom:
                20px;

        }


        .card-title {

            margin:
                0;

            font-size:
                20px;

            color:
                #172033;

        }


        .card-subtitle {

            margin-top:
                6px;

            color:
                #7a8495;

            font-size:
                12px;

        }


        /* =====================================================
           MARK ALL BUTTON
           ===================================================== */

        .read-all-button {

            border:
                none;

            padding:
                11px 18px;

            background:
                #1268f3;

            color:
                white;

            border-radius:
                7px;

            font-size:
                12px;

            font-weight:
                bold;

            cursor:
                pointer;

        }


        .read-all-button:hover {

            background:
                #0753cf;

        }


        .divider {

            height:
                1px;

            background:
                #e9edf3;

            margin:
                5px 0 10px;

        }


        /* =====================================================
           NOTIFICATION
           ===================================================== */

        .notification {

            padding:
                22px;

            border-bottom:
                1px solid #edf0f4;

            display:
                flex;

            align-items:
                flex-start;

            justify-content:
                space-between;

            gap:
                20px;

            transition:
                .2s ease;

        }


        .notification:last-child {

            border-bottom:
                none;

        }


        .notification:hover {

            background:
                #fafbfd;

        }


        .notification.unread {

            background:
                #eef5ff;

            border-left:
                5px solid #1268f3;

        }


        .notification-left {

            display:
                flex;

            gap:
                15px;

            flex:
                1;

        }


        .notification-symbol {

            width:
                45px;

            height:
                45px;

            min-width:
                45px;

            border-radius:
                10px;

            background:
                #e9f1ff;

            display:
                flex;

            align-items:
                center;

            justify-content:
                center;

            font-size:
                20px;

        }


        .notification-content {

            flex:
                1;

        }


        .notification-type {

            margin:
                0;

            color:
                #172033;

            font-size:
                15px;

        }


        .unread .notification-type {

            color:
                #1268f3;

        }


        .notification-message {

            margin:
                7px 0 0;

            color:
                #667085;

            font-size:
                13px;

            line-height:
                1.6;

        }


        /* =====================================================
           MARK READ
           ===================================================== */

        .read-form {

            margin:
                0;

        }


        .read-button {

            padding:
                8px 13px;

            background:
                white;

            border:
                1px solid #1268f3;

            border-radius:
                6px;

            color:
                #1268f3;

            font-size:
                11px;

            font-weight:
                bold;

            cursor:
                pointer;

            white-space:
                nowrap;

        }


        .read-button:hover {

            background:
                #1268f3;

            color:
                white;

        }


        /* =====================================================
           EMPTY STATE
           ===================================================== */

        .empty {

            padding:
                70px 20px;

            text-align:
                center;

        }


        .empty-icon {

            font-size:
                55px;

            margin-bottom:
                15px;

        }


        .empty h3 {

            margin:
                0;

            font-size:
                20px;

            color:
                #172033;

        }


        .empty p {

            margin-top:
                10px;

            color:
                #7a8495;

            font-size:
                13px;

        }


        /* =====================================================
           QUICK LINKS
           ===================================================== */

        .quick-links {

            margin-top:
                25px;

            display:
                grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap:
                15px;

        }


        .quick-link {

            padding:
                18px;

            background:
                white;

            border:
                1px solid #e4e9f0;

            border-radius:
                10px;

            text-decoration:
                none;

            color:
                #172033;

            text-align:
                center;

            font-size:
                12px;

            font-weight:
                bold;

            transition:
                .2s ease;

        }


        .quick-link:hover {

            border-color:
                #1268f3;

            color:
                #1268f3;

            transform:
                translateY(-2px);

        }


        /* =====================================================
           FOOTER
           ===================================================== */

        .footer {

            width:
                100%;

            padding:
                22px 5%;

            background:
                #172033;

            color:
                #aeb7c7;

            text-align:
                center;

            font-size:
                11px;

        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 900px) {

            .notification {

                flex-direction:
                    column;

            }


            .read-form {

                margin-left:
                    60px;

            }


            .quick-links {

                grid-template-columns:
                    repeat(2, 1fr);

            }

        }


        @media (max-width: 650px) {

            .header {

                padding:
                    13px 20px;

            }


            .brand-name {

                font-size:
                    18px;

            }


            .brand-subtitle {

                display:
                    none;

            }


            .user-name {

                display:
                    none;

            }


            .nav {

                padding:
                    10px 15px;

            }


            .nav a {

                padding:
                    8px 10px;

                font-size:
                    11px;

            }


            .main {

                padding:
                    20px 15px 40px;

            }


            .page-header {

                padding:
                    25px;

            }


            .page-header h1 {

                font-size:
                    24px;

            }


            .notification-icon {

                display:
                    none;

            }


            .card {

                padding:
                    18px;

            }


            .card-top {

                flex-direction:
                    column;

                align-items:
                    flex-start;

            }


            .read-all-button {

                width:
                    100%;

            }


            .notification {

                padding:
                    18px 10px;

            }


            .quick-links {

                grid-template-columns:
                    1fr 1fr;

            }

        }


        @media (max-width: 400px) {

            .quick-links {

                grid-template-columns:
                    1fr;

            }

        }

    </style>

</head>


<body>


<div class="page">


    <!-- =================================================
         HEADER
         ================================================= -->

    <header class="header">


        <div class="brand">


            <img
                src="images/wallet-logo.png"
                class="brand-logo"
                alt="Digital Wallet">


            <div>

                <div class="brand-name">

                    Digital Wallet

                </div>


                <div class="brand-subtitle">

                    Personal Finance Management System

                </div>

            </div>


        </div>


        <div class="profile-area">


            <span class="user-name">

                👤 <%=user.getName()%>

            </span>


            <a
                href="<%=request.getContextPath()%>/logout"
                class="logout">

                Logout

            </a>


        </div>


    </header>


    <!-- =================================================
         NAVIGATION
         ================================================= -->

    <nav class="nav">


        <a
            href="<%=request.getContextPath()%>/dashboard">

            🏠 Dashboard

        </a>


        <a
            href="<%=request.getContextPath()%>/wallet.jsp">

            💳 Wallet

        </a>


        <a
            href="<%=request.getContextPath()%>/expenses">

            💸 Expenses

        </a>


        <a
            href="<%=request.getContextPath()%>/transactions">

            💰 Transactions

        </a>


        <a
            href="<%=request.getContextPath()%>/budget">

            📋 Budget

        </a>


        <a
            href="<%=request.getContextPath()%>/goals">

            🎯 Goals

        </a>


        <a
            href="<%=request.getContextPath()%>/reports">

            📊 Reports

        </a>


        <a
            href="<%=request.getContextPath()%>/notifications"
            class="active">

            🔔 Notifications

        </a>


        <a
            href="<%=request.getContextPath()%>/profile">

            👤 Profile

        </a>


    </nav>


    <!-- =================================================
         MAIN CONTENT
         ================================================= -->

    <main class="main">


        <div class="content">


            <!-- PAGE HEADER -->

            <div class="page-header">


                <div>

                    <h1>

                        🔔 Notifications

                    </h1>


                    <p>

                        Stay updated with your wallet
                        and financial activity.

                    </p>

                </div>


                <div class="notification-icon">

                    🔔

                </div>


            </div>


            <!-- NOTIFICATION CARD -->

            <div class="card">


                <div class="card-top">


                    <div>

                        <h2 class="card-title">

                            Your Notifications

                        </h2>


                        <div class="card-subtitle">

                            Review your latest account
                            and transaction updates.

                        </div>

                    </div>


                    <form
                        action="<%=request.getContextPath()%>/notifications"
                        method="post">


                        <input
                            type="hidden"
                            name="action"
                            value="readAll">


                        <button
                            type="submit"
                            class="read-all-button">

                            ✓ Mark All as Read

                        </button>


                    </form>


                </div>


                <div class="divider"></div>


                <%

                if (notifications != null &&
                    !notifications.isEmpty()) {


                    for (Notification n : notifications) {

                %>


                <!-- NOTIFICATION ITEM -->

                <div class="notification
                    <%=!n.isRead() ? "unread" : ""%>">


                    <div class="notification-left">


                        <div class="notification-symbol">

                            <%

                            if (!n.isRead()) {

                            %>

                            🔔

                            <%

                            } else {

                            %>

                            ✓

                            <%

                            }

                            %>

                        </div>


                        <div class="notification-content">


                            <h3 class="notification-type">

                                <%=n.getType()%>

                            </h3>


                            <p class="notification-message">

                                <%=n.getMessage()%>

                            </p>


                        </div>


                    </div>


                    <%

                    if (!n.isRead()) {

                    %>


                    <form
                        action="<%=request.getContextPath()%>/notifications"
                        method="post"
                        class="read-form">


                        <input
                            type="hidden"
                            name="action"
                            value="read">


                        <input
                            type="hidden"
                            name="id"
                            value="<%=n.getId()%>">


                        <button
                            type="submit"
                            class="read-button">

                            ✓ Mark as Read

                        </button>


                    </form>


                    <%

                    }

                    %>


                </div>


                <%

                    }

                } else {

                %>


                <!-- EMPTY STATE -->

                <div class="empty">


                    <div class="empty-icon">

                        🎉

                    </div>


                    <h3>

                        You're All Caught Up!

                    </h3>


                    <p>

                        You currently have no new
                        notifications.

                    </p>


                </div>


                <%

                }

                %>


            </div>


            <!-- QUICK LINKS -->

            <div class="quick-links">


                <a
                    href="<%=request.getContextPath()%>/dashboard"
                    class="quick-link">

                    🏠 Dashboard

                </a>


                <a
                    href="<%=request.getContextPath()%>/transactions"
                    class="quick-link">

                    💰 Transactions

                </a>


                <a
                    href="<%=request.getContextPath()%>/budget"
                    class="quick-link">

                    📋 Budget

                </a>


                <a
                    href="<%=request.getContextPath()%>/reports"
                    class="quick-link">

                    📊 Reports

                </a>


            </div>


        </div>


    </main>


    <!-- =================================================
         FOOTER
         ================================================= -->

    <footer class="footer">

        © 2026 Digital Wallet
        &nbsp; | &nbsp;
        Personal Finance Management System

    </footer>


</div>


</body>

</html>