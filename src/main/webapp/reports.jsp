<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.Map" %>
<%@ page import="com.wallet.model.User" %>

<%
User user = (User) session.getAttribute("user");

if (user == null) {
    response.sendRedirect(
        request.getContextPath() + "/login.jsp"
    );
    return;
}

Map<String, Object> report =
        (Map<String, Object>)
        request.getAttribute("report");

double income = 0;
double expense = 0;
double transfer = 0;
double savings = 0;

if (report != null) {

    if (report.get("income") != null) {
        income =
            ((Number) report.get("income"))
            .doubleValue();
    }

    if (report.get("expense") != null) {
        expense =
            ((Number) report.get("expense"))
            .doubleValue();
    }

    if (report.get("transfer") != null) {
        transfer =
            ((Number) report.get("transfer"))
            .doubleValue();
    }

    if (report.get("savings") != null) {
        savings =
            ((Number) report.get("savings"))
            .doubleValue();
    }
}

double savingRate = 0;

if (income > 0) {
    savingRate = (savings / income) * 100;
}

double balance = income - expense;

String userName = user.getName();

if (userName == null || userName.trim().isEmpty()) {
    userName = "User";
}
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width,
               initial-scale=1.0">

<title>Financial Reports - Digital Wallet</title>


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

    display: flex;

    flex-direction: column;

}


/* =====================================================
   HEADER
   ===================================================== */

.header {

    width: 100%;

    min-height: 78px;

    padding:
        14px 5%;

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
        12px;

}


.brand-logo {

    width:
        48px;

    height:
        48px;

    object-fit:
        contain;

}


.brand-name {

    color:
        #1268f3;

    font-size:
        21px;

    font-weight:
        bold;

}


.brand-subtitle {

    margin-top:
        3px;

    color:
        #7a8495;

    font-size:
        10px;

}


.header-user {

    display:
        flex;

    align-items:
        center;

    gap:
        12px;

}


.user-avatar {

    width:
        38px;

    height:
        38px;

    border-radius:
        50%;

    background:
        #1268f3;

    color:
        white;

    display:
        flex;

    align-items:
        center;

    justify-content:
        center;

    font-size:
        15px;

    font-weight:
        bold;

}


.user-name {

    color:
        #344054;

    font-size:
        13px;

    font-weight:
        bold;

}


/* =====================================================
   NAVIGATION
   ===================================================== */

.nav {

    width: 100%;

    background:
        white;

    padding:
        0 5%;

    border-bottom:
        1px solid #e8ecf2;

    display:
        flex;

    align-items:
        center;

    gap:
        4px;

    overflow-x:
        auto;

}


.nav a {

    display:
        inline-block;

    padding:
        16px 14px;

    color:
        #667085;

    text-decoration:
        none;

    font-size:
        12px;

    font-weight:
        bold;

    white-space:
        nowrap;

    border-bottom:
        3px solid transparent;

}


.nav a:hover {

    color:
        #1268f3;

}


.nav a.active {

    color:
        #1268f3;

    border-bottom-color:
        #1268f3;

}


/* =====================================================
   MAIN
   ===================================================== */

.main {

    width:
        100%;

    flex:
        1;

    padding:
        35px 5% 55px;

}


.content {

    width:
        100%;

    max-width:
        1600px;

    margin:
        0 auto;

}


/* =====================================================
   PAGE INTRO
   ===================================================== */

.page-intro {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;

    gap:
        20px;

    margin-bottom:
        28px;

}


.page-title h1 {

    margin:
        0;

    font-size:
        30px;

    color:
        #172033;

}


.page-title p {

    margin:
        8px 0 0;

    color:
        #7a8495;

    font-size:
        13px;

}


.report-badge {

    padding:
        10px 15px;

    border-radius:
        8px;

    background:
        #eaf2ff;

    color:
        #1268f3;

    font-size:
        12px;

    font-weight:
        bold;

}


/* =====================================================
   SUMMARY CARDS
   ===================================================== */

.summary-grid {

    display:
        grid;

    grid-template-columns:
        repeat(4, 1fr);

    gap:
        20px;

}


.summary-card {

    background:
        white;

    border:
        1px solid #e7ebf1;

    border-radius:
        14px;

    padding:
        24px;

    box-shadow:
        0 5px 20px
        rgba(20, 40, 80, .05);

}


