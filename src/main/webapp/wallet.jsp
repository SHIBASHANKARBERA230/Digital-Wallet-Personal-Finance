<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.wallet.model.User" %>
<%@ page import="com.wallet.model.Wallet" %>
<%@ page import="com.wallet.service.WalletServiceImpl" %>

<%
    /* =====================================================
       USER SESSION
       ===================================================== */

    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }


    /* =====================================================
       GET WALLET
       ===================================================== */

    WalletServiceImpl service = new WalletServiceImpl();

    Wallet wallet = service.getWallet(user.getId());


    /* =====================================================
       SUCCESS / ERROR MESSAGE
       ===================================================== */

    String walletMessage =
            (String) session.getAttribute("walletMessage");

    String walletError =
            (String) session.getAttribute("walletError");

    session.removeAttribute("walletMessage");
    session.removeAttribute("walletError");


    /* =====================================================
       USER NAME
       ===================================================== */

    String userName = user.getName();

    if (userName == null || userName.trim().isEmpty()) {
        userName = "User";
    }


    /* =====================================================
       BALANCE
       ===================================================== */

    double balance = 0.0;

    if (wallet != null) {
        balance = wallet.getBalance();
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Digital Wallet - Wallet</title>

</head>


<body
    style="
        margin:0;
        padding:0;
        background:#F4F7FB;
        font-family:Arial, Helvetica, sans-serif;
        color:#172033;
    ">


<!-- =====================================================
     FULL PAGE
     ===================================================== -->

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    style="
        min-height:100vh;
    ">

<tr>

<td>


<!-- =====================================================
     HEADER
     ===================================================== -->

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    style="
        background:linear-gradient(
            135deg,
            #1268F3,
            #0649B9
        );
    ">

<tr>

<td
    style="
        padding:22px 5%;
    ">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0">

<tr>


<!-- BRAND -->

<td align="left">

    <a
        href="<%= request.getContextPath() %>/dashboard.jsp"
        style="
            text-decoration:none;
        ">

        <font
            face="Arial"
            size="5"
            color="#FFFFFF">

            <b>
                💳 Digital Wallet
            </b>

        </font>

    </a>

    <br>

    <font
        face="Arial"
        size="2"
        color="#DCE9FF">

        Personal Finance Management System

    </font>

</td>


<!-- USER -->

<td align="right">

    <font
        face="Arial"
        size="2"
        color="#DCE9FF">

        Welcome back

    </font>

    <br>

    <font
        face="Arial"
        size="3"
        color="#FFFFFF">

        <b>
            <%= userName %>
        </b>

        👋

    </font>

</td>

</tr>

</table>

</td>

</tr>

</table>


<!-- =====================================================
     NAVIGATION
     ===================================================== -->

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#FFFFFF"
    style="
        border-bottom:1px solid #E5EAF2;
    ">

<tr>

<td
    style="
        padding:0 5%;
    ">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0">

<tr>


<!-- DASHBOARD -->

<td align="center">

<a
    href="<%= request.getContextPath() %>/dashboard.jsp"
    style="
        display:block;
        padding:19px 10px;
        text-decoration:none;
        color:#667085;
        font-size:14px;
    ">

    🏠 Dashboard

</a>

</td>


<!-- WALLET ACTIVE -->

<td
    align="center"
    bgcolor="#EEF4FF">

<a
    href="<%= request.getContextPath() %>/wallet.jsp"
    style="
        display:block;
        padding:19px 10px;
        text-decoration:none;
        color:#1268F3;
        font-size:14px;
        font-weight:bold;
    ">

    💳 Wallet

</a>

</td>


<!-- EXPENSES -->

<td align="center">

<a
    href="<%= request.getContextPath() %>/expenses"
    style="
        display:block;
        padding:19px 10px;
        text-decoration:none;
        color:#667085;
        font-size:14px;
    ">

    💸 Expenses

</a>

</td>


<!-- TRANSACTIONS -->

<td align="center">

<a
    href="<%= request.getContextPath() %>/transactions"
    style="
        display:block;
        padding:19px 10px;
        text-decoration:none;
        color:#667085;
        font-size:14px;
    ">

    📊 Transactions

</a>

</td>


<!-- BUDGET -->

<td align="center">

<a
    href="<%= request.getContextPath() %>/budget"
    style="
        display:block;
        padding:19px 10px;
        text-decoration:none;
        color:#667085;
        font-size:14px;
    ">

    💰 Budget

</a>

</td>


<!-- GOALS -->

<td align="center">

<a
    href="<%= request.getContextPath() %>/goals"
    style="
        display:block;
        padding:19px 10px;
        text-decoration:none;
        color:#667085;
        font-size:14px;
    ">

    🎯 Goals

</a>

</td>


<!-- LOGOUT -->

<td align="center">

<a
    href="<%= request.getContextPath() %>/logout"
    style="
        display:block;
        padding:19px 10px;
        text-decoration:none;
        color:#D93025;
        font-size:14px;
        font-weight:bold;
    ">

    🚪 Logout

</a>

</td>


</tr>

</table>

</td>

</tr>

</table>


<!-- =====================================================
     MAIN CONTENT
     ===================================================== -->

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0">

<tr>

<td
    style="
        padding:45px 5%;
    ">


<!-- CONTENT MAX WIDTH -->

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    style="
        max-width:1600px;
        margin:0 auto;
    ">


<!-- =====================================================
     PAGE TITLE
     ===================================================== -->

<tr>

<td>

    <font
        face="Arial"
        size="6"
        color="#172033">

        <b>
            Wallet Dashboard
        </b>

    </font>

    <br>

    <font
        face="Arial"
        size="3"
        color="#667085">

        Manage your wallet balance, deposits and withdrawals
        securely from one place.

    </font>

</td>


<td
    align="right"
    valign="middle">

    <font size="7">
        💳
    </font>

</td>

</tr>


<tr>
<td colspan="2" height="30"></td>
</tr>


<!-- =====================================================
     SUCCESS MESSAGE
     ===================================================== -->

<% if (walletMessage != null) { %>

<tr>

<td colspan="2">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#ECFDF3"
    style="
        border:1px solid #B7E4C7;
        border-radius:10px;
    ">

<tr>

<td
    style="
        padding:17px 22px;
    ">

    <font
        face="Arial"
        size="3"
        color="#188038">

        <b>
            ✓ Success
        </b>

        &nbsp;&nbsp;

        <%= walletMessage %>

    </font>

</td>

</tr>

</table>

</td>

</tr>

<tr>
<td colspan="2" height="18"></td>
</tr>

<% } %>


<!-- =====================================================
     ERROR MESSAGE
     ===================================================== -->

<% if (walletError != null) { %>

<tr>

<td colspan="2">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#FFF4F4"
    style="
        border:1px solid #F2CACA;
        border-radius:10px;
    ">

<tr>

<td
    style="
        padding:17px 22px;
    ">

    <font
        face="Arial"
        size="3"
        color="#D93025">

        <b>
            ⚠ Error
        </b>

        &nbsp;&nbsp;

        <%= walletError %>

    </font>

</td>

</tr>

</table>

</td>

</tr>

<tr>
<td colspan="2" height="18"></td>
</tr>

<% } %>


<% if (wallet != null) { %>


<!-- =====================================================
     BALANCE CARD
     ===================================================== -->

<tr>

<td colspan="2">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    style="
        background:linear-gradient(
            135deg,
            #1268F3,
            #0649B9
        );
        border-radius:18px;
        box-shadow:0 12px 35px rgba(18,104,243,0.22);
    ">

<tr>

<td
    width="70%"
    style="
        padding:42px;
    ">

    <font
        face="Arial"
        size="3"
        color="#DCE9FF">

        AVAILABLE WALLET BALANCE

    </font>

    <br><br>

    <font
        face="Arial"
        size="7"
        color="#FFFFFF">

        <b>
            ₹ <%= String.format(
                    "%.2f",
                    balance) %>
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="3"
        color="#DCE9FF">

        Your current available balance

    </font>

</td>


<td
    width="30%"
    align="center">

    <font size="8">
        💰
    </font>

    <br><br>

    <font
        face="Arial"
        size="3"
        color="#DCE9FF">

        Digital Wallet

    </font>

</td>

</tr>

</table>

</td>

</tr>


<tr>
<td colspan="2" height="30"></td>
</tr>


<!-- =====================================================
     QUICK STAT CARDS
     ===================================================== -->

<tr>

<td colspan="2">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="12">

<tr>


<!-- CURRENT BALANCE -->

<td
    width="33%"
    valign="top">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#FFFFFF"
    style="
        border:1px solid #E4EAF2;
        border-radius:14px;
        box-shadow:0 5px 20px rgba(20,40,80,0.05);
    ">

<tr>

<td
    style="
        padding:25px;
    ">

    <font size="5">
        💰
    </font>

    <br><br>

    <font
        face="Arial"
        size="2"
        color="#667085">

        CURRENT BALANCE

    </font>

    <br><br>

    <font
        face="Arial"
        size="5"
        color="#172033">

        <b>
            ₹ <%= String.format(
                    "%.2f",
                    balance) %>
        </b>

    </font>

</td>

</tr>

</table>

</td>


<!-- WALLET STATUS -->

<td
    width="33%"
    valign="top">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#FFFFFF"
    style="
        border:1px solid #E4EAF2;
        border-radius:14px;
        box-shadow:0 5px 20px rgba(20,40,80,0.05);
    ">

<tr>

<td
    style="
        padding:25px;
    ">

    <font size="5">
        🔐
    </font>

    <br><br>

    <font
        face="Arial"
        size="2"
        color="#667085">

        WALLET STATUS

    </font>

    <br><br>

    <font
        face="Arial"
        size="4"
        color="#188038">

        <b>
            ● Active
        </b>

    </font>

</td>

</tr>

</table>

</td>


<!-- ACCOUNT -->

<td
    width="33%"
    valign="top">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#FFFFFF"
    style="
        border:1px solid #E4EAF2;
        border-radius:14px;
        box-shadow:0 5px 20px rgba(20,40,80,0.05);
    ">

<tr>

<td
    style="
        padding:25px;
    ">

    <font size="5">
        👤
    </font>

    <br><br>

    <font
        face="Arial"
        size="2"
        color="#667085">

        ACCOUNT HOLDER

    </font>

    <br><br>

    <font
        face="Arial"
        size="4"
        color="#172033">

        <b>
            <%= userName %>
        </b>

    </font>

</td>

</tr>

</table>

</td>


</tr>

</table>

</td>

</tr>


<tr>
<td colspan="2" height="30"></td>
</tr>


<!-- =====================================================
     WALLET ACTIONS
     ===================================================== -->

<tr>

<td colspan="2">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="12">

<tr>


<!-- =====================================================
     ADD MONEY
     ===================================================== -->

<td
    width="50%"
    valign="top">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#FFFFFF"
    style="
        border:1px solid #D7EAD9;
        border-radius:16px;
        box-shadow:0 6px 22px rgba(20,40,80,0.05);
    ">

<tr>

<td
    style="
        padding:28px;
        background:#ECFDF3;
        border-bottom:1px solid #D7EAD9;
    ">

    <font size="6">
        ➕
    </font>

    <br><br>

    <font
        face="Arial"
        size="5"
        color="#188038">

        <b>
            Add Money
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="3"
        color="#667085">

        Add funds to your digital wallet.

    </font>

</td>

</tr>


<tr>

<td
    style="
        padding:30px;
    ">

<form
    action="<%= request.getContextPath() %>/wallet"
    method="post">

    <input
        type="hidden"
        name="action"
        value="deposit">


    <font
        face="Arial"
        size="3"
        color="#344054">

        <b>
            Amount
        </b>

    </font>

    <br><br>


    <input
        type="number"
        name="amount"
        min="0.01"
        step="0.01"
        placeholder="Enter amount e.g. 500.00"
        required
        style="
            width:100%;
            height:52px;
            padding:12px 15px;
            box-sizing:border-box;
            border:1px solid #D0D5DD;
            border-radius:8px;
            font-size:15px;
            outline:none;
        ">


    <br><br>


    <button
        type="submit"
        style="
            width:100%;
            height:52px;
            background:#188038;
            color:white;
            border:0;
            border-radius:8px;
            font-size:15px;
            font-weight:bold;
            cursor:pointer;
        ">

        ➕ Add Money

    </button>

</form>

</td>

</tr>

</table>

</td>


<!-- =====================================================
     WITHDRAW MONEY
     ===================================================== -->

<td
    width="50%"
    valign="top">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#FFFFFF"
    style="
        border:1px solid #F2D0D0;
        border-radius:16px;
        box-shadow:0 6px 22px rgba(20,40,80,0.05);
    ">

<tr>

<td
    style="
        padding:28px;
        background:#FFF4F4;
        border-bottom:1px solid #F2D0D0;
    ">

    <font size="6">
        ➖
    </font>

    <br><br>

    <font
        face="Arial"
        size="5"
        color="#D93025">

        <b>
            Withdraw Money
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="3"
        color="#667085">

        Withdraw money from your wallet.

    </font>

</td>

</tr>


<tr>

<td
    style="
        padding:30px;
    ">

<form
    action="<%= request.getContextPath() %>/wallet"
    method="post">

    <input
        type="hidden"
        name="action"
        value="withdraw">


    <font
        face="Arial"
        size="3"
        color="#344054">

        <b>
            Amount
        </b>

    </font>

    <br><br>


    <input
        type="number"
        name="amount"
        min="0.01"
        step="0.01"
        placeholder="Enter amount e.g. 500.00"
        required
        style="
            width:100%;
            height:52px;
            padding:12px 15px;
            box-sizing:border-box;
            border:1px solid #D0D5DD;
            border-radius:8px;
            font-size:15px;
            outline:none;
        ">


    <br><br>


    <button
        type="submit"
        style="
            width:100%;
            height:52px;
            background:#D93025;
            color:white;
            border:0;
            border-radius:8px;
            font-size:15px;
            font-weight:bold;
            cursor:pointer;
        ">

        ➖ Withdraw Money

    </button>

</form>

</td>

</tr>

</table>

</td>


</tr>

</table>

</td>

</tr>


<tr>
<td colspan="2" height="30"></td>
</tr>


<!-- =====================================================
     WALLET INFORMATION
     ===================================================== -->

<tr>

<td colspan="2">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#FFFFFF"
    style="
        border:1px solid #E4EAF2;
        border-radius:16px;
        box-shadow:0 5px 20px rgba(20,40,80,0.04);
    ">

<tr>


<!-- SECURE -->

<td
    width="33%"
    align="center"
    style="
        padding:30px;
    ">

    <font size="6">
        🔐
    </font>

    <br><br>

    <font
        face="Arial"
        size="4"
        color="#172033">

        <b>
            Secure Wallet
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="2"
        color="#667085">

        Your wallet is protected
        by your account session.

    </font>

</td>


<!-- DEPOSITS -->

<td
    width="33%"
    align="center"
    style="
        padding:30px;
        border-left:1px solid #E4EAF2;
        border-right:1px solid #E4EAF2;
    ">

    <font size="6">
        💰
    </font>

    <br><br>

    <font
        face="Arial"
        size="4"
        color="#172033">

        <b>
            Easy Deposits
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="2"
        color="#667085">

        Add money whenever
        you need it.

    </font>

</td>


<!-- FINANCE -->

<td
    width="33%"
    align="center"
    style="
        padding:30px;
    ">

    <font size="6">
        📊
    </font>

    <br><br>

    <font
        face="Arial"
        size="4"
        color="#172033">

        <b>
            Manage Finances
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="2"
        color="#667085">

        Track your money
        through transactions.

    </font>

</td>


</tr>

</table>

</td>

</tr>


<% } else { %>


<!-- =====================================================
     WALLET NOT FOUND
     ===================================================== -->

<tr>

<td colspan="2">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#FFF4F4"
    style="
        border:1px solid #F2D0D0;
        border-radius:14px;
    ">

<tr>

<td
    align="center"
    style="
        padding:70px 30px;
    ">

    <font size="7">
        💳
    </font>

    <br><br>

    <font
        face="Arial"
        size="5"
        color="#D93025">

        <b>
            Wallet Not Found
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="3"
        color="#667085">

        No wallet was found for your account.

        <br><br>

        Please contact the administrator
        or try again later.

    </font>

</td>

</tr>

</table>

</td>

</tr>


<% } %>


<tr>
<td colspan="2" height="35"></td>
</tr>


<!-- =====================================================
     NAVIGATION SHORTCUTS
     ===================================================== -->

<tr>

<td colspan="2">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="12">

<tr>


<!-- DASHBOARD -->

<td
    width="33%"
    align="center"
    bgcolor="#EEF4FF"
    style="
        padding:20px;
        border:1px solid #D7E5FF;
        border-radius:10px;
    ">

<a
    href="<%= request.getContextPath() %>/dashboard.jsp"
    style="
        text-decoration:none;
        color:#1268F3;
        font-size:14px;
        font-weight:bold;
    ">

    🏠 Back to Dashboard

</a>

</td>


<!-- TRANSACTIONS -->

<td
    width="33%"
    align="center"
    bgcolor="#F8FAFC"
    style="
        padding:20px;
        border:1px solid #E4EAF2;
        border-radius:10px;
    ">

<a
    href="<%= request.getContextPath() %>/transactions"
    style="
        text-decoration:none;
        color:#344054;
        font-size:14px;
        font-weight:bold;
    ">

    📊 View Transactions

</a>

</td>


<!-- LOGOUT -->

<td
    width="33%"
    align="center"
    bgcolor="#FFF4F4"
    style="
        padding:20px;
        border:1px solid #F2D0D0;
        border-radius:10px;
    ">

<a
    href="<%= request.getContextPath() %>/logout"
    style="
        text-decoration:none;
        color:#D93025;
        font-size:14px;
        font-weight:bold;
    ">

    🚪 Logout

</a>

</td>


</tr>

</table>

</td>

</tr>


</table>

</td>

</tr>

</table>


<!-- =====================================================
     FOOTER
     ===================================================== -->

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#FFFFFF"
    style="
        border-top:1px solid #E5EAF2;
    ">

<tr>

<td
    align="center"
    style="
        padding:30px 5%;
    ">

    <font
        face="Arial"
        size="2"
        color="#667085">

        🔐 Secure
        &nbsp;&nbsp; | &nbsp;&nbsp;

        💳 Easy to Use
        &nbsp;&nbsp; | &nbsp;&nbsp;

        📊 Finance Management

        <br><br>

        © 2026 Digital Wallet

        <br>

        Personal Finance Management System

    </font>

</td>

</tr>

</table>


</td>

</tr>

</table>


</body>

</html>