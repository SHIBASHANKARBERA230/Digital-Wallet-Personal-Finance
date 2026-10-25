<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Reset Password - Digital Wallet</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            min-height: 100vh;

            display: flex;
            align-items: center;
            justify-content: center;

            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 450px;

            background: white;

            border-radius: 14px;

            padding: 40px;

            box-shadow:
                    0 8px 25px rgba(0, 0, 0, 0.10);
        }

        .logo {
            text-align: center;
            font-size: 42px;
            margin-bottom: 15px;
        }

        h1 {
            text-align: center;
            color: #1f2937;
            font-size: 26px;
            margin-bottom: 10px;
        }

        .description {
            text-align: center;
            color: #667085;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            color: #344054;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .form-input {
            width: 100%;
            height: 46px;
            border: 1px solid #d0d5dd;
            border-radius: 8px;
            padding: 0 14px;
            font-size: 14px;
            outline: none;
        }

        .form-input:focus {
            border-color: #667eea;

            box-shadow:
                    0 0 0 3px
                    rgba(102, 126, 234, 0.12);
        }

        .submit-button {
            width: 100%;
            height: 46px;
            border: none;
            border-radius: 8px;
            background: #667eea;
            color: white;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
        }

        .submit-button:hover {
            background: #5568d9;
        }

        .error {
            background: #fef3f2;
            color: #b42318;
            border: 1px solid #fecdca;
            border-radius: 8px;
            padding: 12px;
            font-size: 13px;
            margin-bottom: 20px;
        }

        .password-hint {
            color: #667085;
            font-size: 12px;
            margin-top: 6px;
        }

        .back-link {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: bold;
        }

        .back-link a:hover {
            text-decoration: underline;
        }

    </style>

</head>

<body>

<div class="container">

    <div class="logo">
        🔑
    </div>

    <h1>
        Reset Password
    </h1>

    <p class="description">
        Create a new password for your
        Digital Wallet account.
    </p>

    <%
        String error =
                (String) request.getAttribute("error");

        if (error != null) {
    %>

        <div class="error">
            <%= error %>
        </div>

    <%
        }
    %>

    <form
            action="<%= request.getContextPath() %>/reset-password"
            method="post">

        <!-- Reset token -->
        <input
                type="hidden"
                name="token"
                value="<%= request.getParameter("token") %>">

        <div class="form-group">

            <label for="newPassword">
                New Password
            </label>

            <input
                    type="password"
                    id="newPassword"
                    name="newPassword"
                    class="form-input"
                    placeholder="Enter new password"
                    minlength="6"
                    required>

            <div class="password-hint">
                Password must contain at least 6 characters.
            </div>

        </div>

        <div class="form-group">

            <label for="confirmPassword">
                Confirm Password
            </label>

            <input
                    type="password"
                    id="confirmPassword"
                    name="confirmPassword"
                    class="form-input"
                    placeholder="Confirm new password"
                    minlength="6"
                    required>

        </div>

        <button
                type="submit"
                class="submit-button">

            Reset Password

        </button>

    </form>

    <div class="back-link">

        <a href="<%= request.getContextPath() %>/login.jsp">
            ← Back to Login
        </a>

    </div>

</div>

</body>

</html>