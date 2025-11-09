import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../models/goal_model.dart';
import '../services/goals_repository.dart';
import '../widgets/goal_icon_picker.dart';

class EditGoalScreen extends StatefulWidget {
  final GoalModel goal;

  const EditGoalScreen({Key? key, required this.goal}) : super(key: key);

  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _targetAmountController;
  final _repo = GoalsRepository();

  String? _selectedCategory;
  DateTime? _targetDate;
  bool _isLoading = false;

  final List<double> _suggestedAmounts = [10000, 25000, 50000, 100000];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal.title);
    _targetAmountController = TextEditingController(
      text: widget.goal.targetAmount.toStringAsFixed(0),
    );
    _selectedCategory = widget.goal.category;
    _targetDate = widget.goal.targetDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = widget.goal.targetAmount == 0
        ? 0.0
        : (widget.goal.currentAmount / widget.goal.targetAmount).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryBackground
          : AppColors.lightPrimaryBackground,
      body: CustomScrollView(
        slivers: [
          // Gradient AppBar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.tealStart, AppColors.tealEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.edit_outlined, size: 64, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        'Edit Goal',
                        style: AppTextStyles.h2(context).copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Update your savings goal',
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Current Progress Info
                    _buildProgressInfo(progress),
                    const SizedBox(height: 24),

                    // Goal Title
                    _buildSectionTitle('Goal Title'),
                    const SizedBox(height: 12),
                    _buildTitleInput(),
                    const SizedBox(height: 24),

                    // Select Icon
                    _buildSectionTitle('Choose Icon'),
                    const SizedBox(height: 12),
                    GoalIconPicker(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category, icon) {
                        setState(() => _selectedCategory = category);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Target Amount
                    _buildSectionTitle('Target Amount'),
                    const SizedBox(height: 12),
                    _buildAmountInput(),
                    const SizedBox(height: 12),
                    _buildQuickAmounts(),
                    const SizedBox(height: 24),

                    // Target Date
                    _buildSectionTitle('Target Date'),
                    const SizedBox(height: 12),
                    _buildDatePicker(),
                    const SizedBox(height: 32),

                    // Update Button
                    SizedBox(
                      height: 56,
                      child: GradientButton(
                        onPressed: _isLoading ? () {} : _updateGoal,
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle_outline,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Update Goal',
                                    style: AppTextStyles.button(context),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressInfo(double progress) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.tealStart.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Current Progress',
            style: AppTextStyles.bodyMedium(context),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '₹${widget.goal.currentAmount.toStringAsFixed(0)}',
                    style: AppTextStyles.h3(context).copyWith(
                      color: AppColors.greenStart,
                    ),
                  ),
                  Text(
                    'Saved',
                    style: AppTextStyles.bodySmall(context),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              ),
              Column(
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: AppTextStyles.h3(context).copyWith(
                      color: AppColors.tealStart,
                    ),
                  ),
                  Text(
                    'Complete',
                    style: AppTextStyles.bodySmall(context),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.h4(context));
  }

  Widget _buildTitleInput() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _titleController,
        style: AppTextStyles.bodyLarge(context),
        decoration: InputDecoration(
          hintText: 'e.g., New Laptop',
          prefixIcon: const Icon(Icons.edit_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a goal title';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAmountInput() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _targetAmountController,
        keyboardType: TextInputType.number,
        style: AppTextStyles.h1(context).copyWith(
          color: AppColors.tealStart,
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          prefixText: '₹ ',
          prefixStyle: AppTextStyles.h1(context).copyWith(
            color: AppColors.tealStart,
          ),
          hintText: 'Target amount',
          hintStyle: AppTextStyles.bodyMedium(context).copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(24),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter target amount';
          }
          final amount = double.tryParse(value);
          if (amount == null || amount <= 0) {
            return 'Please enter a valid amount';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildQuickAmounts() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _suggestedAmounts.map((amount) {
        return ActionChip(
          label: Text(_formatAmount(amount)),
          onPressed: () {
            setState(() {
              _targetAmountController.text = amount.toStringAsFixed(0);
            });
            HapticFeedback.selectionClick();
          },
          backgroundColor: isDark
              ? AppColors.darkSurfaceColor
              : AppColors.lightSurfaceColor,
          side: BorderSide(
            color: AppColors.tealStart.withOpacity(0.3),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.tealStart.withOpacity(0.3),
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
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: AppColors.tealStart),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Target Date',
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _targetDate != null
                        ? DateFormat('dd MMM yyyy').format(_targetDate!)
                        : 'Select target date',
                    style: AppTextStyles.bodyLarge(context),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.tealStart,
              onPrimary: Colors.white,
              surface: Theme.of(context).cardColor,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _targetDate) {
      setState(() {
        _targetDate = picked;
      });
      HapticFeedback.selectionClick();
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  Future<void> _updateGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a goal icon'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final targetAmount = double.parse(_targetAmountController.text);

      await _repo.updateGoal(
        goalId: widget.goal.id,
        title: _titleController.text.trim(),
        targetAmount: targetAmount,
        targetDate: _targetDate,
        category: _selectedCategory,
      );

      if (!mounted) return;

      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goal updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating goal: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
