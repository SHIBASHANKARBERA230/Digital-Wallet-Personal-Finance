
# 💳 Digital Wallet & Personal Finance Management System

## 📌 About the Project

The **Digital Wallet & Personal Finance Management System** is an Advanced Java web application that allows users to manage their wallet, simulate money transfers, track transactions, and manage personal expenses.

Users can register, login securely, add/withdraw simulated money, send and receive money, view transaction history, categorize expenses, and check monthly financial summaries.

An **Admin Dashboard** allows administrators to manage users and block/unblock accounts.

> ⚠️ Educational project. No real money or payment processing is involved.

---

## 🚀 Key Features

- 👤 User Registration & Login
- 🔐 Session-Based Authentication
- 💳 Digital Wallet Management
- ➕ Simulated Deposit & Add Money
- ➖ Simulated Withdrawal
- 💸 Send & Receive Money
- 📋 Transaction History
- 🔎 Search & Filter Transactions
- 📊 Expense Categorization
- 📈 Monthly Income & Expense Summary
- 👨‍💼 Admin Dashboard
- 🚫 Block / Unblock Users
- 🔄 Transaction Status: SUCCESS, FAILED, PENDING

---

## 🏗️ Architecture

```text
🌐 JSP
   ↓
⚙️ Servlet
   ↓
🧠 Service Layer
   ↓
🗄️ DAO
   ↓
🔌 JDBC
   ↓
🐬 MySQL


The project follows MVC architecture and uses a layered design.

🛠️ Technologies Used
☕ Java
🌐 JSP
⚙️ Servlets
🏛️ MVC Architecture
🧠 Service Layer
🗄️ DAO Pattern
🔌 JDBC
🐬 MySQL
🔐 HttpSession
🛡️ Servlet Filters
🔑 Password Hashing
🔄 JDBC Transactions
🐱 Apache Tomcat
📦 Maven
🐙 Git & GitHub
💾 Database
users
├── id
├── name
├── email
├── password
├── phone
├── role
└── status

wallets
├── id
├── user_id
└── balance

transactions
├── id
├── sender_id
├── receiver_id
├── amount
├── transaction_type
├── status
└── transaction_date

expenses
├── id
├── user_id
├── category
├── amount
└── expense_date
📁 Project Structure
Digital-Wallet-Personal-Finance/
│
├── src/main/java/com/digitalwallet/
│   ├── controller/
│   ├── service/
│   ├── dao/
│   ├── model/
│   ├── filter/
│   └── util/
│
├── src/main/webapp/
│   ├── JSP Pages
│   ├── css/
│   ├── js/
│   └── WEB-INF/
│
├── database/
│   └── digital_wallet.sql
│
├── pom.xml
├── README.md
└── .gitignore
👥 GitHub Team Collaboration
main
│
├── feature/integration       → 👨‍💻 Project Lead
├── feature/authentication    → 👨‍💻 Authentication
├── feature/wallet            → 👨‍💻 Wallet
├── feature/transactions      → 👨‍💻 Transactions & Expenses
└── feature/database          → 👨‍💻 Database & JDBC


🎓 Advanced Java Concepts

This project demonstrates:

JSP • Servlets • MVC • Service Layer • DAO • JDBC • MySQL • HttpSession • Servlet Filters • PreparedStatement • Password Hashing • Role-Based Access • Commit/Rollback • Exception Handling

⚠️ Security
🔐 Passwords should be securely hashed.
🛡️ PreparedStatement is used for database queries.
🚫 Never commit database passwords or API keys.
💳 Wallet and payment operations are simulated.
🚀 Future Enhancements
🌐 REST API
📊 Advanced Financial Analytics
📈 Expense Charts
📄 PDF/Excel Reports
🔐 Two-Factor Authentication
📁 KYC Document Upload
💳 Payment Gateway Integration
💳 Project Motto

💰 Manage Money • 📊 Track Expenses • 💸 Transfer Securely • 🔐 Stay Protected

❤️ Built with Advanced Java
