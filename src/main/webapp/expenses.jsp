<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.wallet.model.User" %>
<%@ page import="com.wallet.model.Expense" %>

<%
    /* =====================================================
       USER SESSION
       ===================================================== */

    User user =
            (User) session.getAttribute("user");

    if (user == null) {

        response.sendRedirect(
                request.getContextPath()
                        + "/login.jsp");

        return;
    }


    /* =====================================================
       EXPENSE DATA
       ===================================================== */

    List<Expense> expenses =
            (List<Expense>)
                    request.getAttribute("expenses");


    /* =====================================================
       SUCCESS / ERROR MESSAGE
       ===================================================== */

    String message =
            (String) session.getAttribute(
                    "expenseMessage");

    String error =
            (String) session.getAttribute(
                    "expenseError");

    session.removeAttribute("expenseMessage");
    session.removeAttribute("expenseError");
%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width,
                   initial-scale=1.0">

    <title>
        Expenses - Digital Wallet
    </title>


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

}

body {

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
   MAIN APPLICATION
   ===================================================== */

.container {

    width: 100%;

    min-height: 100vh;

    margin: 0;

    background:
        #ffffff;

}


/* =====================================================
   HEADER
   ===================================================== */

.header {

    width: 100%;

    min-height: 115px;

    padding:
        25px 5%;

    background:
        linear-gradient(
            135deg,
            #1268f3,
            #0753cf
        );

    color:
        white;

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;

}


.header-left {

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

    background:
        white;

    border-radius:
        13px;

    padding:
        6px;

    object-fit:
        contain;

}


.header-title {

    font-size:
        27px;

    font-weight:
        bold;

}


.header-subtitle {

    margin-top:
        5px;

    font-size:
        13px;

    opacity:
        .92;

}


.welcome {

    text-align:
        right;

    font-size:
        13px;

}


.welcome-name {

    margin-top:
        5px;

    font-size:
        17px;

    font-weight:
        bold;

}


/* =====================================================
   NAVIGATION
   ===================================================== */

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
        rgba(0,0,0,.03);

}


.nav a {

    flex:
        1;

    padding:
        16px 10px;

    text-align:
        center;

    text-decoration:
        none;

    color:
        #53627a;

    font-size:
        14px;

    border-right:
        1px solid #edf0f5;

    transition:
        .2s ease;

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

    background:
        #eef4ff;

    color:
        #1268f3;

    font-weight:
        bold;

    box-shadow:
        inset 0 -3px 0
        #1268f3;

}


.logout {

    color:
        #d93025 !important;

}


.logout:hover {

    background:
        #fff3f3 !important;

    color:
        #c5221f !important;

}


/* =====================================================
   CONTENT
   ===================================================== */

.content {

    width:
        100%;

    max-width:
        1800px;

    margin:
        0 auto;

    padding:
        40px 5%;

}


.page-heading {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;

    margin-bottom:
        30px;

}


.page-title {

    margin:
        0;

    font-size:
        31px;

    color:
        #172033;

}


.page-subtitle {

    margin:
        8px 0 0;

    color:
        #68758a;

    font-size:
        15px;

    line-height:
        1.6;

}


.page-icon {

    font-size:
        55px;

}


/* =====================================================
   MESSAGES
   ===================================================== */

.message {

    padding:
        14px 18px;

    border-radius:
        9px;

    margin-bottom:
        20px;

    font-size:
        14px;

    font-weight:
        500;

}


.success {

    background:
        #e8f8ef;

    color:
        #167342;

    border:
        1px solid #b9e8cb;

}


.error {

    background:
        #fdecec;

    color:
        #b42318;

    border:
        1px solid #f4bcbc;

}


/* =====================================================
   CARD
   ===================================================== */

.card {

    width:
        100%;

    margin-bottom:
        25px;

    background:
        #ffffff;

    border:
        1px solid #e4e9f2;

    border-radius:
        13px;

    box-shadow:
        0 4px 14px
        rgba(0,0,0,.05);

    overflow:
        hidden;

}


.card-header {

    padding:
        22px 28px;

    background:
        #f8fafc;

    border-bottom:
        1px solid #e5eaf2;

}


.card-title {

    margin:
        0;

    font-size:
        20px;

    color:
        #172033;

}


.card-description {

    margin:
        7px 0 0;

    color:
        #667085;

    font-size:
        13px;

}


.card-body {

    padding:
        30px;

}


/* =====================================================
   FORM
   ===================================================== */

.form-grid {

    display:
        grid;

    grid-template-columns:
        repeat(3, 1fr);

    gap:
        22px;

}


