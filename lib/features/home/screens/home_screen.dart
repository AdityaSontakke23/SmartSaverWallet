import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/text_styles.dart';
import '../models/dashboard_model.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_actions.dart';
import '../../../core/routes/routes.dart';
import '../../../core/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final void Function(ThemeMode)? onThemeChange;
  const HomeScreen({Key? key, this.onThemeChange}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FirebaseFirestore _db;
  late final String _uid;
  Key _refreshKey = UniqueKey();
  bool _balanceVisible = true;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
    _uid = AuthService().uidOrThrow;
  }

  Future<double> _sumMonthly(String type, DateTime start, DateTime end) async {
    final base = _db
        .collection(AppConstants.colTransactions)
        .where(AppConstants.fUid, isEqualTo: _uid)
        .where(AppConstants.fType, isEqualTo: type)
        .where(AppConstants.fDate, isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where(AppConstants.fDate, isLessThanOrEqualTo: Timestamp.fromDate(end));
    try {
      final aggSnap = await base.aggregate(sum(AppConstants.fAmount)).get();
      final dynamic val = (() {
        try {
          return aggSnap.getSum(AppConstants.fAmount);
        } catch (_) {
          return null;
        }
      })();
      if (val is num) return val.toDouble();
    } catch (_) {}
    final snap = await base.get();
    double total = 0;
    for (final d in snap.docs) {
      total += (d.data()[AppConstants.fAmount] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  Future<double> _sumAllTime(String type) async {
    final base = _db
        .collection(AppConstants.colTransactions)
        .where(AppConstants.fUid, isEqualTo: _uid)
        .where(AppConstants.fType, isEqualTo: type);
    try {
      final aggSnap = await base.aggregate(sum(AppConstants.fAmount)).get();
      final dynamic val = (() {
        try {
          return aggSnap.getSum(AppConstants.fAmount);
        } catch (_) {
          return null;
        }
      })();
      if (val is num) return val.toDouble();
    } catch (_) {}
    final snap = await base.get();
    double total = 0;
    for (final d in snap.docs) {
      total += (d.data()[AppConstants.fAmount] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  Future<int> _countMonthlyTransactions(DateTime start, DateTime end) async {
    final q = _db
        .collection(AppConstants.colTransactions)
        .where(AppConstants.fUid, isEqualTo: _uid)
        .where(AppConstants.fDate, isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where(AppConstants.fDate, isLessThanOrEqualTo: Timestamp.fromDate(end));
    try {
      final agg = await q.count().get();
      final dynamic val = (() {
        try {
          return agg.count;
        } catch (_) {
          return null;
        }
      })();
      if (val is int) return val;
    } catch (_) {}
    final snap = await q.get();
    return snap.size;
  }

  Future<int> _countActiveGoals() async {
    final q = _db
        .collection(AppConstants.colGoals)
        .where(AppConstants.fUid, isEqualTo: _uid)
        .where(AppConstants.fGoalIsCompleted, isEqualTo: false);
    try {
      final agg = await q.count().get();
      final dynamic val = (() {
        try {
          return agg.count;
        } catch (_) {
          return null;
        }
      })();
      if (val is int) return val;
    } catch (_) {}
    final snap = await q.get();
    return snap.size;
  }

  Future<double> _sumMonthlyBudgets(DateTime now) async {
    final monthKey = AppConstants.yyyymm(now);
    final q = _db
        .collection(AppConstants.colBudgets)
        .where(AppConstants.fUid, isEqualTo: _uid)
        .where(AppConstants.fBudgetMonth, isEqualTo: monthKey);
    final snap = await q.get();
    double total = 0;
    for (final d in snap.docs) {
      total += (d.data()[AppConstants.fAmount] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  Future<DashboardModel> _fetchDashboard() async {
    final now = DateTime.now();
    final start = AppConstants.startOfMonth(now);
    final end = AppConstants.endOfMonth(now);

    final monthlyIncome = await _sumMonthly(AppConstants.txIncome, start, end);
    final monthlyExpenses = await _sumMonthly(AppConstants.txExpense, start, end);
    final transactionsCount = await _countMonthlyTransactions(start, end);
    final goalsCount = await _countActiveGoals();
    final monthlyBudget = await _sumMonthlyBudgets(now);

    final allIncome = await _sumAllTime(AppConstants.txIncome);
    final allExpense = await _sumAllTime(AppConstants.txExpense);
    final balance = allIncome - allExpense;
    final savings = monthlyIncome - monthlyExpenses;

    return DashboardModel(
      balance: balance,
      monthlyIncome: monthlyIncome,
      monthlyExpenses: monthlyExpenses,
      monthlyBudget: monthlyBudget,
      savings: savings,
      transactionsCount: transactionsCount,
      goalsCount: goalsCount,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _refreshKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartSaver Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, RoutePaths.settings);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<DashboardModel>(
          key: _refreshKey,
          future: _fetchDashboard(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No dashboard data.'));
            }
            final dashboard = snapshot.data!;
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        _balanceVisible = !_balanceVisible;
                      });
                      HapticFeedback.mediumImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                _balanceVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(_balanceVisible ? 'Balance visible' : 'Balance hidden'),
                            ],
                          ),
                          duration: const Duration(milliseconds: 1200),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                    child: BalanceCard(
                      balance: dashboard.balance,
                      isVisible: _balanceVisible,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const QuickActions(),
                  const SizedBox(height: 24),
                  Text('This Month', style: AppTextStyles.h3(context)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _StatCard(
                        label: 'Income',
                        value: dashboard.monthlyIncome,
                        color: Colors.green,
                        isVisible: _balanceVisible, // Pass visibility state
                      ),
                      const SizedBox(width: 8),
                      _StatCard(
                        label: 'Expenses',
                        value: dashboard.monthlyExpenses,
                        color: Colors.red,
                        isVisible: _balanceVisible,
                      ),
                      const SizedBox(width: 8),
                      _StatCard(
                        label: 'Savings',
                        value: dashboard.savings,
                        color: Theme.of(context).colorScheme.primary,
                        isVisible: _balanceVisible,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Summary', style: AppTextStyles.h3(context)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _SummaryCard(
                        label: 'Transactions',
                        count: dashboard.transactionsCount,
                        icon: Icons.list_alt,
                      ),
                      const SizedBox(width: 8),
                      _SummaryCard(
                        label: 'Goals',
                        count: dashboard.goalsCount,
                        icon: Icons.flag,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isVisible;

  const _StatCard({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isVisible
                  ? '\₹${value.toStringAsFixed(2)}'
                  : '₹••••••',
                style: AppTextStyles.h4(context).copyWith(color: color),
              ),
              const SizedBox(height: 4),
              Text(label, style: AppTextStyles.bodySmall(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;

  const _SummaryCard({
    Key? key,
    required this.label,
    required this.count,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 8),
              Text('$count', style: AppTextStyles.h4(context)),
              const SizedBox(height: 4),
              Text(label, style: AppTextStyles.bodySmall(context)),
            ],
          ),
        ),
      ),
    );
  }
}
