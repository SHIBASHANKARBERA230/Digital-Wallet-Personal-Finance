<%@ page contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.Map" %>
<%@ page import="com.wallet.model.User" %>

<%
    /*
     * Get logged-in user
     */
    User user =
            (User) session.getAttribute("user");

    /*
     * Security check
     */
    if (user == null) {

        response.sendRedirect(
                request.getContextPath()
                        + "/login.jsp");

        return;
    }

    /*
     * Dashboard summary
     */
    Map<String, Object> summary =
            (Map<String, Object>)
                    request.getAttribute("summary");

    /*
     * Error message
     */
    String error =
            (String) request.getAttribute("error");

    /*
     * Safely read summary values
     */
    Object balance =
            summary != null
                    ? summary.get("balance")
                    : null;

    Object totalIncome =
            summary != null
                    ? summary.get("totalIncome")
                    : null;

    Object totalExpense =
            summary != null
                    ? summary.get("totalExpense")
                    : null;

    Object transactionCount =
            summary != null
                    ? summary.get("transactionCount")
                    : null;

    /*
     * Default values
     */
    String balanceText =
            balance != null
                    ? String.format(
                            "%.2f",
                            Double.parseDouble(
                                    balance.toString()))
                    : "0.00";

    String incomeText =
            totalIncome != null
                    ? String.format(
                            "%.2f",
                            Double.parseDouble(
                                    totalIncome.toString()))
                    : "0.00";

    String expenseText =
            totalExpense != null
                    ? String.format(
                            "%.2f",
                            Double.parseDouble(
                                    totalExpense.toString()))
                    : "0.00";

    String transactionText =
            transactionCount != null
                    ? transactionCount.toString()
                    : "0";
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Dashboard - Digital Wallet</title>

    <style>

        /* =========================================
           GLOBAL
           ========================================= */

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
        }

        body {

            background:
                #f4f7fb;

            color:
                #172033;
        }

        /* =========================================
           MAIN CONTAINER
           FULL SCREEN WIDTH
           ========================================= */

        .container {

            width: 100%;

            max-width: none;

            min-height: 100vh;

            margin: 0;

            background:
                white;

            box-shadow:
                none;
        }

        /* =========================================
           HEADER
           ========================================= */

        .header {

            width: 100%;

            background:
                linear-gradient(
                    135deg,
                    #1268f3,
                    #0753cf
                );

            color:
                white;

            padding:
                24px 5%;

            display:
                flex;

            justify-content:
                space-between;

            align-items:
                center;

            min-height:
                110px;
        }

        .logo-area {

            display:
                flex;

            align-items:
                center;

            gap:
                15px;
        }

        .logo {

            width:
                58px;

            height:
                58px;

            object-fit:
                contain;

            background:
                white;

            padding:
                5px;

            border-radius:
                13px;
        }

        .logo-title {

            font-size:
                27px;

            font-weight:
                bold;

            letter-spacing:
                0.2px;
        }

        .logo-subtitle {

            font-size:
                13px;

            margin-top:
                5px;

            opacity:
                0.92;
        }

        .welcome {

            text-align:
                right;

            font-size:
                13px;

            line-height:
                1.4;
        }

        .welcome-name {

            font-size:
                17px;

            font-weight:
                bold;

            margin-top:
                4px;
        }

        /* =========================================
           NAVIGATION
           ========================================= */

        .nav {

            width:
                100%;

            display:
                flex;

            background:
                white;

            border-bottom:
                1px solid #e5e9f2;

            box-shadow:
                0 2px 8px
                rgba(0,0,0,0.03);
        }

        .nav a {

            flex:
                1;

            text-align:
                center;

            padding:
                16px 12px;

            text-decoration:
                none;

            color:
                #53627a;

            font-size:
                14px;

            border-right:
                1px solid #edf0f5;

            transition:
                0.2s ease;
        }

        .nav a:last-child {

            border-right:
                none;
        }

        .nav a:hover {

            background:
                #eef4ff;

            color:
                #1268f3;
        }

        .nav .active {

            color:
                #1268f3;

            font-weight:
                bold;

            background:
                #eef4ff;

            box-shadow:
                inset 0 -3px 0
                #1268f3;
        }

        .logout {

            color:
                #e53935 !important;
        }

        .logout:hover {

            background:
                #fff3f3 !important;

            color:
                #d32f2f !important;
        }

        /* =========================================
           MAIN CONTENT
           ========================================= */

        .content {

            width:
                100%;

            max-width:
                1800px;

            margin:
                0 auto;

            padding:
                38px 5%;
        }

        .page-title {

            font-size:
                31px;

            margin:
                0 0 8px 0;

            color:
                #172033;
        }

        .page-subtitle {

            color:
                #68758a;

            margin-bottom:
                30px;

            font-size:
                15px;

            line-height:
                1.6;
        }

        /* =========================================
           ERROR
           ========================================= */

        .error {

            background:
                #fff0f0;

            color:
                #c62828;

            border:
                1px solid #ffcdd2;

            padding:
                14px 16px;

            border-radius:
                8px;

            margin-bottom:
                20px;
        }

        /* =========================================
           SUMMARY CARDS
           ========================================= */

        .cards {

            width:
                100%;

            display:
                grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap:
                20px;

            margin-bottom:
                30px;
        }

        .card {

            min-width:
                0;

            padding:
                24px;

            border:
                1px solid #e4e9f2;

            border-radius:
                13px;

            background:
                white;

            box-shadow:
                0 4px 14px
                rgba(0,0,0,0.05);

            transition:
                0.2s ease;
        }

        .card:hover {

            transform:
                translateY(-2px);

            box-shadow:
                0 7px 20px
                rgba(0,0,0,0.08);
        }

        .card-title {

            color:
                #6b778c;

            font-size:
                13px;

            margin-bottom:
                11px;

            font-weight:
                500;
        }

        .card-value {

            font-size:
                27px;

            font-weight:
                bold;

            color:
                #172033;

            word-break:
                break-word;
        }

        .balance {

            border-left:
                5px solid #1268f3;
        }

        .income {

            border-left:
                5px solid #16a34a;
        }

        .expense {

            border-left:
                5px solid #ef4444;
        }

        .transactions {

            border-left:
                5px solid #9333ea;
        }

        /* =========================================
           SECTIONS
           ========================================= */

        .section {

            width:
                100%;

            border:
                1px solid #e4e9f2;

            border-radius:
                13px;

            margin-bottom:
                25px;

            overflow:
                hidden;

            background:
                white;

            box-shadow:
                0 3px 12px
                rgba(0,0,0,0.03);
        }

        .section-header {

            background:
                #f8fafc;

            padding:
                20px 25px;

            border-bottom:
                1px solid #e4e9f2;
        }

        .section-header h3 {

            margin:
                0;

            font-size:
                19px;
        }

        .section-header p {

            margin:
                6px 0 0;

            color:
                #718096;

            font-size:
                13px;
        }

        /* =========================================
           QUICK ACTIONS
           ========================================= */

        .actions {

            width:
                100%;

            padding:
                25px;

            display:
                grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap:
                18px;
        }

        .action {

            min-width:
                0;

            text-decoration:
                none;

            padding:
                21px;

            border:
                1px solid #dfe5ef;

            border-radius:
                11px;

            color:
                #172033;

            background:
                white;

            transition:
                0.2s ease;
        }

        .action:hover {

            background:
                #eef4ff;

            border-color:
                #1268f3;

            transform:
                translateY(-3px);

            box-shadow:
                0 6px 16px
                rgba(18,104,243,0.10);
        }

        .action-icon {

            font-size:
                27px;

            line-height:
                1;
        }

        .action-title {

            font-weight:
                bold;

            margin-top:
                10px;

            font-size:
                15px;
        }

        .action-description {

            color:
                #718096;

            font-size:
                12px;

            margin-top:
                6px;

            line-height:
                1.5;
        }

        /* =========================================
           FOOTER
           ========================================= */

        .footer {

            width:
                100%;

            text-align:
                center;

            padding:
                25px;

            color:
                #8993a4;

            font-size:
                12px;

            border-top:
                1px solid #e8ecf2;

            background:
                #fafbfd;
        }

        /* =========================================
           LARGE SCREENS
           ========================================= */

        @media(min-width: 1600px) {

            .content {

                padding:
                    42px 60px;
            }

            .header {

                padding:
                    27px 60px;
            }

            .cards {

                gap:
                    24px;
            }

            .card {

                padding:
                    27px;
            }

            .actions {

                gap:
                    20px;
            }
        }

        /* =========================================
           TABLET
           ========================================= */

        @media(max-width: 1000px) {

            .content {

                padding:
                    30px 30px;
            }

            .header {

                padding:
                    22px 30px;
            }

            .cards {

                grid-template-columns:
                    repeat(2, 1fr);
            }

            .actions {

                grid-template-columns:
                    repeat(2, 1fr);
            }
        }

        /* =========================================
           MOBILE
           ========================================= */

        @media(max-width: 700px) {

            .header {

                flex-direction:
                    column;

                gap:
                    15px;

                text-align:
                    center;

                padding:
                    22px 20px;
            }

            .logo-area {

                justify-content:
                    center;
            }

            .welcome {

                text-align:
                    center;
            }

            .nav {

                flex-wrap:
                    wrap;
            }

            .nav a {

                flex:
                    1 1 33.33%;

                padding:
                    13px 8px;

                font-size:
                    12px;
            }

            .content {

                padding:
                    25px 20px;
            }

            .page-title {

                font-size:
                    26px;
            }

            .cards {

                grid-template-columns:
                    1fr;

                gap:
                    15px;
            }

            .actions {

                grid-template-columns:
                    1fr;

                padding:
                    18px;

                gap:
                    14px;
            }
        }

        /* =========================================
           SMALL MOBILE
           ========================================= */

        @media(max-width: 450px) {

            .logo {

                width:
                    50px;

                height:
                    50px;
            }

            .logo-title {

                font-size:
                    22px;
            }

            .logo-subtitle {

                font-size:
                    11px;
            }

            .nav a {

                flex:
                    1 1 50%;
            }

            .content {

                padding:
                    20px 15px;
            }

            .card {

                padding:
                    20px;
            }

            .section-header {

                padding:
                    18px;
            }

            .actions {

                padding:
                    15px;
            }
        }

    </style>

