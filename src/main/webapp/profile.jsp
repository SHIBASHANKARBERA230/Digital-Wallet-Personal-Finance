<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="com.wallet.model.User" %>

<%
    User user =
            (User) session.getAttribute("user");

    if (user == null) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp");

        return;
    }

    String message =
            (String) session.getAttribute("profileMessage");

    String error =
            (String) session.getAttribute("profileError");

    session.removeAttribute("profileMessage");
    session.removeAttribute("profileError");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Profile - Digital Wallet</title>

    <style>

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

        .page {
            width: 100%;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .header {
            width: 100%;
            min-height: 85px;
            padding: 15px 5%;
            background: white;
            border-bottom: 1px solid #e3e8f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 13px;
        }

        .brand-logo {
            width: 52px;
            height: 52px;
            object-fit: contain;
        }

        .brand-name {
            color: #1268f3;
            font-size: 22px;
            font-weight: bold;
        }

        .brand-subtitle {
            margin-top: 3px;
            color: #7a8495;
            font-size: 11px;
        }

        .user-area {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-name {
            color: #566174;
            font-size: 13px;
        }

        .logout {
            padding: 9px 17px;
            border: 1px solid #dc3545;
            border-radius: 7px;
            color: #dc3545;
            text-decoration: none;
            font-size: 12px;
            font-weight: bold;
        }

        .logout:hover {
            background: #dc3545;
            color: white;
        }

        .main {
            width: 100%;
            flex: 1;
            padding: 35px 5% 60px;
        }

        .content {
            width: 100%;
            max-width: 1400px;
            margin: auto;
        }

        .page-header {
            padding: 30px;
            background:
                    linear-gradient(
                            135deg,
                            #1268f3,
                            #0649b9
                    );
            color: white;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .page-header h1 {
            margin: 0;
            font-size: 30px;
        }

        .page-header p {
            margin: 8px 0 0;
            color: #e5efff;
            font-size: 13px;
        }

        .profile-icon {
            width: 65px;
            height: 65px;
            border-radius: 15px;
            background: rgba(255, 255, 255, .15);
            border: 1px solid rgba(255, 255, 255, .20);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
        }

        .profile-layout {
            margin-top: 25px;
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 25px;
        }

        .summary-card {
            background: white;
            border: 1px solid #e4e9f0;
            border-radius: 14px;
            padding: 30px;
            box-shadow:
                    0 5px 18px rgba(0, 0, 0, .04);
            text-align: center;
        }

        .avatar {
            width: 105px;
            height: 105px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background:
                    linear-gradient(
                            135deg,
                            #1268f3,
                            #0649b9
                    );
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 43px;
            font-weight: bold;
        }

        .summary-card h2 {
            margin: 0;
            font-size: 21px;
            color: #172033;
        }

        .summary-email {
            margin-top: 8px;
            color: #7a8495;
            font-size: 12px;
            word-break: break-word;
        }

        .account-status {
            margin-top: 25px;
            padding: 13px;
            border-radius: 8px;
            background: #eaf8f0;
            color: #167342;
            font-size: 12px;
            font-weight: bold;
        }

        .summary-divider {
            height: 1px;
            background: #e9edf3;
            margin: 25px 0;
        }

        .summary-info {
            text-align: left;
            margin-bottom: 15px;
        }

        .summary-label {
            display: block;
            color: #8992a2;
            font-size: 11px;
            margin-bottom: 4px;
        }

        .summary-value {
            color: #344054;
            font-size: 13px;
            font-weight: bold;
            word-break: break-word;
        }

        .edit-card {
            background: white;
            border: 1px solid #e4e9f0;
            border-radius: 14px;
            padding: 30px;
            box-shadow:
                    0 5px 18px rgba(0, 0, 0, .04);
        }

        .card-title {
            margin: 0;
            font-size: 21px;
            color: #172033;
        }

        .card-subtitle {
            margin: 8px 0 25px;
            color: #7a8495;
            font-size: 12px;
        }

        .success {
            padding: 13px 15px;
            margin-bottom: 20px;
            background: #e8f8ef;
            border: 1px solid #b9e6ca;
            border-left: 5px solid #167342;
            border-radius: 7px;
            color: #167342;
            font-size: 13px;
        }

        .error {
            padding: 13px 15px;
            margin-bottom: 20px;
            background: #fdecec;
            border: 1px solid #f3c2c2;
            border-left: 5px solid #b42318;
            border-radius: 7px;
            color: #b42318;
            font-size: 13px;
        }

        .form-group {
            margin-bottom: 22px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #344054;
            font-size: 13px;
            font-weight: bold;
        }

        .form-input {
            width: 100%;
            height: 48px;
            padding: 0 14px;
            border: 1px solid #d8dee8;
            border-radius: 8px;
            outline: none;
            background: white;
            color: #172033;
            font-size: 14px;
        }

        .form-input:focus {
            border-color: #1268f3;
            box-shadow:
                    0 0 0 3px rgba(18, 104, 243, .10);
        }

        .form-input:disabled {
            background: #f4f6f9;
            color: #7a8495;
            cursor: not-allowed;
        }

        .email-note {
            margin-top: 7px;
            color: #8992a2;
            font-size: 11px;
        }

        .phone-note {
            margin-top: 7px;
            color: #8992a2;
            font-size: 11px;
        }

        .update-button {
            min-width: 190px;
            height: 48px;
            padding: 0 22px;
            border: none;
            border-radius: 8px;
            background: #1268f3;
            color: white;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
        }

        .update-button:hover {
            background: #0753cf;
        }

        .security-box {
            margin-top: 25px;
            padding: 20px;
            background: #f5f8ff;
            border: 1px solid #dce8ff;
            border-radius: 9px;
        }

        .security-box h3 {
            margin: 0 0 8px;
            color: #172033;
            font-size: 14px;
        }

        .security-box p {
            margin: 0;
            color: #667085;
            font-size: 12px;
            line-height: 1.6;
        }

        .footer {
            width: 100%;
            padding: 22px 5%;
            background: #172033;
            color: #aeb7c7;
            text-align: center;
            font-size: 11px;
        }

        @media (max-width: 900px) {

            .profile-layout {
                grid-template-columns: 1fr;
            }

            .summary-card {
                text-align: center;
            }

            .summary-info {
                text-align: center;
            }
        }

        @media (max-width: 650px) {

            .header {
                padding: 13px 20px;
            }

            .brand-name {
                font-size: 18px;
            }

            .brand-subtitle {
                display: none;
            }

            .user-name {
                display: none;
            }

            .main {
                padding: 20px 15px 40px;
            }

            .page-header {
                padding: 25px;
            }

            .page-header h1 {
                font-size: 24px;
            }

            .profile-icon {
                display: none;
            }

            .summary-card,
            .edit-card {
                padding: 22px;
            }
        }

    </style>

</head>

<body>

<div class="page">

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

        <div class="user-area">

            <span class="user-name">
                👤 <%= user.getName() %>
            </span>

            <a
                    href="<%= request.getContextPath() %>/logout"
                    class="logout">
                Logout
            </a>

        </div>

    </header>

    <main class="main">

        <div class="content">

            <div class="page-header">

                <div>

                    <h1>
                        👤 My Profile
                    </h1>

                    <p>
                        Manage your account information
                        and profile details.
                    </p>

                </div>

                <div class="profile-icon">
                    👤
                </div>

            </div>

            <div class="profile-layout">

                <div class="summary-card">

                    <div class="avatar">

                        <%= user.getName() != null
                                && !user.getName().trim().isEmpty()
                                ? user.getName()
                                    .substring(0, 1)
                                    .toUpperCase()
                                : "U" %>

                    </div>

                    <h2>
                        <%= user.getName() %>
                    </h2>

                    <div class="summary-email">
                        <%= user.getEmail() %>
                    </div>

                    <div class="account-status">
                        ✓ Account Active
                    </div>

                    <div class="summary-divider"></div>

                    <div class="summary-info">

                        <span class="summary-label">
                            ACCOUNT NAME
                        </span>

                        <span class="summary-value">
                            <%= user.getName() %>
                        </span>

                    </div>

                    <div class="summary-info">

                        <span class="summary-label">
                            EMAIL ADDRESS
                        </span>

                        <span class="summary-value">
                            <%= user.getEmail() %>
                        </span>

                    </div>

                    <div class="summary-info">

                        <span class="summary-label">
                            PHONE NUMBER
                        </span>

                        <span class="summary-value">

                            <%= user.getPhone() != null
                                    && !user.getPhone().trim().isEmpty()
                                    ? user.getPhone()
                                    : "Not provided" %>

                        </span>

                    </div>

                </div>

                <div class="edit-card">

                    <h2 class="card-title">
                        Edit Profile
                    </h2>

                    <p class="card-subtitle">
                        Update your personal account
                        information below.
                    </p>

                    <% if (message != null) { %>

                    <div class="success">
                        ✓ <%= message %>
                    </div>

                    <% } %>

                    <% if (error != null) { %>

                    <div class="error">
                        ⚠ <%= error %>
                    </div>

                    <% } %>

                    <form
                            action="<%= request.getContextPath() %>/profile"
                            method="post">

                        <div class="form-group">

                            <label class="form-label">
                                👤 Full Name
                            </label>

                            <input
                                    type="text"
                                    name="name"
                                    class="form-input"
                                    value="<%= user.getName() %>"
                                    placeholder="Enter your full name"
                                    required>

                        </div>

                        <div class="form-group">

                            <label class="form-label">
                                📱 Phone Number
                            </label>

                            <input
                                    type="tel"
                                    name="phone"
                                    class="form-input"
                                    value="<%= user.getPhone() != null
                                            ? user.getPhone()
                                            : "" %>"
                                    placeholder="Enter 10-digit phone number"
                                    maxlength="10">

                            <div class="phone-note">
                                Enter a 10-digit phone number or leave it empty.
                            </div>

                        </div>

                        <div class="form-group">

                            <label class="form-label">
                                ✉ Email Address
                            </label>

                            <input
                                    type="email"
                                    class="form-input"
                                    value="<%= user.getEmail() %>"
                                    disabled>

                            <div class="email-note">
                                Email address cannot be changed
                                from this page.
                            </div>

                        </div>

                        <button
                                type="submit"
                                class="update-button">
                            💾 Update Profile
                        </button>

                    </form>

                    <div class="security-box">

                        <h3>
                            🔐 Account Security
                        </h3>

                        <p>
                            Keep your account information
                            accurate and use a strong password
                            to protect your Digital Wallet account.
                        </p>

                    </div>

                </div>

            </div>

        </div>

    </main>

    <footer class="footer">

        © 2026 Digital Wallet
        &nbsp; | &nbsp;
        Personal Finance Management System

    </footer>

</div>

</body>

</html>