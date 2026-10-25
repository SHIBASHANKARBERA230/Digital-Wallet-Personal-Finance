```jsp
<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width,
                   initial-scale=1.0">
    <title>Digital Wallet</title>

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
            min-height: 90px;
            padding: 18px 5%;
            background: white;
            border-bottom: 1px solid #e5e9f2;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .brand-logo {
            width: 55px;
            height: 55px;
            object-fit: contain;
        }

        .brand-name {
            color: #1268f3;
            font-size: 23px;
            font-weight: bold;
        }

        .brand-subtitle {
            margin-top: 3px;
            color: #667085;
            font-size: 12px;
        }

        .header-login {
            display: inline-block;
            padding: 11px 23px;
            background: #1268f3;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
        }

        .header-login:hover {
            background: #0753cf;
        }

        .hero {
            width: 100%;
            min-height: 470px;
            padding: 70px 5%;
            background: linear-gradient(
                135deg,
                #1268f3,
                #0649b9
            );
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 50px;
        }

        .hero-content {
            width: 55%;
            max-width: 800px;
        }

        .hero-badge {
            display: inline-block;
            padding: 8px 14px;
            background: rgba(255,255,255,.15);
            border: 1px solid rgba(255,255,255,.25);
            border-radius: 20px;
            font-size: 12px;
            margin-bottom: 20px;
        }

        .hero-title {
            margin: 0;
            font-size: 48px;
            line-height: 1.15;
            font-weight: bold;
        }

        .hero-title span {
            color: #dceaff;
        }

        .hero-description {
            margin-top: 20px;
            max-width: 650px;
            font-size: 17px;
            line-height: 1.7;
            color: #edf4ff;
        }

        .hero-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn-primary {
            display: inline-block;
            padding: 14px 28px;
            background: white;
            color: #1268f3;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
        }

        .btn-primary:hover {
            background: #f1f5ff;
        }

        .btn-secondary {
            display: inline-block;
            padding: 13px 28px;
            background: transparent;
            color: white;
            text-decoration: none;
            border: 1px solid rgba(255,255,255,.7);
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
        }

        .btn-secondary:hover {
            background: rgba(255,255,255,.1);
        }

        .hero-visual {
            width: 40%;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .wallet-circle {
            width: 300px;
            height: 300px;
            border-radius: 50%;
            background: rgba(255,255,255,.12);
            border: 1px solid rgba(255,255,255,.2);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .wallet-circle img {
            width: 190px;
            height: 190px;
            object-fit: contain;
        }

        .features-section {
            width: 100%;
            padding: 65px 5%;
            background: #f4f7fb;
        }

        .section-heading {
            text-align: center;
            margin-bottom: 40px;
        }

        .section-heading h2 {
            margin: 0;
            font-size: 30px;
            color: #172033;
        }

        .section-heading p {
            margin-top: 10px;
            color: #667085;
            font-size: 14px;
        }

        .features {
            width: 100%;
            max-width: 1600px;
            margin: auto;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
        }

        .feature-card {
            min-height: 220px;
            padding: 30px;
            background: white;
            border: 1px solid #e3e8f0;
            border-radius: 14px;
            text-align: center;
            box-shadow: 0 5px 18px rgba(0,0,0,.04);
            transition: .2s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,.08);
        }

        .feature-icon {
            width: 65px;
            height: 65px;
            margin: auto;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 15px;
            background: #eef4ff;
            font-size: 30px;
        }

        .feature-title {
            margin-top: 18px;
            font-size: 19px;
            font-weight: bold;
            color: #172033;
        }

        .feature-text {
            margin-top: 10px;
            color: #667085;
            font-size: 13px;
            line-height: 1.7;
        }

        .how-section {
            width: 100%;
            padding: 65px 5%;
            background: white;
        }

        .steps {
            max-width: 1300px;
            margin: auto;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
        }

        .step {
            text-align: center;
            padding: 25px;
        }

        .step-number {
            width: 50px;
            height: 50px;
            margin: auto;
            border-radius: 50%;
            background: #1268f3;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: bold;
        }

        .step h3 {
            margin-top: 18px;
            font-size: 17px;
        }

        .step p {
            color: #667085;
            font-size: 13px;
            line-height: 1.6;
        }

        .cta {
            width: 100%;
            padding: 65px 5%;
            background: linear-gradient(
                135deg,
                #1268f3,
                #0753cf
            );
            text-align: center;
            color: white;
        }

        .cta h2 {
            margin: 0;
            font-size: 31px;
        }

        .cta p {
            margin: 12px 0 25px;
            color: #e8f0ff;
            font-size: 14px;
        }

        .cta-button {
            display: inline-block;
            padding: 14px 32px;
            background: white;
            color: #1268f3;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            font-size: 14px;
        }

        .footer {
            width: 100%;
            padding: 30px 5%;
            background: #172033;
            color: #aeb7c7;
            text-align: center;
            font-size: 12px;
        }

        .footer-links {
            margin-bottom: 12px;
        }

        .footer-links a {
            color: #d7deea;
            text-decoration: none;
            margin: 0 12px;
        }

        .footer-links a:hover {
            color: white;
        }

        @media (max-width: 1000px) {
            .hero {
                flex-direction: column;
                text-align: center;
            }

            .hero-content {
                width: 100%;
            }

            .hero-description {
                margin-left: auto;
                margin-right: auto;
            }

            .hero-buttons {
                justify-content: center;
            }

            .hero-visual {
                width: 100%;
            }

            .features {
                grid-template-columns: repeat(2, 1fr);
            }

            .steps {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 700px) {
            .header {
                padding: 15px 20px;
            }

            .header-login {
                display: none;
            }

            .hero {
                padding: 55px 25px;
            }

            .hero-title {
                font-size: 36px;
            }

            .hero-description {
                font-size: 15px;
            }

            .wallet-circle {
                width: 230px;
                height: 230px;
            }

            .wallet-circle img {
                width: 145px;
                height: 145px;
            }

            .features-section,
            .how-section {
                padding: 50px 20px;
            }

            .features {
                grid-template-columns: 1fr;
            }

            .steps {
                grid-template-columns: 1fr;
            }

            .hero-buttons {
                flex-direction: column;
            }

            .btn-primary,
            .btn-secondary {
                width: 100%;
                text-align: center;
            }
        }

        @media (max-width: 450px) {
            .brand-name {
                font-size: 19px;
            }

            .brand-subtitle {
                font-size: 10px;
            }

            .brand-logo {
                width: 45px;
                height: 45px;
            }

            .hero-title {
                font-size: 30px;
            }

            .section-heading h2 {
                font-size: 25px;
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
            href="login.jsp"
            class="header-login">
            Login
        </a>

    </header>

    <section class="hero">

        <div class="hero-content">

            <div class="hero-badge">
                Secure, Simple, Smart
            </div>

            <h1 class="hero-title">
                Manage Your Money
                <span>Smarter</span>
            </h1>

            <p class="hero-description">
                Securely manage your wallet, income,
                expenses, transactions, budgets and
                savings goals — all in one place.
            </p>

            <div class="hero-buttons">

                <a
                    href="login.jsp"
                    class="btn-primary">
                    Login
                </a>

                <a
                    href="register.jsp"
                    class="btn-secondary">
                    Create Account
                </a>

            </div>

        </div>

        <div class="hero-visual">

            <div class="wallet-circle">

                <img
                    src="images/wallet-logo.png"
                    alt="Digital Wallet">

            </div>

        </div>

    </section>

    <section class="features-section">

        <div class="section-heading">

            <h2>
                Everything You Need
            </h2>

            <p>
                Manage your personal finances
                from one simple platform.
            </p>

        </div>

        <div class="features">

            <div class="feature-card">

                <div class="feature-icon">
                    💳
                </div>

                <div class="feature-title">
                    Digital Wallet
                </div>

                <div class="feature-text">
                    Manage your wallet balance,
                    deposits and withdrawals easily
                    from one place.
                </div>

            </div>

            <div class="feature-card">

                <div class="feature-icon">
                    💰
                </div>

                <div class="feature-title">
                    Transactions
                </div>

                <div class="feature-text">
                    Track income, expenses and
                    transfers while keeping your
                    transaction history organized.
                </div>

            </div>

            <div class="feature-card">

                <div class="feature-icon">
                    📊
                </div>

                <div class="feature-title">
                    Personal Finance
                </div>

                <div class="feature-text">
                    Create budgets, monitor spending,
                    set savings goals and understand
                    your financial activity.
                </div>

            </div>

        </div>

    </section>

    <section class="how-section">

        <div class="section-heading">

            <h2>
                Get Started in Three Steps
            </h2>

            <p>
                Start managing your finances
                quickly and easily.
            </p>

        </div>

        <div class="steps">

            <div class="step">

                <div class="step-number">
                    1
                </div>

                <h3>
                    Create Your Account
                </h3>

                <p>
                    Register your account and
                    securely set up your profile.
                </p>

            </div>

            <div class="step">

                <div class="step-number">
                    2
                </div>

                <h3>
                    Manage Your Wallet
                </h3>

                <p>
                    Add money, track your balance
                    and manage transactions.
                </p>

            </div>

            <div class="step">

                <div class="step-number">
                    3
                </div>

                <h3>
                    Control Your Finances
                </h3>

                <p>
                    Manage budgets, expenses,
                    reports and savings goals.
                </p>

            </div>

        </div>

    </section>

    <section class="cta">

        <h2>
            Ready to Manage Your Money?
        </h2>

        <p>
            Create your account and start
            managing your personal finances.
        </p>

        <a
            href="register.jsp"
            class="cta-button">
            Create Your Account
        </a>

    </section>

    <footer class="footer">

        <div class="footer-links">

            <a href="login.jsp">
                Login
            </a>

            <a href="register.jsp">
                Register
            </a>

        </div>

        <div>
            Secure
            &nbsp;&nbsp; | &nbsp;&nbsp;
            Easy to Use
            &nbsp;&nbsp; | &nbsp;&nbsp;
            Finance Management
        </div>

        <br>

        <div>
            © 2026 Digital Wallet
        </div>

        <div>
            Personal Finance Management System
        </div>

    </footer>

</div>

</body>
</html>
```