</head>

<body>

<div class="container">

    <!-- =========================================
         HEADER
         ========================================= -->

    <div class="header">

        <div class="logo-area">

            <img
                src="images/wallet-logo.png"
                class="logo"
                alt="Digital Wallet">

            <div>

                <div class="logo-title">
                    Digital Wallet
                </div>

                <div class="logo-subtitle">
                    Personal Finance Management System
                </div>

            </div>

        </div>

        <div class="welcome">

            Welcome back 👋

            <div class="welcome-name">
                <%= user.getName() %>
            </div>

        </div>

    </div>


    <!-- =========================================
         NAVIGATION
         ========================================= -->

    <div class="nav">

        <a
            href="<%= request.getContextPath() %>/dashboard"
            class="active">

            🏠 Dashboard

        </a>

        <a
            href="<%= request.getContextPath() %>/wallet.jsp">

            💳 Wallet

        </a>

        <a
            href="<%= request.getContextPath() %>/expenses.jsp">

            💸 Expenses

        </a>

        <a
            href="<%= request.getContextPath() %>/transactions">

            📊 Transactions

        </a>

        <a
            href="<%= request.getContextPath() %>/logout"
            class="logout">

            🚪 Logout

        </a>

    </div>


    <!-- =========================================
         CONTENT
         ========================================= -->

    <div class="content">

        <h1 class="page-title">
            Dashboard
        </h1>

        <div class="page-subtitle">

            Welcome to your personal finance dashboard.
            Manage your money smarter and keep track
            of your financial activities.

        </div>


        <!-- ERROR -->

        <% if (error != null) { %>

            <div class="error">

                ⚠️ <%= error %>

            </div>

        <% } %>


        <!-- =====================================
             SUMMARY CARDS
             ===================================== -->

        <div class="cards">


            <!-- BALANCE -->

            <div class="card balance">

                <div class="card-title">
                    💳 WALLET BALANCE
                </div>

                <div class="card-value">

                    ₹ <%= balanceText %>

                </div>

            </div>


            <!-- INCOME -->

            <div class="card income">

                <div class="card-title">
                    📈 TOTAL INCOME
                </div>

                <div class="card-value">

                    ₹ <%= incomeText %>

                </div>

            </div>


            <!-- EXPENSE -->

            <div class="card expense">

                <div class="card-title">
                    📉 TOTAL EXPENSE
                </div>

                <div class="card-value">

                    ₹ <%= expenseText %>

                </div>

            </div>


            <!-- TRANSACTIONS -->

            <div class="card transactions">

                <div class="card-title">
                    🔄 TRANSACTIONS
                </div>

                <div class="card-value">

                    <%= transactionText %>

                </div>

            </div>

        </div>


        <!-- =====================================
             QUICK ACTIONS
             ===================================== -->

        <div class="section">

            <div class="section-header">

                <h3>
                    ⚡ Quick Actions
                </h3>

                <p>
                    Access your most frequently used
                    wallet features.
                </p>

            </div>


            <div class="actions">


                <!-- WALLET -->

                <a
                    href="<%= request.getContextPath() %>/wallet.jsp"
                    class="action">

                    <div class="action-icon">
                        💳
                    </div>

                    <div class="action-title">
                        Manage Wallet
                    </div>

                    <div class="action-description">
                        Add or withdraw money from your wallet.
                    </div>

                </a>


                <!-- EXPENSE -->

                <a
                    href="<%= request.getContextPath() %>/expenses.jsp"
                    class="action">

                    <div class="action-icon">
                        💸
                    </div>

                    <div class="action-title">
                        Add Expense
                    </div>

                    <div class="action-description">
                        Record and manage your expenses.
                    </div>

                </a>


                <!-- TRANSACTIONS -->

                <a
                    href="<%= request.getContextPath() %>/transactions"
                    class="action">

                    <div class="action-icon">
                        📊
                    </div>

                    <div class="action-title">
                        Transactions
                    </div>

                    <div class="action-description">
                        View your complete transaction history.
                    </div>

                </a>


                <!-- BUDGET -->

                <a
                    href="<%= request.getContextPath() %>/budget.jsp"
                    class="action">

                    <div class="action-icon">
                        🎯
                    </div>

                    <div class="action-title">
                        Budget
                    </div>

                    <div class="action-description">
                        Set and manage your spending limits.
                    </div>

                </a>


                <!-- GOALS -->

                <a
                    href="<%= request.getContextPath() %>/goals.jsp"
                    class="action">

                    <div class="action-icon">
                        🏆
                    </div>

                    <div class="action-title">
                        Financial Goals
                    </div>

                    <div class="action-description">
                        Track your savings and financial goals.
                    </div>

                </a>


                <!-- REPORTS -->

                <a
                    href="<%= request.getContextPath() %>/reports.jsp"
                    class="action">

                    <div class="action-icon">
                        📈
                    </div>

                    <div class="action-title">
                        Reports
                    </div>

                    <div class="action-description">
                        Analyze your financial activity.
                    </div>

                </a>

            </div>

        </div>


        <!-- =====================================
             ACCOUNT & TOOLS
             ===================================== -->

        <div class="section">

            <div class="section-header">

                <h3>
                    🔧 Account &amp; Tools
                </h3>

                <p>
                    Manage your account and stay informed.
                </p>

            </div>

            <div class="actions">


                <!-- PROFILE -->

                <a
                    href="<%= request.getContextPath() %>/profile.jsp"
                    class="action">

                    <div class="action-icon">
                        👤
                    </div>

                    <div class="action-title">
                        My Profile
                    </div>

                    <div class="action-description">
                        View and update your profile.
                    </div>

                </a>


                <!-- NOTIFICATIONS -->

                <a
                    href="<%= request.getContextPath() %>/notifications.jsp"
                    class="action">

                    <div class="action-icon">
                        🔔
                    </div>

                    <div class="action-title">
                        Notifications
                    </div>

                    <div class="action-description">
                        View your latest notifications.
                    </div>

                </a>

            </div>

        </div>

    </div>


    <!-- =========================================
         FOOTER
         ========================================= -->

    <div class="footer">

        © 2026 Digital Wallet

        <br>

        Personal Finance Management System

    </div>

</div>

</body>

</html>