.form-group {

    width:
        100%;

}


.form-group label {

    display:
        block;

    margin-bottom:
        8px;

    font-size:
        13px;

    font-weight:
        bold;

    color:
        #344054;

}


input,
select {

    width:
        100%;

    height:
        48px;

    padding:
        10px 13px;

    border:
        1px solid #d0d5dd;

    border-radius:
        8px;

    background:
        #ffffff;

    color:
        #344054;

    font-size:
        14px;

    outline:
        none;

    transition:
        .2s ease;

}


input:focus,
select:focus {

    border-color:
        #1268f3;

    box-shadow:
        0 0 0 3px
        rgba(18,104,243,.10);

}


.form-button {

    margin-top:
        24px;

}


.primary-button {

    min-width:
        180px;

    height:
        45px;

    padding:
        0 20px;

    border:
        none;

    border-radius:
        8px;

    background:
        #1268f3;

    color:
        white;

    font-size:
        14px;

    font-weight:
        bold;

    cursor:
        pointer;

    transition:
        .2s ease;

}


.primary-button:hover {

    background:
        #0753cf;

    transform:
        translateY(-1px);

}


/* =====================================================
   TABLE
   ===================================================== */

.table-wrapper {

    width:
        100%;

    overflow-x:
        auto;

}


.expense-table {

    width:
        100%;

    border-collapse:
        collapse;

    min-width:
        700px;

}


.expense-table th {

    padding:
        15px;

    background:
        #f8fafc;

    border-bottom:
        1px solid #e5eaf2;

    color:
        #667085;

    font-size:
        12px;

    text-align:
        left;

    letter-spacing:
        .4px;

}


.expense-table td {

    padding:
        16px 15px;

    border-bottom:
        1px solid #eef1f5;

    color:
        #344054;

    font-size:
        14px;

}


.expense-table tbody tr:hover {

    background:
        #f9fbff;

}


.expense-id {

    color:
        #667085;

}


.category {

    font-weight:
        bold;

}


.amount {

    color:
        #d93025;

    font-weight:
        bold;

}


.date {

    color:
        #667085;

}


.delete-button {

    width:
        90px;

    height:
        36px;

    border:
        1px solid #f0b8b8;

    border-radius:
        7px;

    background:
        #fff5f5;

    color:
        #d93025;

    font-size:
        12px;

    font-weight:
        bold;

    cursor:
        pointer;

}


.delete-button:hover {

    background:
        #fdecec;

}


/* =====================================================
   EMPTY STATE
   ===================================================== */

.empty-state {

    padding:
        55px 20px;

    text-align:
        center;

}


.empty-icon {

    font-size:
        50px;

}


.empty-title {

    margin-top:
        15px;

    color:
        #344054;

    font-size:
        18px;

    font-weight:
        bold;

}


.empty-text {

    margin-top:
        8px;

    color:
        #667085;

    font-size:
        13px;

    line-height:
        1.6;

}


/* =====================================================
   QUICK ACTIONS
   ===================================================== */

.quick-actions {

    display:
        grid;

    grid-template-columns:
        repeat(3, 1fr);

    gap:
        18px;

}


.quick-action {

    padding:
        22px;

    text-align:
        center;

    border:
        1px solid #e1e7f0;

    border-radius:
        10px;

    text-decoration:
        none;

    background:
        #ffffff;

    transition:
        .2s ease;

}


.quick-action:hover {

    transform:
        translateY(-3px);

    box-shadow:
        0 6px 18px
        rgba(0,0,0,.07);

}


.quick-icon {

    font-size:
        30px;

}


.quick-title {

    margin-top:
        10px;

    color:
        #172033;

    font-size:
        14px;

    font-weight:
        bold;

}


/* =====================================================
   FOOTER
   ===================================================== */

.footer {

    width:
        100%;

    padding:
        25px;

    text-align:
        center;

    color:
        #8993a4;

    font-size:
        12px;

    border-top:
        1px solid #e8ecf2;

    background:
        #fafbfd;

}


/* =====================================================
   LARGE SCREEN
   ===================================================== */

@media (min-width: 1600px) {

    .header {

        padding:
            28px 60px;

    }

    .content {

        padding:
            45px 60px;

    }

}


/* =====================================================
   TABLET
   ===================================================== */

@media (max-width: 1000px) {

    .content {

        padding:
            30px;

    }

    .header {

        padding:
            22px 30px;

    }

    .form-grid {

        grid-template-columns:
            1fr 1fr;

    }

}


