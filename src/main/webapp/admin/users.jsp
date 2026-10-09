<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.wallet.model.User" %>

<%
    List<User> users =
        (List<User>) request.getAttribute("users");

    int userCount = users != null ? users.size() : 0;
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Manage Users | Digital Wallet</title>

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
     PAGE
     ===================================================== -->

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0"
    style="min-height:100vh;">

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
            #172033,
            #263650
        );
    ">

<tr>

<td style="padding:24px 5%;">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0">

<tr>


<td align="left">

<a
    href="<%=request.getContextPath()%>/admin"
    style="
        text-decoration:none;
        color:#FFFFFF;
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
    color="#B9C5D8">

    Administration Panel

</font>

</td>


<td align="right">

<font
    face="Arial"
    size="2"
    color="#B9C5D8">

    User Management

</font>

<br>

<font
    face="Arial"
    size="3"
    color="#FFFFFF">

<b>
    👥 Manage Users
</b>

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
        border-bottom:1px solid #E3E8F0;
    ">

<tr>

<td style="padding:0 5%;">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0">

<tr>


<td align="center">

<a
    href="<%=request.getContextPath()%>/admin"
    style="
        display:block;
        padding:18px 15px;
        text-decoration:none;
        color:#667085;
        font-size:14px;
    ">

    🛡️ Admin Dashboard

</a>

</td>


<td align="center">

<a
    href="<%=request.getContextPath()%>/admin/users"
    style="
        display:block;
        padding:18px 15px;
        text-decoration:none;
        color:#1268F3;
        font-size:14px;
        font-weight:bold;
        background:#EEF4FF;
    ">

    👥 Manage Users

</a>

</td>


<td align="center">

<a
    href="<%=request.getContextPath()%>/dashboard.jsp"
    style="
        display:block;
        padding:18px 15px;
        text-decoration:none;
        color:#667085;
        font-size:14px;
    ">

    🏠 User Dashboard

</a>

</td>


<td align="center">

<a
    href="<%=request.getContextPath()%>/logout"
    style="
        display:block;
        padding:18px 15px;
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
    👥 Manage Users
</b>

</font>

<br><br>

<font
    face="Arial"
    size="3"
    color="#667085">

    View registered users in the Digital Wallet system.

</font>

</td>


<td align="right">

<font size="7">
    👥
</font>

</td>

</tr>


<tr>
<td colspan="2" height="30"></td>
</tr>


<!-- =====================================================
     USER COUNT
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
        border:1px solid #E3E8F0;
        border-radius:15px;
        box-shadow:
            0 6px 24px
            rgba(20,40,80,0.06);
    ">

<tr>

<td
    width="80"
    align="center"
    style="
        padding:25px;
        background:#EEF4FF;
        border-radius:15px 0 0 15px;
    ">

<font size="6">
    👥
</font>

</td>


<td style="padding:25px;">

<font
    face="Arial"
    size="2"
    color="#667085">

    TOTAL REGISTERED USERS

</font>

<br><br>

<font
    face="Arial"
    size="6"
    color="#1268F3">

<b>
    <%=userCount%>
</b>

</font>

&nbsp;&nbsp;

<font
    face="Arial"
    size="3"
    color="#667085">

    users

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
     USERS TABLE
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
        border:1px solid #E3E8F0;
        border-radius:16px;
        box-shadow:
            0 6px 25px
            rgba(20,40,80,0.06);
    ">


<!-- TABLE HEADER -->

<tr>

<td
    style="
        padding:28px 30px;
        border-bottom:1px solid #E5EAF2;
    ">

<font
    face="Arial"
    size="5"
    color="#172033">

<b>
    📋 User Directory
</b>

</font>

<br><br>

<font
    face="Arial"
    size="3"
    color="#667085">

    Registered users and their account information.

</font>

</td>

</tr>


<!-- TABLE -->

<tr>

<td style="padding:25px;">

<table
    width="100%"
    border="0"
    cellpadding="15"
    cellspacing="0"
    style="
        border-collapse:collapse;
        font-family:Arial,Helvetica,sans-serif;
    ">


<!-- COLUMN HEADERS -->

<tr bgcolor="#F8FAFC">

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

    USER

</th>


<th
    align="left"
    style="
        border-bottom:2px solid #E4EAF2;
        color:#667085;
        font-size:12px;
    ">

    NAME

</th>


<th
    align="left"
    style="
        border-bottom:2px solid #E4EAF2;
        color:#667085;
        font-size:12px;
    ">

    EMAIL

</th>


</tr>


<%
    if (users != null && !users.isEmpty()) {

        for (User user : users) {

            String userName = user.getName();

            if (userName == null ||
                userName.trim().isEmpty()) {

                userName = "User";
            }

            String firstLetter =
                userName.substring(0, 1).toUpperCase();
%>


<!-- USER ROW -->

<tr>


<!-- ID -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
        color:#344054;
        font-size:14px;
    ">

<b>
    #<%=user.getId()%>
</b>

</td>


<!-- USER AVATAR -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
    ">

<table
    border="0"
    cellpadding="0"
    cellspacing="0">

<tr>

<td
    align="center"
    valign="middle"
    width="40"
    height="40"
    bgcolor="#EEF4FF"
    style="
        border-radius:50%;
    ">

<font
    face="Arial"
    color="#1268F3">

<b>
    <%=firstLetter%>
</b>

</font>

</td>

</tr>

</table>

</td>


<!-- NAME -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
        color:#172033;
        font-size:14px;
    ">

<b>
    <%=userName%>
</b>

</td>


<!-- EMAIL -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
        color:#667085;
        font-size:14px;
    ">

    <%=user.getEmail()%>

</td>


</tr>


<%
        }

    } else {
%>


<!-- =====================================================
     EMPTY STATE
     ===================================================== -->

<tr>

<td
    colspan="4"
    align="center"
    style="
        padding:80px 20px;
    ">

<font size="7">
    👥
</font>

<br><br>

<font
    face="Arial"
    size="5"
    color="#344054">

<b>
    No users found
</b>

</font>

<br><br>

<font
    face="Arial"
    size="3"
    color="#667085">

    There are currently no registered users
    available to display.

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
     BACK TO ADMIN
     ===================================================== -->

<tr>

<td colspan="2">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0">

<tr>

<td
    align="center"
    bgcolor="#EEF4FF"
    style="
        padding:22px;
        border:1px solid #D7E5FF;
        border-radius:12px;
    ">

<a
    href="<%=request.getContextPath()%>/admin"
    style="
        text-decoration:none;
        color:#1268F3;
        font-size:15px;
        font-weight:bold;
    ">

    ← Back to Admin Dashboard

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

    🛡️ Administrator Panel
    &nbsp;&nbsp; | &nbsp;&nbsp;
    👥 User Management
    &nbsp;&nbsp; | &nbsp;&nbsp;
    🔐 Secure Access

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