```jsp
<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">
    <title>Digital Wallet - Login</title>

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
            font-family: Arial, Helvetica, sans-serif;
        }

        body {
            background: #f4f7fb;
            color: #172033;
        }

        .page {
            width: 100%;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .header {
            width: 100%;
            height: 85px;
            padding: 15px 5%;
            background: white;
            border-bottom: 1px solid #e4e8ef;
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
            color: #777f8f;
            font-size: 11px;
        }

        .home-link {
            color: #1268f3;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            padding: 10px 18px;
            border: 1px solid #1268f3;
            border-radius: 7px;
        }

        .home-link:hover {
            background: #1268f3;
            color: white;
        }

        .login-section {
            flex: 1;
            width: 100%;
            padding: 50px 5%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-wrapper {
            width: 100%;
            max-width: 1050px;
            min-height: 620px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 12px 35px rgba(20, 40, 80, .10);
        }

        .login-info {
            padding: 55px;
            background: linear-gradient(
                135deg,
                #1268f3,
                #0649b9
            );
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .info-logo {
            width: 95px;
            height: 95px;
            object-fit: contain;
            margin-bottom: 25px;
        }

        .login-info h1 {
            margin: 0;
            font-size: 38px;
            line-height: 1.2;
        }

        .login-info h1 span {
            color: #dceaff;
        }

        .login-info p {
            margin-top: 20px;
            max-width: 430px;
            font-size: 15px;
            line-height: 1.8;
            color: #e9f1ff;
        }

        .benefits {
            margin-top: 30px;
        }

        .benefit {
            margin: 15px 0;
            font-size: 14px;
            color: #f4f7ff;
        }

        .login-form-area {
            padding: 45px 55px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .welcome {
            margin-bottom: 28px;
        }

        .welcome h2 {
            margin: 0;
            font-size: 28px;
            color: #172033;
        }

        .welcome p {
            margin-top: 10px;
            color: #6c7585;
            font-size: 13px;
            line-height: 1.6;
        }

        .error-message {
            width: 100%;
            margin-bottom: 20px;
            padding: 12px 14px;
            background: #fef3f2;
            border: 1px solid #fecdca;
            border-radius: 8px;
            color: #b42318;
            font-size: 13px;
            line-height: 1.5;
        }

        .success-message {
            width: 100%;
            margin-bottom: 20px;
            padding: 12px 14px;
            background: #ecfdf3;
            border: 1px solid #abefc6;
            border-radius: 8px;
            color: #027a48;
            font-size: 13px;
            line-height: 1.5;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #172033;
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
            font-size: 14px;
            color: #172033;
            background: white;
        }

        .form-input:focus {
            border-color: #1268f3;
            box-shadow: 0 0 0 3px rgba(18,104,243,.10);
        }

        .password-wrapper {
            position: relative;
            width: 100%;
        }

        .password-wrapper .form-input {
            padding-right: 48px;
        }

        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            width: 30px;
            height: 30px;
            border: none;
            background: transparent;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #667085;
            padding: 0;
        }

        .toggle-password:hover {
            color: #1268f3;
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 5px 0 25px;
        }

        .remember {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 12px;
            color: #667085;
        }

        .remember input {
            width: 15px;
            height: 15px;
        }

        .forgot {
            color: #1268f3;
            text-decoration: none;
            font-size: 12px;
            font-weight: bold;
        }

        .forgot:hover {
            text-decoration: underline;
        }

        .login-button {
            width: 100%;
            height: 50px;
            border: none;
            border-radius: 8px;
            background: #1268f3;
            color: white;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
        }

        .login-button:hover {
            background: #0753cf;
        }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 28px 0;
            color: #98a1b2;
            font-size: 11px;
        }

        .divider-line {
            flex: 1;
            height: 1px;
            background: #e0e5ec;
        }

        .social-buttons {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .social-button {
            height: 45px;
            border: 1px solid #d8dee8;
            border-radius: 8px;
            background: white;
            color: #344054;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .social-button:hover {
            background: #f7f9fc;
        }

        .register-box {
            margin-top: 28px;
            padding-top: 22px;
            border-top: 1px solid #edf0f5;
            text-align: center;
        }

        .register-box p {
            margin: 0 0 12px;
            color: #667085;
            font-size: 12px;
        }

        .register-button {
            display: inline-block;
            width: 100%;
            padding: 11px;
            border: 1px solid #1268f3;
            border-radius: 7px;
            background: white;
            color: #1268f3;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
        }

        .register-button:hover {
            background: #1268f3;
            color: white;
        }

        .footer {
            width: 100%;
            padding: 20px 5%;
            background: #172033;
            color: #aeb7c7;
            text-align: center;
            font-size: 11px;
        }

        @media (max-width: 850px) {
            .login-wrapper {
                grid-template-columns: 1fr;
            }

            .login-info {
                padding: 40px;
                text-align: center;
            }

            .info-logo {
                margin-left: auto;
                margin-right: auto;
            }

            .login-info p {
                margin-left: auto;
                margin-right: auto;
            }

            .benefits {
                display: none;
            }
        }

        @media (max-width: 600px) {
            .header {
                padding: 13px 20px;
            }

            .home-link {
                padding: 8px 13px;
                font-size: 12px;
            }

            .brand-name {
                font-size: 18px;
            }

            .brand-subtitle {
                display: none;
            }

            .login-section {
                padding: 25px 15px;
            }

            .login-info {
                padding: 35px 25px;
            }

            .login-info h1 {
                font-size: 30px;
            }

            .login-form-area {
                padding: 35px 25px;
            }

            .social-buttons {
                grid-template-columns: 1fr;
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

        <a
            href="index.jsp"
            class="home-link">
            Home
        </a>

    </header>

    <main class="login-section">

        <div class="login-wrapper">

            <div class="login-info">

                <img
                    src="images/wallet-logo.png"
                    class="info-logo"
                    alt="Digital Wallet">

                <h1>
                    Welcome Back!
                </h1>

                <p>
                    Login to your Digital Wallet and
                    take control of your personal
                    finances from one secure platform.
                </p>

                <div class="benefits">

                    <div class="benefit">
                        Secure account access
                    </div>

                    <div class="benefit">
                        Manage your digital wallet
                    </div>

                    <div class="benefit">
                        Track income and expenses
                    </div>

                    <div class="benefit">
                        Monitor your financial activity
                    </div>

                    <div class="benefit">
                        Manage your savings goals
                    </div>

                </div>

            </div>

            <div class="login-form-area">

                <div class="welcome">

                    <h2>
                        Login to Your Account
                    </h2>

                    <p>
                        Enter your credentials to
                        continue to your dashboard.
                    </p>

                </div>

                <%
                    String error =
                            (String) request.getAttribute("error");

                    if (error != null) {
                %>

                    <div class="error-message">
                        <%= error %>
                    </div>

                <%
                    }
                %>

                <%
                    String reset =
                            request.getParameter("reset");

                    if ("success".equals(reset)) {
                %>

                    <div class="success-message">
                        Password updated successfully!
                    </div>

                <%
                    }
                %>

                <form
                    action="<%= request.getContextPath() %>/login"
                    method="post">

                    <div class="form-group">

                        <label
                            class="form-label"
                            for="email">
                            Email Address
                        </label>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            class="form-input"
                            placeholder="Enter your email address"
                            required>

                    </div>

                    <div class="form-group">

                        <label
                            class="form-label"
                            for="password">
                            Password
                        </label>

                        <div class="password-wrapper">

                            <input
                                type="password"
                                id="password"
                                name="password"
                                class="form-input"
                                placeholder="Enter your password"
                                required>

                            <button
                                type="button"
                                class="toggle-password"
                                id="togglePassword"
                                aria-label="Show password">
                                👁️
                            </button>

                        </div>

                    </div>

                    <div class="form-options">

                        <label class="remember">

                            <input
                                type="checkbox"
                                name="rememberMe"
                                value="true">

                            <span>
                                Remember Me
                            </span>

                        </label>

                        <a
                            href="<%= request.getContextPath() %>/forgot-password.jsp"
                            class="forgot">
                            Forgot Password?
                        </a>

                    </div>

                    <button
                        type="submit"
                        class="login-button">
                        Login
                    </button>

                </form>

                <div class="divider">

                    <div class="divider-line"></div>

                    OR CONTINUE WITH

                    <div class="divider-line"></div>

                </div>

                <div class="social-buttons">

                    <a
                        href="<%= request.getContextPath() %>/google-login"
                        class="social-button">
                        Continue with Google
                    </a>

                    <a
                        href="<%= request.getContextPath() %>/github-login"
                        class="social-button">
                        Continue with GitHub
                    </a>

                </div>

                <div class="register-box">

                    <p>
                        New to Digital Wallet?
                    </p>

                    <a
                        href="<%= request.getContextPath() %>/register.jsp"
                        class="register-button">
                        Create New Account
                    </a>

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

<script>
    const passwordInput =
        document.getElementById("password");

    const togglePassword =
        document.getElementById("togglePassword");

    togglePassword.addEventListener(
        "click",
        function () {

            if (passwordInput.type === "password") {

                passwordInput.type = "text";
                togglePassword.textContent = "🙈";

                togglePassword.setAttribute(
                    "aria-label",
                    "Hide password"
                );

            } else {

                passwordInput.type = "password";
                togglePassword.textContent = "👁️";

                togglePassword.setAttribute(
                    "aria-label",
                    "Show password"
                );
            }
        }
    );
</script>

</body>
</html>
```
