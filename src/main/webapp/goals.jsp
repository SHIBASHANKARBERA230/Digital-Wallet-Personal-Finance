<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.wallet.model.User" %>
<%@ page import="com.wallet.model.Goal" %>

<%
    User user =
            (User) session.getAttribute("user");

    if (user == null) {

        response.sendRedirect(
                request.getContextPath()
                        + "/login.jsp");

        return;
    }

    List<Goal> goals =
            (List<Goal>)
                    request.getAttribute("goals");

    String message =
            (String) session.getAttribute(
                    "goalMessage");

    String error =
            (String) session.getAttribute(
                    "goalError");

    session.removeAttribute("goalMessage");
    session.removeAttribute("goalError");
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width,
               initial-scale=1.0">

<title>
    Savings Goals - Digital Wallet
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
   MAIN CONTAINER
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

    color: white;

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

input {

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

input:focus {

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
   GOALS GRID
   ===================================================== */

.goals-grid {

    display:
        grid;

    grid-template-columns:
        repeat(3, 1fr);

    gap:
        22px;

}


/* =====================================================
   GOAL CARD
   ===================================================== */

.goal-card {

    border:
        1px solid #e2e7f0;

    border-radius:
        13px;

    padding:
        24px;

    background:
        white;

    transition:
        .2s ease;

}

.goal-card:hover {

    transform:
        translateY(-3px);

    box-shadow:
        0 8px 20px
        rgba(0,0,0,.07);

}

.goal-top {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        flex-start;

    margin-bottom:
        20px;

}

.goal-name {

    margin:
        0;

    font-size:
        18px;

    color:
        #172033;

}

.goal-icon {

    width:
        42px;

    height:
        42px;

    display:
        flex;

    align-items:
        center;

    justify-content:
        center;

    border-radius:
        10px;

    background:
        #eef4ff;

    font-size:
        22px;

}


/* =====================================================
   GOAL AMOUNT
   ===================================================== */

.amount-section {

    margin-bottom:
        18px;

}

.amount-row {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;

    margin-bottom:
        8px;

}

.amount-label {

    color:
        #667085;

    font-size:
        13px;

}

.amount-value {

    color:
        #172033;

    font-size:
        14px;

    font-weight:
        bold;

}

.target-value {

    color:
        #1268f3;

}


/* =====================================================
   PROGRESS
   ===================================================== */

.progress-container {

    width:
        100%;

    height:
        12px;

    background:
        #e8edf5;

    border-radius:
        10px;

    overflow:
        hidden;

}

.progress-bar {

    height:
        100%;

    background:
        linear-gradient(
            90deg,
            #1268f3,
            #4c8df7
        );

    border-radius:
        10px;

    transition:
        width .4s ease;

}

.progress-info {

    display:
        flex;

    justify-content:
        space-between;

    margin-top:
        8px;

}

.progress-percent {

    color:
        #1268f3;

    font-size:
        13px;

    font-weight:
        bold;

}

.progress-text {

    color:
        #667085;

    font-size:
        12px;

}


/* =====================================================
   DEADLINE
   ===================================================== */

.deadline {

    padding:
        11px 13px;

    margin-top:
        18px;

    background:
        #f8fafc;

    border-radius:
        8px;

    color:
        #667085;

    font-size:
        13px;

}

.deadline strong {

    color:
        #344054;

}


/* =====================================================
   ADD MONEY
   ===================================================== */

.add-money {

    margin-top:
        20px;

    padding-top:
        20px;

    border-top:
        1px solid #edf0f5;

}

.add-money-title {

    margin-bottom:
        10px;

    font-size:
        13px;

    font-weight:
        bold;

    color:
        #344054;

}

.money-form {

    display:
        flex;

    gap:
        9px;

}

.money-form input {

    flex:
        1;

    min-width:
        0;

    height:
        42px;

}

.money-button {

    height:
        42px;

    padding:
        0 15px;

    border:
        none;

    border-radius:
        7px;

    background:
        #1268f3;

    color:
        white;

    font-size:
        12px;

    font-weight:
        bold;

    cursor:
        pointer;

}


/* =====================================================
   DELETE
   ===================================================== */

.delete-section {

    margin-top:
        12px;

}

.delete-button {

    width:
        100%;

    height:
        39px;

    border:
        1px solid #f1b7b7;

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
        52px;

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

@media (max-width: 1100px) {

    .goals-grid {

        grid-template-columns:
            repeat(2, 1fr);

    }

}


/* =====================================================
   TABLET
   ===================================================== */

@media (max-width: 900px) {

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

    .goals-grid {

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

    .money-form {

        flex-direction:
            column;

    }

    .money-button {

        width:
            100%;

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

            📊 Transactions

        </a>


        <a href="<%=request.getContextPath()%>/budget">

            💰 Budget

        </a>


        <a
            href="<%=request.getContextPath()%>/goals"
            class="active">

            🎯 Goals

        </a>


        <a
            href="<%=request.getContextPath()%>/logout"
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

                    Savings Goals

                </h1>


                <p class="page-subtitle">

                    Set financial targets, track your progress,
                    and work towards your future goals.

                </p>

            </div>


            <div class="page-icon">

                🎯

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
             CREATE GOAL
             ================================================= -->

        <div class="card">


            <div class="card-header">

                <h2 class="card-title">

                    ➕ Create Savings Goal

                </h2>


                <p class="card-description">

                    Define what you are saving for and
                    set your target amount.

                </p>

            </div>


            <div class="card-body">


                <form
                    action="<%=request.getContextPath()%>/goals"
                    method="post">


                    <input
                        type="hidden"
                        name="action"
                        value="add">


                    <div class="form-grid">


                        <!-- GOAL NAME -->

                        <div class="form-group">

                            <label>

                                Goal Name

                            </label>


                            <input
                                type="text"
                                name="goalName"
                                placeholder="e.g. New Laptop"
                                required>

                        </div>


                        <!-- TARGET -->

                        <div class="form-group">

                            <label>

                                Target Amount

                            </label>


                            <input
                                type="number"
                                name="targetAmount"
                                min="1"
                                step="0.01"
                                placeholder="e.g. 60000"
                                required>

                        </div>


                        <!-- DEADLINE -->

                        <div class="form-group">

                            <label>

                                Deadline

                            </label>


                            <input
                                type="date"
                                name="deadline"
                                required>

                        </div>


                    </div>


                    <div class="form-button">


                        <button
                            type="submit"
                            class="primary-button">

                            🎯 Create Goal

                        </button>


                    </div>


                </form>


            </div>


        </div>


        <!-- =================================================
             MY GOALS
             ================================================= -->

        <div class="card">


            <div class="card-header">

                <h2 class="card-title">

                    🎯 My Savings Goals

                </h2>


                <p class="card-description">

                    Track how close you are to reaching
                    each financial target.

                </p>

            </div>


            <div class="card-body">


                <%
                    if (goals != null &&
                        !goals.isEmpty()) {
                %>


                <div class="goals-grid">


                    <%

                        for (Goal goal : goals) {

                            double progress =
                                    goal.getProgress();

                            if (progress < 0) {
                                progress = 0;
                            }

                            if (progress > 100) {
                                progress = 100;
                            }

                    %>


                    <!-- =================================================
                         GOAL CARD
                         ================================================= -->

                    <div class="goal-card">


                        <div class="goal-top">


                            <div>

                                <h3 class="goal-name">

                                    <%= goal.getGoalName() %>

                                </h3>

                            </div>


                            <div class="goal-icon">

                                🎯

                            </div>


                        </div>


                        <!-- AMOUNT -->

                        <div class="amount-section">


                            <div class="amount-row">


                                <span class="amount-label">

                                    Saved

                                </span>


                                <span class="amount-value">

                                    ₹ <%= String.format(
                                            "%.2f",
                                            goal.getSavedAmount()) %>

                                </span>


                            </div>


                            <div class="amount-row">


                                <span class="amount-label">

                                    Target

                                </span>


                                <span class="amount-value target-value">

                                    ₹ <%= String.format(
                                            "%.2f",
                                            goal.getTargetAmount()) %>

                                </span>


                            </div>


                        </div>


                        <!-- PROGRESS -->

                        <div class="progress-container">


                            <div
                                class="progress-bar"
                                style="width:<%=progress%>%;">
                            </div>


                        </div>


                        <div class="progress-info">


                            <span class="progress-percent">

                                <%= String.format(
                                        "%.1f",
                                        progress) %>%

                            </span>


                            <span class="progress-text">

                                completed

                            </span>


                        </div>


                        <!-- DEADLINE -->

                        <div class="deadline">

                            📅 Deadline:

                            <strong>

                                <%= goal.getDeadline() %>

                            </strong>

                        </div>


                        <!-- ADD MONEY -->

                        <div class="add-money">


                            <div class="add-money-title">

                                💰 Add Money

                            </div>


                            <form
                                action="<%=request.getContextPath()%>/goals"
                                method="post"
                                class="money-form">


                                <input
                                    type="hidden"
                                    name="action"
                                    value="addMoney">


                                <input
                                    type="hidden"
                                    name="goalId"
                                    value="<%=goal.getId()%>">


                                <input
                                    type="number"
                                    name="amount"
                                    min="0.01"
                                    step="0.01"
                                    placeholder="Amount"
                                    required>


                                <button
                                    type="submit"
                                    class="money-button">

                                    Add

                                </button>


                            </form>


                        </div>


                        <!-- DELETE -->

                        <div class="delete-section">


                            <form
                                action="<%=request.getContextPath()%>/goals"
                                method="post">


                                <input
                                    type="hidden"
                                    name="action"
                                    value="delete">


                                <input
                                    type="hidden"
                                    name="goalId"
                                    value="<%=goal.getId()%>">


                                <button
                                    type="submit"
                                    class="delete-button">

                                    🗑 Delete Goal

                                </button>


                            </form>


                        </div>


                    </div>


                    <%

                        }

                    %>


                </div>


                <%

                    } else {

                %>


                <!-- =================================================
                     EMPTY STATE
                     ================================================= -->

                <div class="empty-state">


                    <div class="empty-icon">

                        🎯

                    </div>


                    <div class="empty-title">

                        No Savings Goals Yet

                    </div>


                    <div class="empty-text">

                        Create your first savings goal above
                        and start working towards it.

                    </div>


                </div>


                <%

                    }

                %>


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


                    <a
                        href="<%=request.getContextPath()%>/dashboard"
                        class="quick-action">

                        <div class="quick-icon">

                            🏠

                        </div>

                        <div class="quick-title">

                            Dashboard

                        </div>

                    </a>


                    <a
                        href="<%=request.getContextPath()%>/budget"
                        class="quick-action">

                        <div class="quick-icon">

                            💰

                        </div>

                        <div class="quick-title">

                            Budget

                        </div>

                    </a>


                    <a
                        href="<%=request.getContextPath()%>/reports"
                        class="quick-action">

                        <div class="quick-icon">

                            📊

                        </div>

                        <div class="quick-title">

                            Reports

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
        🎯 Goal Tracking
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