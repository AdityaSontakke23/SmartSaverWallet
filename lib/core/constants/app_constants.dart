class AppConstants {
  // App Info
  static const String appName = 'SmartSaverWallet';
  static const String appVersion = '1.0.0';

  // Firestore Collections
  static const String colUsers = 'users';
  static const String colTransactions = 'transactions';
  static const String colBudgets = 'budgets';
  static const String colGoals = 'goals';

  // Common Firestore Field Keys
  static const String fUid = 'uid';
  static const String fCreatedAt = 'createdAt';
  static const String fDate = 'date';
  static const String fAmount = 'amount';
  static const String fType = 'type';
  static const String fCategory = 'category';
  static const String fDescription = 'description';
  static const String fTags = 'tags';
  static const String fBudgetId = 'budgetId';
  static const String fGoalId = 'goalId';

  // Budgets fields
  static const String fBudgetSpent = 'spent';
  static const String fBudgetMonth = 'month';
  static const String fBudgetIsActive = 'isActive';
  static const String fBudgetStartDate = 'startDate';
  static const String fBudgetEndDate = 'endDate';
  static const String fBudgetTitle = 'title';

  // Goals fields
  static const String fGoalTitle = 'title';
  static const String fGoalTargetAmount = 'targetAmount';
  static const String fGoalCurrentAmount = 'currentAmount';
  static const String fGoalTargetDate = 'targetDate';
  static const String fGoalIsCompleted = 'isCompleted';
  static const String fGoalArchived = 'archived';

  // User Profile fields
  static const String fProfile = 'profile';
  static const String fProfileName = 'name';
  static const String fProfileEmail = 'email';
  static const String fProfilePhotoURL = 'photoURL';
  static const String fProfileCurrency = 'currency';
  static const String fProfileTheme = 'theme';
  static const String fProfileNotificationsEnabled = 'notificationsEnabled';

  static const String fSettings = 'settings';
  static const String fSettingsBudgetAlerts = 'budgetAlerts';
  static const String fSettingsGoalReminders = 'goalReminders';
  static const String fSettingsMonthlyReports = 'monthlyReports';

  // Transaction types
  static const String txIncome = 'income';
  static const String txExpense = 'expense';

  // Local Storage Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyThemeMode = 'theme_mode';


  static const Duration splashDuration = Duration(seconds: 6);
  static const Duration animationDuration = Duration(milliseconds: 300);


  static const double defaultPadding = 16.0;
  static const double cardRadius = 12.0;
  static const int maxTransactionHistory = 100;


  static DateTime startOfMonth(DateTime dt) => DateTime(dt.year, dt.month, 1);
  static DateTime endOfMonth(DateTime dt) =>
      DateTime(dt.year, dt.month + 1, 1).subtract(const Duration(milliseconds: 1));


  static String yyyymm(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
}
