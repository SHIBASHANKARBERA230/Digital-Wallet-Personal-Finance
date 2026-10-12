```jsp
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%
    String error = (String) request.getAttribute("error");

    String nameValue = request.getParameter("name") != null
            ? request.getParameter("name")
            : "";

    String emailValue = request.getParameter("email") != null
            ? request.getParameter("email")
            : "";

    String phoneValue = request.getParameter("phone") != null
            ? request.getParameter("phone")
            : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Digital Wallet</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            color: #172033;
            min-height: 100vh;
        }

        .header {
            width: 100%;
            background: #ffffff;
            border-bottom: 1px solid #e2e8f0;
            min-height: 82px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 5%;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 14px;
            text-decoration: none;
            color: #1268f3;
        }

        .brand-logo {
            width: 46px;
            height: 46px;
            object-fit: contain;
        }

        .brand-text h1 {
            font-size: 23px;
            font-weight: 700;
            color: #1268f3;
        }

        .brand-text p {
            font-size: 12px;
            margin-top: 3px;
            color: #64748b;
        }

        .home-btn {
            text-decoration: none;
            border: 1px solid #1268f3;
            color: #1268f3;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: 0.2s;
        }

        .home-btn:hover {
            background: #1268f3;
            color: #ffffff;
        }

        .page {
            width: 100%;
            min-height: calc(100vh - 82px);
            padding: 42px 5%;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .register-container {
            width: 100%;
            max-width: 1040px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            background: #ffffff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 15px 45px rgba(15, 23, 42, 0.10);
        }

        .info-panel {
            background: linear-gradient(145deg, #1268f3, #0649b9);
            color: #ffffff;
            padding: 60px 52px;
            min-height: 650px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .wallet-icon {
            width: 82px;
            height: 82px;
            object-fit: contain;
            margin-bottom: 28px;
        }

        .info-panel h2 {
            font-size: 38px;
            line-height: 1.15;
            margin-bottom: 25px;
        }

        .info-panel > p {
            font-size: 15px;
            line-height: 1.8;
            opacity: 0.95;
            margin-bottom: 35px;
        }

        .features {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .feature {
            display: flex;
            align-items: center;
            font-size: 14px;
            font-weight: 600;
            line-height: 1.5;
        }

        .form-panel {
            padding: 48px 52px;
        }

        .form-header {
            margin-bottom: 28px;
        }

        .form-header h2 {
            font-size: 29px;
            color: #172033;
            margin-bottom: 8px;
        }

        .form-header p {
            font-size: 14px;
            color: #64748b;
            line-height: 1.6;
        }

        .error-message {
            background: #fff1f2;
            border: 1px solid #fecdd3;
            color: #be123c;
            border-radius: 8px;
            padding: 12px 14px;
            margin-bottom: 20px;
            font-size: 14px;
            line-height: 1.5;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
        }

        .form-group input {
            width: 100%;
            height: 46px;
            border: 1px solid #d7dee8;
            border-radius: 8px;
            padding: 0 14px;
            font-size: 14px;
            color: #172033;
            outline: none;
            transition: 0.2s;
        }

        .form-group input:focus {
            border-color: #1268f3;
            box-shadow: 0 0 0 3px rgba(18, 104, 243, 0.10);
        }

        .input-help {
            margin-top: 6px;
            font-size: 11px;
            color: #94a3b8;
        }

        .create-btn {
            width: 100%;
            height: 48px;
            border: none;
            border-radius: 8px;
            background: #1268f3;
            color: #ffffff;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
            margin-top: 5px;
        }

        .create-btn:hover {
            background: #0649b9;
            transform: translateY(-1px);
        }

        .login-box {
            margin-top: 24px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 22px;
            text-align: center;
        }

        .login-box h3 {
            font-size: 15px;
            margin-bottom: 7px;
            color: #172033;
        }

        .login-box p {
            font-size: 12px;
            color: #64748b;
            margin-bottom: 15px;
        }

        .login-btn {
            display: block;
            width: 100%;
            padding: 11px;
            border: 1px solid #1268f3;
            border-radius: 8px;
            color: #1268f3;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            background: #ffffff;
            transition: 0.2s;
        }

        .login-btn:hover {
            background: #1268f3;
            color: #ffffff;
        }

        .footer {
            text-align: center;
            padding: 0 20px 30px;
            color: #94a3b8;
            font-size: 12px;
        }

        @media (max-width: 900px) {
            .register-container {
                grid-template-columns: 1fr;
            }

            .info-panel {
                min-height: auto;
                padding: 45px 40px;
            }

            .form-panel {
                padding: 40px;
            }

            .info-panel h2 {
                font-size: 32px;
            }
        }

        @media (max-width: 600px) {
            .header {
                padding: 0 20px;
            }

            .brand-text p {
                display: none;
            }

            .home-btn {
                padding: 8px 13px;
                font-size: 12px;
            }

            .page {
                padding: 25px 15px;
            }

            .info-panel {
                padding: 35px 28px;
            }

            .form-panel {
                padding: 32px 25px;
            }

            .info-panel h2 {
                font-size: 28px;
            }
        }
    </style>
</head>

<body>

<header class="header">
    <a href="<%= request.getContextPath() %>/index.jsp" class="brand">
        <img src="<%= request.getContextPath() %>/images/wallet-logo.png"
             class="brand-logo"
             alt="Digital Wallet Logo">

        <div class="brand-text">
            <h1>Digital Wallet</h1>
            <p>Personal Finance Management System</p>
        </div>
    </a>

    <a href="<%= request.getContextPath() %>/index.jsp" class="home-btn">
        Home
    </a>
</header>

<main class="page">
    <div class="register-container">

        <section class="info-panel">
            <img src="<%= request.getContextPath() %>/images/wallet-logo.png"
                 class="wallet-icon"
                 alt="Wallet">

            <h2>Start Your Financial Journey</h2>

            <p>
                Create your Digital Wallet account and manage your personal
                finances from one secure platform.
            </p>

            <div class="features">
                <div class="feature">
                    Manage your digital wallet
                </div>

                <div class="feature">
                    Track income and expenses
                </div>

                <div class="feature">
                    Monitor your finances
                </div>

                <div class="feature">
                    Set and track savings goals
                </div>

                <div class="feature">
                    Secure account management
                </div>
            </div>
        </section>

        <section class="form-panel">
            <div class="form-header">
                <h2>Create Your Account</h2>
                <p>
                    Register now and start managing your wallet and personal
                    finances.
                </p>
            </div>

            <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="error-message">
                    <%= error %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/register" method="post">

                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text"
                           id="name"
                           name="name"
                           value="<%= nameValue %>"
                           placeholder="Enter your full name"
                           required
                           maxlength="100">
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email"
                           id="email"
                           name="email"
                           value="<%= emailValue %>"
                           placeholder="Enter your email address"
                           required
                           maxlength="150">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="Enter your password"
                           required
                           minlength="6">

                    <div class="input-help">
                        Password must contain at least 6 characters.
                    </div>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel"
                           id="phone"
                           name="phone"
                           value="<%= phoneValue %>"
                           placeholder="Enter your phone number"
                           maxlength="20">
                </div>

                <button type="submit" class="create-btn">
                    Create Account
                </button>
            </form>

            <div class="login-box">
                <h3>Already have an account?</h3>

                <p>
                    Login to your Digital Wallet and manage your finances.
                </p>

                <a href="<%= request.getContextPath() %>/login.jsp"
                   class="login-btn">
                    Login to Your Account
                </a>
            </div>
        </section>

    </div>
</main>

<footer class="footer">
    © 2026 Digital Wallet. All rights reserved.
</footer>

</body>
</html>
```
