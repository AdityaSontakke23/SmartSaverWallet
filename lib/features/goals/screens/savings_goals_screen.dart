import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../models/goal_model.dart';
import '../widgets/goal_card.dart';
import '../widgets/goal_overview_card.dart';
import '../services/goals_repository.dart';
import '../screens/add_goal_screen.dart';
import '../screens/edit_goal_screen.dart';

class SavingsGoalsScreen extends StatefulWidget {
  const SavingsGoalsScreen({Key? key}) : super(key: key);

  @override
  State<SavingsGoalsScreen> createState() => _SavingsGoalsScreenState();
}

class _SavingsGoalsScreenState extends State<SavingsGoalsScreen>
    with SingleTickerProviderStateMixin {
  final _repo = GoalsRepository();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _deleteGoal(String goalId, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal'),
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
        await _repo.deleteGoal(goalId);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Goal "$title" deleted'),
            backgroundColor: AppColors.success,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting goal: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _addContribution(GoalModel goal) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add to ${goal.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current: ₹${goal.currentAmount.toStringAsFixed(0)} / ₹${goal.targetAmount.toStringAsFixed(0)}',
              style: AppTextStyles.bodyMedium(context),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
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
                final amount = double.tryParse(controller.text) ?? 0;
                if (amount <= 0) {
                  throw Exception('Please enter a valid amount');
                }

                await _repo.contributeToGoal(
                  goalId: goal.id,
                  amount: amount,
                );

                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contribution added successfully'),
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

  Future<void> _markComplete(GoalModel goal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Goal'),
        content: Text(
          'Mark "${goal.title}" as completed?\n\nYou can still view it in the Completed tab.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Mark Complete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _repo.markCompleted(goal.id);
        if (!mounted) return;
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Goal completed! Congratulations!'),
            backgroundColor: AppColors.success,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
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
          'Savings Goals',
          style: AppTextStyles.sectionHeader(context),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.greenStart,
          labelColor: AppColors.greenStart,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: StreamBuilder(
  stream: _repo.streamUserGoals(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${snapshot.error}'),
          ],
        ),
      );
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return _buildEmptyView();
    }

    final goalDocs = snapshot.data!.docs;
    
    
    final allGoals = goalDocs
        .map<GoalModel>((doc) => GoalModel.fromDocument(doc))
        .toList()
      ..sort((a, b) {
        
        final aDate = a.createdAt ?? DateTime(2000);
        final bDate = b.createdAt ?? DateTime(2000);
        return bDate.compareTo(aDate);
      });

    
    final activeGoals = allGoals.where((g) => !g.isCompleted).toList();
    final completedGoals = allGoals.where((g) => g.isCompleted).toList();

    
    final totalSaved = allGoals.fold<double>(
      0.0,
      (sum, goal) => sum + goal.currentAmount,
    );

    return Column(
      children: [
        
        GoalOverviewCard(
          totalSaved: totalSaved,
          activeGoals: activeGoals.length,
          completedGoals: completedGoals.length,
        ),

        
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildGoalsList(activeGoals, isActive: true),
              _buildGoalsList(completedGoals, isActive: false),
            ],
          ),
        ),
      ],
    );
  },
),

      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddGoalScreen(),
                  ),
                );
              },
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
                    colors: [AppColors.greenStart, AppColors.greenEnd],
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
                        'Create New Goal',
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

  Widget _buildGoalsList(List<GoalModel> goals, {required bool isActive}) {
  if (goals.isEmpty) {
    
  }

  return ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: goals.length,
    separatorBuilder: (_, __) => const SizedBox(height: 16),
    itemBuilder: (context, index) {
      final goal = goals[index];
      final progress = goal.targetAmount == 0
          ? 0.0
          : (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);

      return GoalCard(
        goal: goal,
        onTap: () async {
          
          if (progress >= 1.0 && !goal.isCompleted) {
            final markComplete = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('🎉 Goal Reached!'),
                content: Text(
                  'Congratulations! You\'ve reached your "${goal.title}" goal!\n\nWould you like to mark it as complete?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Not Yet'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                    child: const Text('Mark Complete'),
                  ),
                ],
              ),
            );

            if (markComplete == true) {
              await _markComplete(goal);
            } else {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditGoalScreen(goal: goal),
                ),
              );
            }
          } else {
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditGoalScreen(goal: goal),
              ),
            );
          }
        },
        onAddContribution: isActive ? () => _addContribution(goal) : null,
        onDelete: isActive ? () => _deleteGoal(goal.id, goal.title) : null,
      );
    },
  );
}


  Widget _buildEmptyView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.greenStart.withOpacity(0.2),
                  AppColors.greenEnd.withOpacity(0.1),
                ],
              ),
            ),
            child: const Icon(
              Icons.flag_outlined,
              size: 100,
              color: AppColors.greenStart,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Start Your Savings Journey',
            style: AppTextStyles.h1(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Set goals and track your progress towards achieving your dreams',
            style: AppTextStyles.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _buildFeatureItem(
            icon: Icons.flag,
            title: 'Set Clear Goals',
            description: 'Define what you\'re saving for',
          ),
          const SizedBox(height: 20),
          _buildFeatureItem(
            icon: Icons.trending_up,
            title: 'Track Progress',
            description: 'Watch your savings grow',
          ),
          const SizedBox(height: 20),
          _buildFeatureItem(
            icon: Icons.celebration,
            title: 'Achieve Dreams',
            description: 'Reach your financial targets',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.greenStart.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.greenStart.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.greenStart, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h4(context),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
