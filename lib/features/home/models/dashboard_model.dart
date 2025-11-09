class DashboardModel {
  final double balance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double monthlyBudget;
  final double savings;
  final int transactionsCount;
  final int goalsCount;

  DashboardModel({
    required this.balance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.monthlyBudget,
    required this.savings,
    required this.transactionsCount,
    required this.goalsCount,
  });

  factory DashboardModel.fromMap(Map<String, dynamic> data) {
    return DashboardModel(
      balance: (data['balance'] as num?)?.toDouble() ?? 0.0,
      monthlyIncome: (data['monthlyIncome'] as num?)?.toDouble() ?? 0.0,
      monthlyExpenses: (data['monthlyExpenses'] as num?)?.toDouble() ?? 0.0,
      monthlyBudget: (data['monthlyBudget'] as num?)?.toDouble() ?? 0.0,
      savings: (data['savings'] as num?)?.toDouble() ?? 0.0,
      transactionsCount: data['transactionsCount'] as int? ?? 0,
      goalsCount: data['goalsCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
      'monthlyBudget': monthlyBudget,
      'savings': savings,
      'transactionsCount': transactionsCount,
      'goalsCount': goalsCount,
    };
  }
}
