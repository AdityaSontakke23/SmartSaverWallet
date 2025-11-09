import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../models/budget_model.dart';
import '../widgets/budget_progress.dart';
import '../widgets/budget_benefit_card.dart';
import '../widgets/budget_card.dart';
import '../widgets/monthly_summary_card.dart';
import '../services/budgets_repository.dart';
import '../screens/add_budget_screen.dart';
import '../screens/edit_budget_screen.dart';


class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _repo = BudgetsRepository();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _spendCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _spendCtrl.dispose();
    super.dispose();
  }

  // Delete budget function
  Future<void> _deleteBudget(String budgetId, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Budget'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _repo.deleteBudget(budgetId);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Budget "$title" deleted'),
            backgroundColor: AppColors.success,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting budget: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // Edit budget function
  Future<void> _editBudget(BudgetModel budget) async {
    // Navigate to EditBudgetScreen
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBudgetScreen(budget: budget),
      ),
    );
  }

  // Add spend to budget function
  Future<void> _addSpendToBudget(BudgetModel budget) async {
    _spendCtrl.clear();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Spend to ${budget.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current: ₹${budget.spent.toStringAsFixed(0)} / ₹${budget.amount.toStringAsFixed(0)}',
              style: AppTextStyles.bodyMedium(context),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _spendCtrl,
              decoration: const InputDecoration(
                labelText: 'Amount to add',
                prefixText: '₹',
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final amount = double.tryParse(_spendCtrl.text) ?? 0;

                if (amount <= 0) {
                  throw Exception('Please enter a valid amount');
                }

                await _repo.addSpend(
                  budgetId: budget.id,
                  amount: amount,
                );
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Spend added successfully'),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
  Future<void> _showAddBudgetDialog() async {
    // Navigate to AddBudgetScreen instead of showing dialog
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddBudgetScreen(),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkPrimaryBackground
          : AppColors.lightPrimaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Budgets',
          style: AppTextStyles.sectionHeader(context),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _repo.streamUserBudgets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmptyView(context);
            }

            final budgetDocs = snapshot.data!.docs;
            final budgetsList = budgetDocs
                .map<BudgetModel>((doc) => BudgetModel.fromDocument(doc))
                .toList();

            return _buildPopulatedView(context, budgetsList);
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCardBackground : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _showAddBudgetDialog,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.orangeStart, AppColors.orangeEnd],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_circle_outline,
                          color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Create New Budget',
                        style: AppTextStyles.button(context).copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.orangeStart.withOpacity(0.2),
                  AppColors.orangeEnd.withOpacity(0.1),
                ],
              ),
            ),
            child: const Icon(
              Icons.pie_chart_outline,
              size: 100,
              color: AppColors.orangeStart,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Take Control of Your Spending',
            style: AppTextStyles.h1(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Set budgets for different categories and track your progress',
            style: AppTextStyles.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          const BudgetBenefitCard(
            icon: Icons.category_outlined,
            title: 'Set Category Limits',
            description:
                'Define spending limits for different expense categories',
          ),
          const SizedBox(height: 16),
          const BudgetBenefitCard(
            icon: Icons.track_changes_outlined,
            title: 'Track Progress',
            description: 'Monitor your spending against set budgets',
          ),
          const SizedBox(height: 16),
          const BudgetBenefitCard(
            icon: Icons.notifications_active_outlined,
            title: 'Get Alerts',
            description: 'Receive notifications when nearing budget limits',
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.orangeStart.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Example Budget',
                  style: AppTextStyles.h4(context),
                ),
                const SizedBox(height: 16),
                BudgetProgress(
                  budget: BudgetModel(
                    id: 'example',
                    uid: 'example-uid',
                    title: 'Shopping',
                    amount: 2000,
                    spent: 500,
                    startDate: DateTime.now(),
                    endDate: DateTime.now().add(const Duration(days: 30)),
                    category: 'Shopping',
                    isActive: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPopulatedView(BuildContext context, List<BudgetModel> budgets) {
    double totalBudget = 0;
    double totalSpent = 0;

    for (var budget in budgets) {
      totalBudget += budget.amount;
      totalSpent += budget.spent;
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: MonthlySummaryCard(
              totalBudgeted: totalBudget,
              totalSpent: totalSpent,
              progress: totalBudget > 0 ? totalSpent / totalBudget : 0,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final budget = budgets[index];
              String periodText;
              if (budget.month != null && budget.month!.isNotEmpty) {
                periodText = budget.month!;
              } else if (budget.startDate != null && budget.endDate != null) {
                final s =
                    budget.startDate!.toLocal().toString().split(' ').first;
                final e = budget.endDate!.toLocal().toString().split(' ').first;
                periodText = '$s - $e';
              } else {
                periodText = 'No period set';
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Dismissible(
                  key: Key(budget.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Budget'),
                        content: Text(
                          'Are you sure you want to delete "${budget.title}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    await _repo.deleteBudget(budget.id);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Budget "${budget.title}" deleted'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  child: BudgetCard(
                    title: budget.title,
                    amount: budget.amount,
                    spent: budget.spent,
                    progress:
                        budget.amount > 0 ? budget.spent / budget.amount : 0,
                    daysRemaining:
                        budget.endDate?.difference(DateTime.now()).inDays ?? 0,
                    isExceeded: budget.spent > budget.amount,
                    periodText: periodText,
                    onDelete: () => _deleteBudget(budget.id, budget.title),
                    onTap: () => _editBudget(budget),
                    onAddSpend: () => _addSpendToBudget(budget),
                  ),
                ),
              );
            },
            childCount: budgets.length,
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }
}