.summary-top {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;

    margin-bottom:
        18px;

}


.summary-icon {

    width:
        42px;

    height:
        42px;

    border-radius:
        10px;

    display:
        flex;

    align-items:
        center;

    justify-content:
        center;

    font-size:
        19px;

}


.income-icon {

    background:
        #e9f8ef;

}


.expense-icon {

    background:
        #ffeded;

}


.transfer-icon {

    background:
        #fff5df;

}


.savings-icon {

    background:
        #eaf2ff;

}


.summary-label {

    color:
        #7a8495;

    font-size:
        12px;

    font-weight:
        bold;

}


.amount {

    font-size:
        27px;

    font-weight:
        bold;

    color:
        #172033;

}


.income {

    color:
        #16834b;

}


.expense {

    color:
        #dc3545;

}


.transfer {

    color:
        #c27a00;

}


.savings {

    color:
        #1268f3;

}


/* =====================================================
   SECOND SECTION
   ===================================================== */

.analysis-grid {

    display:
        grid;

    grid-template-columns:
        1.4fr .8fr;

    gap:
        20px;

    margin-top:
        22px;

}


/* =====================================================
   FINANCIAL SUMMARY
   ===================================================== */

.card {

    background:
        white;

    border:
        1px solid #e7ebf1;

    border-radius:
        14px;

    padding:
        27px;

    box-shadow:
        0 5px 20px
        rgba(20, 40, 80, .05);

}


.card-title {

    margin:
        0;

    font-size:
        19px;

    color:
        #172033;

}


.card-subtitle {

    margin:
        7px 0 22px;

    color:
        #8a93a3;

    font-size:
        11px;

}


/* =====================================================
   SUMMARY ROWS
   ===================================================== */

.summary-row {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;

    padding:
        16px 0;

    border-bottom:
        1px solid #edf0f4;

}


.summary-row:last-child {

    border-bottom:
        none;

}


.summary-row-left {

    display:
        flex;

    align-items:
        center;

    gap:
        10px;

}


.row-dot {

    width:
        10px;

    height:
        10px;

    border-radius:
        50%;

}


.income-dot {

    background:
        #16834b;

}


.expense-dot {

    background:
        #dc3545;

}


.transfer-dot {

    background:
        #c27a00;

}


.savings-dot {

    background:
        #1268f3;

}


.summary-row-label {

    color:
        #596273;

    font-size:
        13px;

}


.summary-row-value {

    font-size:
        14px;

    font-weight:
        bold;

}


/* =====================================================
   BALANCE
   ===================================================== */

.balance-box {

    margin-top:
        22px;

    padding:
        20px;

    border-radius:
        10px;

    background:
        #f4f7fb;

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;

}


.balance-label {

    color:
        #667085;

    font-size:
        12px;

    font-weight:
        bold;

}


.balance-value {

    font-size:
        21px;

    font-weight:
        bold;

}


.positive {

    color:
        #16834b;

}


.negative {

    color:
        #dc3545;

}


/* =====================================================
   SAVINGS RATE
   ===================================================== */

.rate-card {

    display:
        flex;

    flex-direction:
        column;

    justify-content:
        center;

}


.rate-circle {

    width:
        150px;

    height:
        150px;

    border-radius:
        50%;

    margin:
        15px auto 20px;

    border:
        12px solid #eaf2ff;

    display:
        flex;

    align-items:
        center;

    justify-content:
        center;

    background:
        white;

}


.rate-value {

    font-size:
        28px;

    font-weight:
        bold;

    color:
        #1268f3;

}


.rate-text {

    text-align:
        center;

    color:
        #7a8495;

    font-size:
        12px;

    line-height:
        1.6;

}


/* =====================================================
   QUICK ACTIONS
   ===================================================== */

.actions {

    display:
        grid;

    grid-template-columns:
        repeat(4, 1fr);

    gap:
        15px;

    margin-top:
        22px;

}


.action {

    display:
        flex;

    align-items:
        center;

    gap:
        10px;

    padding:
        16px;

    background:
        white;

    border:
        1px solid #e7ebf1;

    border-radius:
        10px;

    color:
        #344054;

    text-decoration:
        none;

    font-size:
        12px;

    font-weight:
        bold;

}


.action:hover {

    border-color:
        #1268f3;

    color:
        #1268f3;

}


