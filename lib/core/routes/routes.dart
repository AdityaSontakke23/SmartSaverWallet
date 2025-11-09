// lib/core/routes/routes.dart
import 'package:flutter/material.dart';

// Auth
import 'package:smartsaverwallet/features/auth/screens/splash_screen.dart';
import 'package:smartsaverwallet/features/auth/screens/login_screen.dart';
// If your class name is SignUpScreen or RegisterScreen, import with alias:
import 'package:smartsaverwallet/features/auth/screens/signup_screen.dart' as signups;

// Home
import 'package:smartsaverwallet/features/home/screens/home_screen.dart';

// Settings
import 'package:smartsaverwallet/features/settings/screens/settings_screen.dart';

// Transactions
import 'package:smartsaverwallet/features/transactions/screens/transaction_list_screen.dart';
import 'package:smartsaverwallet/features/transactions/screens/add_transaction_screen.dart';

// Budget
import 'package:smartsaverwallet/features/budget/screens/budget_screen.dart';

// Goals
import 'package:smartsaverwallet/features/goals/screens/savings_goals_screen.dart';

class RoutePaths {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String settings = '/settings';

  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';

  static const String budget = '/budget';
  static const String goals = '/goals';
}

typedef ThemeSetter = void Function(ThemeMode);

ThemeSetter _extractThemeSetter(Object? args) {
  if (args is Map && args['onThemeChange'] is ThemeSetter) {
    return args['onThemeChange'] as ThemeSetter;
  }
  // Safe no-op fallback to prevent crashes if argument is temporarily omitted
  return (ThemeMode _) {};
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Splash is provided via `home:` in App so we typically won't hit this case,
      // but this keeps it available if you navigate to it explicitly.
      case RoutePaths.splash: {
        final onThemeChange = _extractThemeSetter(settings.arguments);
        return MaterialPageRoute(builder: (_) => SplashScreen(onThemeChange: onThemeChange));
      }
      case RoutePaths.login: {
        final onThemeChange = _extractThemeSetter(settings.arguments);
        return MaterialPageRoute(builder: (_) => LoginScreen(onThemeChange: onThemeChange));
      }
      case RoutePaths.signup: {
        // Replace `signups.SignupScreen()` with the exact class exported by your file:
        // e.g., `signups.SignUpScreen()` or `signups.RegisterScreen()`.
        final onThemeChange = _extractThemeSetter(settings.arguments);
        return MaterialPageRoute(builder: (_) => signups.SignUpScreen(onThemeChange: onThemeChange,));
      }
      case RoutePaths.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RoutePaths.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case RoutePaths.transactions:
        return MaterialPageRoute(builder: (_) => const TransactionListScreen());
      case RoutePaths.addTransaction:
        return MaterialPageRoute(builder: (_) => const AddTransactionScreen());
      case RoutePaths.budget:
        return MaterialPageRoute(builder: (_) => const BudgetScreen());
      case RoutePaths.goals:
        return MaterialPageRoute(builder: (_) => const SavingsGoalsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