/* =====================================================
   MOBILE
   ===================================================== */

@media (max-width: 700px) {

    .header {

        flex-direction:
            column;

        gap:
            15px;

        text-align:
            center;

    }

    .header-left {

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
            13px 7px;

        font-size:
            12px;

    }

    .content {

        padding:
            25px 20px;

    }

    .page-heading {

        align-items:
            flex-start;

    }

    .page-title {

        font-size:
            26px;

    }

    .page-icon {

        font-size:
            40px;

    }

    .form-grid {

        grid-template-columns:
            1fr;

    }

    .card-body {

        padding:
            22px;

    }

    .quick-actions {

        grid-template-columns:
            1fr;

    }

}


/* =====================================================
   SMALL MOBILE
   ===================================================== */

@media (max-width: 450px) {

    .header-title {

        font-size:
            22px;

    }

    .header-subtitle {

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

    .card-header {

        padding:
            18px;

    }

    .card-body {

        padding:
            18px;

    }

}

</style>

</head>


<body>


<div class="container">


    <!-- =================================================
         HEADER
         ================================================= -->

    <div class="header">


        <div class="header-left">

            <img
                src="images/wallet-logo.png"
                class="logo"
                alt="Digital Wallet">


            <div>

                <div class="header-title">

                    Digital Wallet

                </div>


                <div class="header-subtitle">

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


    <!-- =================================================
         NAVIGATION
         ================================================= -->

    <div class="nav">


        <a href="<%= request.getContextPath() %>/dashboard">

            🏠 Dashboard

        </a>


        <a href="<%= request.getContextPath() %>/wallet.jsp">

            💳 Wallet

        </a>


        <a
            href="<%= request.getContextPath() %>/expenses"
            class="active">

            💸 Expenses

        </a>


        <a href="<%= request.getContextPath() %>/transactions">

            📊 Transactions

        </a>


        <a href="<%= request.getContextPath() %>/budget">

            💰 Budget

        </a>


        <a href="<%= request.getContextPath() %>/goals">

            🎯 Goals

        </a>


        <a
            href="<%= request.getContextPath() %>/logout"
            class="logout">

            🚪 Logout

        </a>


    </div>


    <!-- =================================================
         CONTENT
         ================================================= -->

    <div class="content">


        <!-- PAGE HEADING -->

        <div class="page-heading">


            <div>

                <h1 class="page-title">

                    Expense Management

                </h1>


                <p class="page-subtitle">

                    Keep track of your spending and manage
                    your personal expenses in one place.

                </p>

            </div>


            <div class="page-icon">

                💸

            </div>


        </div>


        <!-- =================================================
             SUCCESS MESSAGE
             ================================================= -->

        <% if (message != null) { %>

            <div class="message success">

                ✅ <%= message %>

            </div>

        <% } %>


        <!-- =================================================
             ERROR MESSAGE
             ================================================= -->

        <% if (error != null) { %>

            <div class="message error">

                ⚠️ <%= error %>

            </div>

        <% } %>


        <!-- =================================================
             ADD EXPENSE
             ================================================= -->

        <div class="card">


            <div class="card-header">

                <h2 class="card-title">

                    ➕ Add New Expense

                </h2>


                <p class="card-description">

                    Record your spending details below.

                </p>

            </div>


            <div class="card-body">


                <form
                    action="<%= request.getContextPath() %>/expenses"
                    method="post">


                    <input
                        type="hidden"
                        name="action"
                        value="add">


                    <div class="form-grid">


                        <!-- CATEGORY -->

                        <div class="form-group">

                            <label>

                                Category

                            </label>


                            <select
                                name="category"
                                required>

                                <option value="">

                                    Select expense category

                                </option>

                                <option value="Food">

                                    🍔 Food

                                </option>

                                <option value="Transport">

                                    🚗 Transport

                                </option>

                                <option value="Shopping">

                                    🛍 Shopping

                                </option>

                                <option value="Bills">

                                    🧾 Bills

                                </option>

                                <option value="Entertainment">

                                    🎬 Entertainment

                                </option>

                                <option value="Education">

                                    📚 Education

                                </option>

                                <option value="Health">

                                    ❤️ Health

                                </option>

                                <option value="Other">

                                    📌 Other

                                </option>

                            </select>

                        </div>


                        <!-- AMOUNT -->

                        <div class="form-group">

                            <label>

                                Amount

                            </label>


                            <input
                                type="number"
                                name="amount"
                                min="0.01"
                                step="0.01"
                                placeholder="Enter amount"
                                required>

                        </div>


                        <!-- DATE -->

                        <div class="form-group">

                            <label>

                                Expense Date

                            </label>


                            <input
                                type="date"
                                name="expenseDate"
                                required>

                        </div>


                    </div>


                    <div class="form-button">

                        <button
                            type="submit"
                            class="primary-button">

                            ➕ Add Expense

                        </button>

                    </div>


                </form>


            </div>

        </div>


        <!-- =================================================
             EXPENSE HISTORY
             ================================================= -->

        <div class="card">


            <div class="card-header">

                <h2 class="card-title">

                    📋 Expense History

                </h2>


                <p class="card-description">

                    Review all your recorded expenses.

                </p>

            </div>


            <div class="card-body">


                <div class="table-wrapper">


                    <table class="expense-table">


                        <thead>

                        <tr>

                            <th>
                                ID
                            </th>

                            <th>
                                CATEGORY
                            </th>

                            <th>
                                AMOUNT
                            </th>

                            <th>
                                DATE
                            </th>

                            <th>
                                ACTION
                            </th>

                        </tr>

                        </thead>


                        <tbody>


                        <%
                            if (expenses != null &&
                                !expenses.isEmpty()) {

                                for (Expense expense : expenses) {
                        %>


                        <tr>


                            <!-- ID -->

                            <td class="expense-id">

                                #<%= expense.getId() %>

                            </td>


                            <!-- CATEGORY -->

                            <td class="category">

                                <%= expense.getCategory() %>

                            </td>


                            <!-- AMOUNT -->

                            <td class="amount">

                                - ₹
                                <%= String.format(
                                        "%.2f",
                                        expense.getAmount()) %>

                            </td>


                            <!-- DATE -->

                            <td class="date">

                                <%= expense.getExpenseDate() %>

                            </td>


                            <!-- DELETE -->

                            <td>


                                <form
                                    action="<%= request.getContextPath() %>/expenses"
                                    method="post"
                                    style="margin:0;">


                                    <input
                                        type="hidden"
                                        name="action"
                                        value="delete">


                                    <input
                                        type="hidden"
                                        name="expenseId"
                                        value="<%= expense.getId() %>">


                                    <button
                                        type="submit"
                                        class="delete-button">

                                        🗑 Delete

                                    </button>


                                </form>


                            </td>


                        </tr>


                        <%
                                }

                            } else {
                        %>


                        <!-- EMPTY STATE -->

                        <tr>

                            <td
                                colspan="5">


                                <div class="empty-state">


                                    <div class="empty-icon">

                                        📭

                                    </div>


                                    <div class="empty-title">

                                        No Expenses Yet

                                    </div>


                                    <div class="empty-text">

                                        Your expense history will
                                        appear here after you add
                                        your first expense.

                                    </div>


                                </div>


                            </td>

                        </tr>


                        <%
                            }
                        %>


                        </tbody>


                    </table>


                </div>


            </div>

        </div>


        <!-- =================================================
             QUICK ACTIONS
             ================================================= -->

        <div class="card">


            <div class="card-header">

                <h2 class="card-title">

                    ⚡ Quick Actions

                </h2>


                <p class="card-description">

                    Quickly access other financial features.

                </p>

            </div>


            <div class="card-body">


                <div class="quick-actions">


                    <!-- DASHBOARD -->

                    <a
                        href="<%= request.getContextPath() %>/dashboard"
                        class="quick-action">

                        <div class="quick-icon">

                            🏠

                        </div>

                        <div class="quick-title">

                            Dashboard

                        </div>

                    </a>


                    <!-- WALLET -->

                    <a
                        href="<%= request.getContextPath() %>/wallet.jsp"
                        class="quick-action">

                        <div class="quick-icon">

                            💳

                        </div>

                        <div class="quick-title">

                            My Wallet

                        </div>

                    </a>


                    <!-- TRANSACTIONS -->

                    <a
                        href="<%= request.getContextPath() %>/transactions"
                        class="quick-action">

                        <div class="quick-icon">

                            📊

                        </div>

                        <div class="quick-title">

                            Transactions

                        </div>

                    </a>


                </div>


            </div>

        </div>


    </div>


    <!-- =================================================
         FOOTER
         ================================================= -->

    <div class="footer">

        🔐 Secure
        &nbsp;&nbsp; | &nbsp;&nbsp;
        💳 Easy to Use
        &nbsp;&nbsp; | &nbsp;&nbsp;
        📊 Finance Management

        <br><br>

        © 2026 Digital Wallet

        <br>

        Personal Finance Management System

    </div>


</div>


</body>

</html>