.action-icon {

    width:
        35px;

    height:
        35px;

    border-radius:
        8px;

    background:
        #eaf2ff;

    display:
        flex;

    align-items:
        center;

    justify-content:
        center;

}


/* =====================================================
   FOOTER
   ===================================================== */

.footer {

    width:
        100%;

    padding:
        23px 5%;

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

@media (max-width: 1100px) {

    .summary-grid {

        grid-template-columns:
            repeat(2, 1fr);

    }


    .actions {

        grid-template-columns:
            repeat(2, 1fr);

    }

}


@media (max-width: 850px) {

    .analysis-grid {

        grid-template-columns:
            1fr;

    }


    .page-intro {

        align-items:
            flex-start;

        flex-direction:
            column;

    }

}


@media (max-width: 600px) {

    .header {

        padding:
            13px 20px;

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
            0 15px;

    }


    .main {

        padding:
            25px 15px 40px;

    }


    .summary-grid {

        grid-template-columns:
            1fr;

    }


    .actions {

        grid-template-columns:
            1fr;

    }


    .page-title h1 {

        font-size:
            25px;

    }


    .summary-card {

        padding:
            20px;

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
                alt="Digital Wallet Logo">


            <div>

                <div class="brand-name">

                    Digital Wallet

                </div>


                <div class="brand-subtitle">

                    Personal Finance Management System

                </div>

            </div>


        </div>


        <div class="header-user">


            <div class="user-avatar">

                <%=userName.substring(0, 1).toUpperCase()%>

            </div>


            <div class="user-name">

                <%=userName%>

            </div>


        </div>


    </header>


    <!-- =================================================
         NAVIGATION
         ================================================= -->

    <nav class="nav">


        <a href="<%=request.getContextPath()%>/dashboard">

            🏠 Dashboard

        </a>


        <a href="<%=request.getContextPath()%>/wallet.jsp">

            💳 Wallet

        </a>


        <a href="<%=request.getContextPath()%>/expenses">

            💸 Expenses

        </a>


        <a href="<%=request.getContextPath()%>/transactions">

            🔄 Transactions

        </a>


        <a href="<%=request.getContextPath()%>/budget">

            💰 Budget

        </a>


        <a href="<%=request.getContextPath()%>/goals">

            🎯 Goals

        </a>


        <a
            href="<%=request.getContextPath()%>/reports"
            class="active">

            📊 Reports

        </a>


        <a href="<%=request.getContextPath()%>/notifications">

            🔔 Notifications

        </a>


        <a href="<%=request.getContextPath()%>/profile">

            👤 Profile

        </a>


        <a href="<%=request.getContextPath()%>/logout">

            🚪 Logout

        </a>


    </nav>


    <!-- =================================================
         MAIN
         ================================================= -->

    <main class="main">


        <div class="content">


            <!-- PAGE INTRO -->

            <div class="page-intro">


                <div class="page-title">


                    <h1>

                        📊 Financial Reports

                    </h1>


                    <p>

                        Your complete financial overview
                        and savings analysis.

                    </p>


                </div>


                <div class="report-badge">

                    📈 Financial Overview

                </div>


            </div>


            <!-- =================================================
                 SUMMARY CARDS
                 ================================================= -->

            <div class="summary-grid">


                <!-- INCOME -->

                <div class="summary-card">


                    <div class="summary-top">


                        <div class="summary-label">

                            TOTAL INCOME

                        </div>


                        <div class="summary-icon income-icon">

                            📈

                        </div>


                    </div>


                    <div class="amount income">

                        ₹ <%=String.format("%.2f", income)%>

                    </div>


                </div>


                <!-- EXPENSE -->

                <div class="summary-card">


                    <div class="summary-top">


                        <div class="summary-label">

                            TOTAL EXPENSES

                        </div>


                        <div class="summary-icon expense-icon">

                            📉

                        </div>


                    </div>


                    <div class="amount expense">

                        ₹ <%=String.format("%.2f", expense)%>

                    </div>


                </div>


                <!-- TRANSFER -->

                <div class="summary-card">


                    <div class="summary-top">


                        <div class="summary-label">

                            TRANSFERS

                        </div>


                        <div class="summary-icon transfer-icon">

                            💸

                        </div>


                    </div>


                    <div class="amount transfer">

                        ₹ <%=String.format("%.2f", transfer)%>

                    </div>


                </div>


                <!-- SAVINGS -->

                <div class="summary-card">


                    <div class="summary-top">


                        <div class="summary-label">

                            SAVINGS

                        </div>


                        <div class="summary-icon savings-icon">

                            💰

                        </div>


                    </div>


                    <div class="amount savings">

                        ₹ <%=String.format("%.2f", savings)%>

                    </div>


                </div>


            </div>


            <!-- =================================================
                 ANALYSIS
                 ================================================= -->

            <div class="analysis-grid">


                <!-- FINANCIAL SUMMARY -->

                <div class="card">


                    <h2 class="card-title">

                        Financial Summary

                    </h2>


                    <p class="card-subtitle">

                        Breakdown of your current financial activity.

                    </p>


                    <!-- INCOME -->

                    <div class="summary-row">


                        <div class="summary-row-left">


                            <span class="row-dot income-dot"></span>


                            <span class="summary-row-label">

                                Total Income

                            </span>


                        </div>


                        <span class="summary-row-value income">

                            ₹ <%=String.format("%.2f", income)%>

                        </span>


                    </div>


                    <!-- EXPENSE -->

                    <div class="summary-row">


                        <div class="summary-row-left">


                            <span class="row-dot expense-dot"></span>


                            <span class="summary-row-label">

                                Total Expenses

                            </span>


                        </div>


                        <span class="summary-row-value expense">

                            ₹ <%=String.format("%.2f", expense)%>

                        </span>


                    </div>


                    <!-- TRANSFER -->

                    <div class="summary-row">


                        <div class="summary-row-left">


                            <span class="row-dot transfer-dot"></span>


                            <span class="summary-row-label">

                                Total Transfers

                            </span>


                        </div>


                        <span class="summary-row-value transfer">

                            ₹ <%=String.format("%.2f", transfer)%>

                        </span>


                    </div>


                    <!-- SAVINGS -->

                    <div class="summary-row">


                        <div class="summary-row-left">


                            <span class="row-dot savings-dot"></span>


                            <span class="summary-row-label">

                                Total Savings

                            </span>


                        </div>


                        <span class="summary-row-value savings">

                            ₹ <%=String.format("%.2f", savings)%>

                        </span>


                    </div>


                    <!-- BALANCE -->

                    <div class="balance-box">


                        <span class="balance-label">

                            INCOME AFTER EXPENSES

                        </span>


                        <span class="balance-value
                            <%=balance >= 0
                                ? "positive"
                                : "negative"%>">

                            ₹ <%=String.format("%.2f", balance)%>

                        </span>


                    </div>


                </div>


                <!-- SAVINGS RATE -->

                <div class="card rate-card">


                    <h2 class="card-title">

                        Savings Rate

                    </h2>


                    <p class="card-subtitle">

                        Savings compared with total income.

                    </p>


                    <div class="rate-circle">


                        <div class="rate-value">

                            <%=String.format("%.1f", savingRate)%>%

                        </div>


                    </div>


                    <div class="rate-text">

                        Your current savings rate
                        based on the available
                        financial report data.

                    </div>


                </div>


            </div>


            <!-- =================================================
                 QUICK ACTIONS
                 ================================================= -->

            <div class="actions">


                <a
                    class="action"
                    href="<%=request.getContextPath()%>/transactions">


                    <span class="action-icon">

                        🔄

                    </span>


                    View Transactions


                </a>


                <a
                    class="action"
                    href="<%=request.getContextPath()%>/expenses">


                    <span class="action-icon">

                        💸

                    </span>


                    Manage Expenses


                </a>


                <a
                    class="action"
                    href="<%=request.getContextPath()%>/budget">


                    <span class="action-icon">

                        💰

                    </span>


                    Manage Budget


                </a>


                <a
                    class="action"
                    href="<%=request.getContextPath()%>/goals">


                    <span class="action-icon">

                        🎯

                    </span>


                    View Goals


                </a>


            </div>


        </div>


    </main>


    <!-- =================================================
         FOOTER
         ================================================= -->

    <footer class="footer">

        🔒 Secure
        &nbsp;&nbsp; | &nbsp;&nbsp;
        💳 Easy to Use
        &nbsp;&nbsp; | &nbsp;&nbsp;
        📊 Finance Management

        <br><br>

        © 2026 Digital Wallet

        <br>

        Personal Finance Management System

    </footer>


</div>


</body>

</html>