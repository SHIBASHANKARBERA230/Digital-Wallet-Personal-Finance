<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.wallet.model.User" %>

<%
    User admin = (User) session.getAttribute("user");

    if (admin == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    List<User> users =
        (List<User>) request.getAttribute("users");

    int userCount = users != null ? users.size() : 0;

    String adminName = admin.getName();

    if (adminName == null || adminName.trim().isEmpty()) {
        adminName = "Administrator";
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Admin Dashboard | Digital Wallet</title>

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
     MAIN PAGE
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


<!-- BRAND -->

<td align="left">

<a
    href="<%=request.getContextPath()%>/dashboard.jsp"
    style="
        text-decoration:none;
        color:white;
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


<!-- ADMIN -->

<td align="right">

<font
    face="Arial"
    size="2"
    color="#B9C5D8">

    Logged in as

</font>

<br>

<font
    face="Arial"
    size="3"
    color="#FFFFFF">

<b>
    🛡️ <%=adminName%>
</b>

</font>

</td>


</tr>

</table>

</td>

</tr>

</table>


<!-- =====================================================
     ADMIN NAVIGATION
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
        color:#1268F3;
        font-size:14px;
        font-weight:bold;
        background:#EEF4FF;
    ">

    🛡️ Admin Dashboard

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
    href="<%=request.getContextPath()%>/profile"
    style="
        display:block;
        padding:18px 15px;
        text-decoration:none;
        color:#667085;
        font-size:14px;
    ">

    👤 Profile

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
    Admin Dashboard
</b>

</font>

<br><br>

<font
    face="Arial"
    size="3"
    color="#667085">

    Manage and monitor registered users.

</font>

</td>


<td align="right">

<font size="7">
    🛡️
</font>

</td>

</tr>


<tr>
<td colspan="2" height="30"></td>
</tr>


<!-- =====================================================
     STAT CARD
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
        border:1px solid #E3E8F0;
        border-radius:15px;
        box-shadow:
            0 6px 24px
            rgba(20,40,80,0.06);
    ">

<tr>

<td
    style="
        padding:28px;
        background:#EEF4FF;
        border-radius:15px;
    ">

<font size="6">
    👥
</font>

<br><br>

<font
    face="Arial"
    size="2"
    color="#667085">

    REGISTERED USERS

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

<br>

<font
    face="Arial"
    size="2"
    color="#667085">

    Total users in the system

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
        border:1px solid #E3E8F0;
        border-radius:15px;
        box-shadow:
            0 6px 24px
            rgba(20,40,80,0.06);
    ">

<tr>

<td
    style="
        padding:28px;
    ">

<font size="6">
    🔐
</font>

<br><br>

<font
    face="Arial"
    size="2"
    color="#667085">

    SYSTEM ACCESS

</font>

<br><br>

<font
    face="Arial"
    size="4"
    color="#188038">

<b>
    ✓ Active
</b>

</font>

<br><br>

<font
    face="Arial"
    size="2"
    color="#667085">

    Administrator session is active.

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
        border:1px solid #E3E8F0;
        border-radius:15px;
        box-shadow:
            0 6px 24px
            rgba(20,40,80,0.06);
    ">

<tr>

<td
    style="
        padding:28px;
    ">

<font size="6">
    ⚙️
</font>

<br><br>

<font
    face="Arial"
    size="2"
    color="#667085">

    ADMINISTRATOR

</font>

<br><br>

<font
    face="Arial"
    size="4"
    color="#172033">

<b>
    <%=adminName%>
</b>

</font>

<br><br>

<font
    face="Arial"
    size="2"
    color="#667085">

    Current administrator

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
     USERS CARD
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


<!-- CARD HEADER -->

<tr>

<td
    style="
        padding:28px 30px;
        border-bottom:1px solid #E5EAF2;
    ">

<table
    width="100%"
    border="0"
    cellpadding="0"
    cellspacing="0">

<tr>

<td>

<font
    face="Arial"
    size="5"
    color="#172033">

<b>
    👥 Registered Users
</b>

</font>

<br><br>

<font
    face="Arial"
    size="3"
    color="#667085">

    List of users registered in the Digital Wallet system.

</font>

</td>

<td align="right">

<table
    border="0"
    cellpadding="0"
    cellspacing="0">

<tr>

<td
    bgcolor="#EEF4FF"
    style="
        padding:10px 16px;
        border-radius:20px;
    ">

<font
    face="Arial"
    size="2"
    color="#1268F3">

<b>
    <%=userCount%> Users
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


<!-- =====================================================
     USERS TABLE
     ===================================================== -->

<tr>

<td style="padding:25px;">

<table
    width="100%"
    border="0"
    cellpadding="14"
    cellspacing="0"
    style="
        border-collapse:collapse;
        font-family:Arial,Helvetica,sans-serif;
    ">


<!-- TABLE HEADER -->

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

<th
    align="center"
    style="
        border-bottom:2px solid #E4EAF2;
        color:#667085;
        font-size:12px;
    ">

    STATUS

</th>

</tr>


<%
if (users != null && !users.isEmpty()) {

    for (User u : users) {

        String userDisplayName = u.getName();

        if (userDisplayName == null ||
            userDisplayName.trim().isEmpty()) {

            userDisplayName = "User";
        }

        String firstLetter =
            userDisplayName.substring(0,1).toUpperCase();
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
    #<%=u.getId()%>
</b>

</td>


<!-- USER ICON -->

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
    width="38"
    height="38"
    bgcolor="#EEF4FF"
    style="
        border-radius:50%;
        color:#1268F3;
        font-weight:bold;
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
    <%=userDisplayName%>
</b>

</td>


<!-- EMAIL -->

<td
    style="
        border-bottom:1px solid #EEF1F5;
        color:#667085;
        font-size:14px;
    ">

    <%=u.getEmail()%>

</td>


<!-- STATUS -->

<td
    align="center"
    style="
        border-bottom:1px solid #EEF1F5;
    ">

<table
    border="0"
    cellpadding="0"
    cellspacing="0">

<tr>

<td
    bgcolor="#ECFDF3"
    style="
        padding:7px 13px;
        border-radius:20px;
    ">

<font
    face="Arial"
    size="2"
    color="#188038">

<b>
    ● Active
</b>

</font>

</td>

</tr>

</table>

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
    colspan="5"
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
    No registered users found
</b>

</font>

<br><br>

<font
    face="Arial"
    size="3"
    color="#667085">

    There are currently no users available
    in the system.

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
     QUICK ACTIONS
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
    width="50%"
    align="center"
    bgcolor="#EEF4FF"
    style="
        padding:22px;
        border:1px solid #D7E5FF;
        border-radius:12px;
    ">

<a
    href="<%=request.getContextPath()%>/dashboard.jsp"
    style="
        text-decoration:none;
        color:#1268F3;
        font-size:14px;
        font-weight:bold;
    ">

    🏠 Open User Dashboard

</a>

</td>


<td
    width="50%"
    align="center"
    bgcolor="#FFF4F4"
    style="
        padding:22px;
        border:1px solid #F2D0D0;
        border-radius:12px;
    ">

<a
    href="<%=request.getContextPath()%>/logout"
    style="
        text-decoration:none;
        color:#D93025;
        font-size:14px;
        font-weight:bold;
    ">

    🚪 Logout Administrator

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
    🔐 Secure Access
    &nbsp;&nbsp; | &nbsp;&nbsp;
    💳 Digital Wallet

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