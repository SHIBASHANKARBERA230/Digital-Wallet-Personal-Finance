<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.wallet.model.User" %>
<%@ page import="com.wallet.model.Budget" %>

<%
    User user =
            (User) session.getAttribute("user");

    if (user == null) {

        response.sendRedirect(
                request.getContextPath()
                        + "/login.jsp");

        return;
    }

    List<Budget> budgets =
            (List<Budget>)
                    request.getAttribute("budgets");

    String message =
            (String) session.getAttribute(
                    "budgetMessage");

    String error =
            (String) session.getAttribute(
                    "budgetError");

    session.removeAttribute("budgetMessage");
    session.removeAttribute("budgetError");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Budget Management - Digital Wallet</title>

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


/* =========================================
   MAIN CONTAINER
   ========================================= */

.container {

    width: 100%;

    max-width: none;

    min-height: 100vh;

    margin: 0;

    background:
        white;
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

    color: white;

    padding:
        25px 5%;

    display: flex;

    justify-content:
        space-between;

    align-items:
        center;

    min-height:
        115px;
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

    object-fit:
        contain;

    background:
        white;

    padding:
        5px;

    border-radius:
        13px;
}

.header-title {

    font-size:
        27px;

    font-weight:
        bold;
}

.header-subtitle {

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
}

.welcome-name {

    font-size:
        17px;

    font-weight:
        bold;

    margin-top:
        5px;
}


/* =========================================
   NAVIGATION
   ========================================= */

.nav {

    width: 100%;

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

    margin:
        0 0 8px;

    font-size:
        31px;

    color:
        #172033;
}

.page-subtitle {

    margin:
        0 0 30px;

    color:
        #68758a;

    font-size:
        15px;

    line-height:
        1.6;
}


/* =========================================
   MESSAGE
   ========================================= */

.message {

    padding:
        14px 17px;

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


/* =========================================
   CARD
   ========================================= */

.card {

    width:
        100%;

    background:
        white;

    border:
        1px solid #e4e9f2;

    border-radius:
        13px;

    margin-bottom:
        25px;

    padding:
        28px;

    box-shadow:
        0 4px 14px
        rgba(0,0,0,0.05);
}

.card h2 {

    margin:
        0 0 23px;

    font-size:
        20px;

    color:
        #172033;
}


/* =========================================
   FORM
   ========================================= */

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
        #44516a;
}

input,
select {

    width:
        100%;

    padding:
        13px 14px;

    border:
        1px solid #d5dce8;

    border-radius:
        8px;

    background:
        white;

    color:
        #172033;

    font-size:
        14px;

    outline:
        none;

    transition:
        0.2s ease;
}

input:focus,
select:focus {

    border-color:
        #1268f3;

    box-shadow:
        0 0 0 3px
        rgba(18,104,243,0.10);
}

.form-button {

    margin-top:
        22px;
}

button {

    padding:
        12px 21px;

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
        0.2s ease;
}

button:hover {

    background:
        #0753cf;

    transform:
        translateY(-1px);
}

.delete {

    background:
        #dc3545;
}

.delete:hover {

    background:
        #b02a37;
}


/* =========================================
   TABLE
   ========================================= */

.table-wrapper {

    width:
        100%;

    overflow-x:
        auto;
}

table {

    width:
        100%;

    border-collapse:
        collapse;

    min-width:
        650px;
}

th,
td {

    padding:
        15px;

    border-bottom:
        1px solid #edf0f5;

    text-align:
        left;

    font-size:
        14px;
}

th {

    background:
        #f5f7fb;

    color:
        #4c5870;

    font-size:
        13px;

    text-transform:
        uppercase;

    letter-spacing:
        0.3px;
}

tbody tr:hover {

    background:
        #f9fbff;
}

.amount {

    font-weight:
        bold;

    color:
        #1268f3;
}

.category {

    font-weight:
        600;
}

.month {

    color:
        #68758a;
}


/* =========================================
   EMPTY STATE
   ========================================= */

.empty {

    text-align:
        center;

    padding:
        35px 20px;

    color:
        #7a869a;
}

.empty-icon {

    font-size:
        40px;

    margin-bottom:
        10px;
}

.empty-title {

    font-size:
        17px;

    font-weight:
        bold;

    color:
        #44516a;

    margin-bottom:
        5px;
}

