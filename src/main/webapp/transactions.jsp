<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.wallet.model.User" %>
<%@ page import="com.wallet.model.Transaction" %>

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
       TRANSACTIONS
       ===================================================== */

    List<Transaction> transactions =
            (List<Transaction>) request.getAttribute("transactions");


    /* =====================================================
       SUCCESS / ERROR MESSAGE
       ===================================================== */

    String message =
            (String) session.getAttribute("transactionMessage");

    String error =
            (String) session.getAttribute("transactionError");

    session.removeAttribute("transactionMessage");
    session.removeAttribute("transactionError");


    /* =====================================================
       USER NAME
       ===================================================== */

    String userName = user.getName();

    if (userName == null || userName.trim().isEmpty()) {
        userName = "User";
    }


    /* =====================================================
       TRANSACTION COUNT
       ===================================================== */

    int transactionCount = 0;

    if (transactions != null) {
        transactionCount = transactions.size();
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Digital Wallet - Transactions</title>

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


<!-- WALLET -->

<td align="center">

<a
    href="<%= request.getContextPath() %>/wallet.jsp"
    style="
        display:block;
        padding:19px 10px;
        text-decoration:none;
        color:#667085;
        font-size:14px;
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


<!-- TRANSACTIONS ACTIVE -->

<td
    align="center"
    bgcolor="#EEF4FF">

<a
    href="<%= request.getContextPath() %>/transactions"
    style="
        display:block;
        padding:19px 10px;
        text-decoration:none;
        color:#1268F3;
        font-size:14px;
        font-weight:bold;
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
            Transaction Management
        </b>

    </font>

    <br>

    <font
        face="Arial"
        size="3"
        color="#667085">

        Manage your income, expenses and money transfers
        in one place.

    </font>

</td>


<td align="right">

    <font size="7">
        📊
    </font>

</td>

</tr>


<tr>
<td colspan="2" height="30"></td>
</tr>


<!-- =====================================================
     SUCCESS MESSAGE
     ===================================================== -->

<% if (message != null) { %>

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

        <%= message %>

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

<% if (error != null) { %>

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

        <%= error %>

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
     SUMMARY
     ===================================================== -->

<tr>

<td colspan="2">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="12">

<tr>


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

    <font size="6">
        📊
    </font>

    <br><br>

    <font
        face="Arial"
        size="2"
        color="#667085">

        TOTAL TRANSACTIONS

    </font>

    <br><br>

    <font
        face="Arial"
        size="5"
        color="#1268F3">

        <b>
            <%= transactionCount %>
        </b>

    </font>

</td>

</tr>

</table>

</td>


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

    <font size="6">
        💰
    </font>

    <br><br>

    <font
        face="Arial"
        size="2"
        color="#667085">

        TRANSACTION TYPES

    </font>

    <br><br>

    <font
        face="Arial"
        size="4"
        color="#172033">

        <b>
            Income · Expense · Transfer
        </b>

    </font>

</td>

</tr>

</table>

</td>


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

    <font size="6">
        🔐
    </font>

    <br><br>

    <font
        face="Arial"
        size="2"
        color="#667085">

        TRANSACTION STATUS

    </font>

    <br><br>

    <font
        face="Arial"
        size="4"
        color="#188038">

        <b>
            ✓ Tracked
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
     ACTION CARDS
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
     ADD INCOME
     ===================================================== -->

<td
    width="33%"
    valign="top">

<table
    width="100%"
    height="100%"
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
        📈
    </font>

    <br><br>

    <font
        face="Arial"
        size="5"
        color="#188038">

        <b>
            Add Income
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="3"
        color="#667085">

        Record money received.

    </font>

</td>

</tr>


<tr>

<td
    style="
        padding:28px;
    ">

<form
    action="<%= request.getContextPath() %>/transactions"
    method="post">

    <input
        type="hidden"
        name="action"
        value="income">


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
        placeholder="Enter income amount"
        required
        style="
            width:100%;
            height:52px;
            padding:12px 15px;
            box-sizing:border-box;
            border:1px solid #D0D5DD;
            border-radius:8px;
            font-size:15px;
        ">


    <br><br>


    <button
        type="submit"
        style="
            width:100%;
            height:52px;
            background:#188038;
            color:#FFFFFF;
            border:0;
            border-radius:8px;
            font-size:15px;
            font-weight:bold;
            cursor:pointer;
        ">

        ➕ Add Income

    </button>

</form>

</td>

</tr>

</table>

</td>


<!-- =====================================================
     ADD EXPENSE
     ===================================================== -->

<td
    width="33%"
    valign="top">

<table
    width="100%"
    height="100%"
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
        📉
    </font>

    <br><br>

    <font
        face="Arial"
        size="5"
        color="#D93025">

        <b>
            Add Expense
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="3"
        color="#667085">

        Record money spent.

    </font>

</td>

</tr>


<tr>

<td
    style="
        padding:28px;
    ">

<form
    action="<%= request.getContextPath() %>/transactions"
    method="post">

    <input
        type="hidden"
        name="action"
        value="expense">


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
        placeholder="Enter expense amount"
        required
        style="
            width:100%;
            height:52px;
            padding:12px 15px;
            box-sizing:border-box;
            border:1px solid #D0D5DD;
            border-radius:8px;
            font-size:15px;
        ">


    <br><br>


    <button
        type="submit"
        style="
            width:100%;
            height:52px;
            background:#D93025;
            color:#FFFFFF;
            border:0;
            border-radius:8px;
            font-size:15px;
            font-weight:bold;
            cursor:pointer;
        ">

        ➖ Add Expense

    </button>

</form>

</td>

</tr>

</table>

</td>


<!-- =====================================================
     TRANSFER
     ===================================================== -->

<td
    width="33%"
    valign="top">

<table
    width="100%"
    height="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    bgcolor="#FFFFFF"
    style="
        border:1px solid #D7E5FF;
        border-radius:16px;
        box-shadow:0 6px 22px rgba(20,40,80,0.05);
    ">

<tr>

<td
    style="
        padding:28px;
        background:#EEF4FF;
        border-bottom:1px solid #D7E5FF;
    ">

    <font size="6">
        💸
    </font>

    <br><br>

    <font
        face="Arial"
        size="5"
        color="#1268F3">

        <b>
            Transfer Money
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="3"
        color="#667085">

        Send money to another user.

    </font>

</td>

</tr>


<tr>

<td
    style="
        padding:28px;
    ">

<form
    action="<%= request.getContextPath() %>/transactions"
    method="post">

    <input
        type="hidden"
        name="action"
        value="transfer">


    <font
        face="Arial"
        size="3"
        color="#344054">

        <b>
            Receiver User ID
        </b>

    </font>

    <br><br>


    <input
        type="number"
        name="receiverId"
        min="1"
        placeholder="Enter receiver user ID"
        required
        style="
            width:100%;
            height:52px;
            padding:12px 15px;
            box-sizing:border-box;
            border:1px solid #D0D5DD;
            border-radius:8px;
            font-size:15px;
        ">


    <br><br>


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
        placeholder="Enter transfer amount"
        required
        style="
            width:100%;
            height:52px;
            padding:12px 15px;
            box-sizing:border-box;
            border:1px solid #D0D5DD;
            border-radius:8px;
            font-size:15px;
        ">


    <br><br>


    <button
        type="submit"
        style="
            width:100%;
            height:52px;
            background:#1268F3;
            color:#FFFFFF;
            border:0;
            border-radius:8px;
            font-size:15px;
            font-weight:bold;
            cursor:pointer;
        ">

        💸 Transfer Money

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
<td colspan="2" height="35"></td>
</tr>


<!-- =====================================================
     TRANSACTION HISTORY
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
        box-shadow:0 6px 24px rgba(20,40,80,0.05);
    ">


<!-- HISTORY HEADER -->

<tr>

<td
    style="
        padding:26px 30px;
        border-bottom:1px solid #E5EAF2;
    ">

    <font
        face="Arial"
        size="5"
        color="#172033">

        <b>
            📋 Transaction History
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="3"
        color="#667085">

        View your income, expenses and transfers.

    </font>

</td>

</tr>


<!-- TABLE WRAPPER -->

<tr>

<td
    style="
        padding:25px;
    ">


<table
    width="100%"
    border="0"
    cellpadding="14"
    cellspacing="0"
    style="
        border-collapse:collapse;
        font-family:Arial, Helvetica, sans-serif;
    ">


<!-- TABLE HEADER -->

<tr
    bgcolor="#F8FAFC">

    <th
        align="left"
        style="
            border-bottom:2px solid #E4EAF2;
            color:#667085;
            font-size:12px;
        ">

        ID

    </th>

    <th
        align="left"
        style="
            border-bottom:2px solid #E4EAF2;
            color:#667085;
            font-size:12px;
        ">

        SENDER

    </th>

    <th
        align="left"
        style="
            border-bottom:2px solid #E4EAF2;
            color:#667085;
            font-size:12px;
        ">

        RECEIVER

    </th>

    <th
        align="left"
        style="
            border-bottom:2px solid #E4EAF2;
            color:#667085;
            font-size:12px;
        ">

        AMOUNT

    </th>

    <th
        align="left"
        style="
            border-bottom:2px solid #E4EAF2;
            color:#667085;
            font-size:12px;
        ">

        TYPE

    </th>

    <th
        align="left"
        style="
            border-bottom:2px solid #E4EAF2;
            color:#667085;
            font-size:12px;
        ">

        STATUS

    </th>

    <th
        align="left"
        style="
            border-bottom:2px solid #E4EAF2;
            color:#667085;
            font-size:12px;
        ">

        DATE

    </th>

</tr>


<%
    if (transactions != null && !transactions.isEmpty()) {

        for (Transaction transaction : transactions) {
%>


<!-- TRANSACTION ROW -->

<tr>


<!-- ID -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
        font-size:13px;
        color:#172033;
    ">

    <b>
        #<%= transaction.getId() %>
    </b>

</td>


<!-- SENDER -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
        font-size:13px;
        color:#344054;
    ">

    <%= transaction.getSenderId() %>

</td>


<!-- RECEIVER -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
        font-size:13px;
        color:#344054;
    ">

    <%= transaction.getReceiverId() %>

</td>


<!-- AMOUNT -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
        font-size:14px;
        color:#172033;
    ">

    <b>
        ₹ <%= String.format(
                "%.2f",
                transaction.getAmount()) %>
    </b>

</td>


<!-- TYPE -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
        font-size:13px;
        color:#344054;
    ">

    <%= transaction.getTransactionType() %>

</td>


<!-- STATUS -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
        font-size:13px;
    ">

<%
    String status =
            String.valueOf(transaction.getStatus());

    if ("SUCCESS".equalsIgnoreCase(status)) {
%>

    <font
        color="#188038">

        <b>
            ✓ <%= status %>
        </b>

    </font>

<%
    } else if ("FAILED".equalsIgnoreCase(status)) {
%>

    <font
        color="#D93025">

        <b>
            ✕ <%= status %>
        </b>

    </font>

<%
    } else {
%>

    <font
        color="#C77700">

        <b>
            ● <%= status %>
        </b>

    </font>

<%
    }
%>

</td>


<!-- DATE -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
        font-size:13px;
        color:#667085;
    ">

    <%= transaction.getTransactionDate() %>

</td>


</tr>


<%
        }

    } else {
%>


<!-- =====================================================
     NO TRANSACTIONS
     ===================================================== -->

<tr>

<td
    colspan="7"
    align="center"
    style="
        padding:75px 20px;
    ">

    <font size="7">
        📭
    </font>

    <br><br>

    <font
        face="Arial"
        size="5"
        color="#344054">

        <b>
            No transactions found
        </b>

    </font>

    <br><br>

    <font
        face="Arial"
        size="3"
        color="#667085">

        Your transaction history will appear here
        after you make your first transaction.

    </font>

</td>

</tr>


<%
    }
%>


</table>

</td>

</tr>

</table>

</td>

</tr>


<tr>
<td colspan="2" height="35"></td>
</tr>


<!-- =====================================================
     SHORTCUTS
     ===================================================== -->

<tr>

<td colspan="2">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="12">

<tr>


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
    href="<%= request.getContextPath() %>/wallet.jsp"
    style="
        text-decoration:none;
        color:#344054;
        font-size:14px;
        font-weight:bold;
    ">

    💳 Open Wallet

</a>

</td>


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