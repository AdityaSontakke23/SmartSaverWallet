# SmartSaver Wallet 💸

SmartSaver Wallet is a Flutter + Firebase personal finance app that helps you track expenses, manage budgets, and hit your savings goals with a clean and intuitive interface.

---

## ✨ Features

### 🏠 Dashboard & Home

- Overview of total balance, income, expenses, and savings in one place. 
- Double-tap privacy toggle to instantly hide or show all sensitive financial amounts.  
- Quick actions to add:
  - Transactions  
  - Budgets  
  - Savings goals

### 💳 Transactions

- Add income and expenses with:
  - Amount  
  - Category  
  - Description  
  - Date  
- See a chronological list of all transactions with real-time updates.  
- Long-press any transaction to:
  - Edit existing entries  
  - Delete entries with confirmation
- Reuse the same form for both creating and editing transactions (prefilled on edit).  

### 📊 Budgets

- Create budgets per category with:
  - Title  
  - Category  
  - Budget amount  
  - Start date  
  - End date  
- Budget cards showing:
  - Spent vs total amount  
  - Progress bar and utilization percentage  
- Quick “Add spend” action to increase used budget without re-creating.  
- Full edit support for all budget fields with automatic progress update.

### 🎯 Savings Goals

- Define savings goals with:
  - Goal name  
  - Target amount  
- Visual goal progress:
  - Current saved amount  
  - Remaining amount to target  

### 🔐 Authentication & User Management

- Email/password authentication using Firebase Authentication.  
- Splash screen that checks login state before routing to Home or Login. 
- Login and Sign Up screens wired to Firebase Auth.
- Settings screen with Logout and room for more user preferences. 

### 🧱 Architecture & Tech

- Built with Flutter and a modular widget-based architecture.  
- Firebase Authentication for secure user accounts.  
- Cloud Firestore for storing:
  - Transactions  
  - Budgets  
  - Savings goals  
  with `uid`-based separation for each user.  
- Indexed queries for efficient ordering and filtering by date and timestamps.  
- Centralized:
  - Constants  
  - Theme/colors  
  - Text styles  
  for consistent design.
- Named route navigation with a central route generator.  

### 🧩 Reusable UI Components

- Transaction list tiles and detail items.  
- Budget cards with progress indicators.  
- Goal progress widgets. 
- Settings list tiles and form buttons/inputs. 

### 🧾 Assets & Release

- Custom fonts and icons for a polished UI.  
- Lottie animations for the splash/loading experience. 
- Android release build configuration ready to generate APKs.  

---

## 🛠 Tech Stack

- **Framework**: Flutter (Dart)
- **Backend**: Firebase Authentication, Cloud Firestore  
- **Platforms**: Android (tested), iOS (supported with proper setup)

---

## 🚀 Getting Started

### 1. Prerequisites

- Flutter SDK installed and added to PATH.  
- Firebase project with:
  - Authentication (Email/Password) enabled  
  - Cloud Firestore enabled
- Android Studio or VS Code with Flutter/Dart extensions.

### 2. Clone the Repository

```bash
git clone <your-repo-url>.git
cd smartsaver_wallet
flutter run