.empty-text {

    font-size:
        13px;
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
   LARGE SCREEN
   ========================================= */

@media (min-width: 1600px) {

    .header {

        padding:
            28px 60px;
    }

    .content {

        padding:
            42px 60px;
    }

    .card {

        padding:
            32px;
    }
}


/* =========================================
   TABLET
   ========================================= */

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


/* =========================================
   MOBILE
   ========================================= */

@media (max-width: 700px) {

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

    .form-grid {

        grid-template-columns:
            1fr;
    }

    .card {

        padding:
            22px;
    }
}


/* =========================================
   SMALL MOBILE
   ========================================= */

@media (max-width: 450px) {

    .logo {

        width:
            50px;

        height:
            50px;
    }

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

    .card {

        padding:
            18px;
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


    <!-- =========================================
         NAVIGATION
         ========================================= -->

    <div class="nav">

        <a href="<%=request.getContextPath()%>/dashboard">
            🏠 Dashboard
        </a>

        <a href="<%=request.getContextPath()%>/wallet.jsp">
            💳 Wallet
        </a>

        <a href="<%=request.getContextPath()%>/expenses.jsp">
            💸 Expenses
        </a>

        <a href="<%=request.getContextPath()%>/transactions">
            📊 Transactions
        </a>

        <a href="<%=request.getContextPath()%>/budget"
           class="active">
            💰 Budget
        </a>

        <a href="<%=request.getContextPath()%>/goals">
            🎯 Goals
        </a>

        <a href="<%=request.getContextPath()%>/logout"
           class="logout">
            🚪 Logout
        </a>

    </div>


    <!-- =========================================
         CONTENT
         ========================================= -->

    <div class="content">


        <h1 class="page-title">
            💰 Budget Management
        </h1>

        <p class="page-subtitle">

            Create monthly spending limits and keep
            track of your planned expenses.

        </p>


        <!-- =====================================
             SUCCESS MESSAGE
             ===================================== -->

        <% if (message != null) { %>

            <div class="message success">

                ✅ <%= message %>

            </div>

        <% } %>


        <!-- =====================================
             ERROR MESSAGE
             ===================================== -->

        <% if (error != null) { %>

            <div class="message error">

                ⚠️ <%= error %>

            </div>

        <% } %>


        <!-- =====================================
             CREATE BUDGET
             ===================================== -->

        <div class="card">

            <h2>
                ➕ Create Monthly Budget
            </h2>


            <form
                action="<%=request.getContextPath()%>/budget"
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
                                Select category
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
                                🏠 Bills
                            </option>

                            <option value="Entertainment">
                                🎮 Entertainment
                            </option>

                            <option value="Education">
                                📚 Education
                            </option>

                            <option value="Health">
                                🏥 Health
                            </option>

                            <option value="Other">
                                📦 Other
                            </option>

                        </select>

                    </div>


                    <!-- AMOUNT -->

                    <div class="form-group">

                        <label>
                            Budget Amount
                        </label>

                        <input
                            type="number"
                            name="amount"
                            min="0.01"
                            step="0.01"
                            placeholder="Enter budget amount"
                            required>

                    </div>


                    <!-- MONTH -->

                    <div class="form-group">

                        <label>
                            Month
                        </label>

                        <input
                            type="month"
                            name="month"
                            required>

                    </div>

                </div>


                <div class="form-button">

                    <button type="submit">

                        ➕ Create Budget

                    </button>

                </div>

            </form>

        </div>


        <!-- =====================================
             BUDGET LIST
             ===================================== -->

        <div class="card">

            <h2>
                📋 Your Budgets
            </h2>


            <div class="table-wrapper">

                <table>

                    <thead>

                    <tr>

                        <th>
                            Category
                        </th>

                        <th>
                            Amount
                        </th>

                        <th>
                            Month
                        </th>

                        <th>
                            Action
                        </th>

                    </tr>

                    </thead>


                    <tbody>


                    <%
                        if (budgets != null &&
                            !budgets.isEmpty()) {

                            for (Budget budget : budgets) {
                    %>


                    <tr>


                        <!-- CATEGORY -->

                        <td class="category">

                            <%= budget.getCategory() %>

                        </td>


                        <!-- AMOUNT -->

                        <td class="amount">

                            ₹ <%= String.format(
                                    "%.2f",
                                    budget.getAmount()) %>

                        </td>


                        <!-- MONTH -->

                        <td class="month">

                            <%= budget.getMonth() %>

                        </td>


                        <!-- DELETE -->

                        <td>

                            <form
                                action="<%=request.getContextPath()%>/budget"
                                method="post"
                                style="margin:0;">

                                <input
                                    type="hidden"
                                    name="action"
                                    value="delete">

                                <input
                                    type="hidden"
                                    name="budgetId"
                                    value="<%=budget.getId()%>">

                                <button
                                    class="delete"
                                    type="submit">

                                    🗑 Delete

                                </button>

                            </form>

                        </td>


                    </tr>


                    <%
                            }

                        } else {
                    %>


                    <tr>

                        <td colspan="4">

                            <div class="empty">

                                <div class="empty-icon">
                                    💰
                                </div>

                                <div class="empty-title">
                                    No Budgets Found
                                </div>

                                <div class="empty-text">
                                    Create your first monthly
                                    budget using the form above.
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