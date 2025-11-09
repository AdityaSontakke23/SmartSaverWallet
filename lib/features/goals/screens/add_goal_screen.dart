import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../services/goals_repository.dart';
import '../widgets/goal_icon_picker.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({Key? key}) : super(key: key);

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();
  final _repo = GoalsRepository();

  String? _selectedCategory;
  DateTime? _targetDate;
  bool _isLoading = false;

  final List<double> _suggestedAmounts = [10000, 25000, 50000, 100000];

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryBackground
          : AppColors.lightPrimaryBackground,
      body: CustomScrollView(
        slivers: [
          
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
                    colors: [AppColors.greenStart, AppColors.greenEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.flag_outlined, size: 64, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        'Create Goal',
                        style: AppTextStyles.h2(context).copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'What are you saving for?',
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

          
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    
                    _buildSectionTitle('Goal Title'),
                    const SizedBox(height: 12),
                    _buildTitleInput(),
                    const SizedBox(height: 24),

                    
                    _buildSectionTitle('Choose Icon'),
                    const SizedBox(height: 12),
                    GoalIconPicker(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category, icon) {
                        setState(() => _selectedCategory = category);
                      },
                    ),
                    const SizedBox(height: 24),

                    
                    _buildSectionTitle('Target Amount'),
                    const SizedBox(height: 12),
                    _buildAmountInput(
                      controller: _targetAmountController,
                      hint: 'How much do you need?',
                    ),
                    const SizedBox(height: 12),
                    _buildQuickAmounts(),
                    const SizedBox(height: 24),

                    
                    _buildSectionTitle('Current Savings (Optional)'),
                    const SizedBox(height: 12),
                    _buildAmountInput(
                      controller: _currentAmountController,
                      hint: 'Already saved amount',
                    ),
                    const SizedBox(height: 24),

                    
                    _buildSectionTitle('Target Date'),
                    const SizedBox(height: 12),
                    _buildDatePicker(),
                    const SizedBox(height: 32),

                    
                    SizedBox(
                      height: 56,
                      child: GradientButton(
                        onPressed: _isLoading ? () {} : _createGoal,
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
                                    'Create Goal',
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

  Widget _buildAmountInput({
    required TextEditingController controller,
    required String hint,
  }) {
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
        controller: controller,
        keyboardType: TextInputType.number,
        style: AppTextStyles.h1(context).copyWith(
          color: AppColors.greenStart,
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          prefixText: '₹ ',
          prefixStyle: AppTextStyles.h1(context).copyWith(
            color: AppColors.greenStart,
          ),
          hintText: hint,
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
        validator: controller == _targetAmountController
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter target amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              }
            : null,
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
            color: AppColors.greenStart.withOpacity(0.3),
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
            color: AppColors.greenStart.withOpacity(0.3),
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
            const Icon(Icons.calendar_today_outlined, color: AppColors.greenStart),
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
              primary: AppColors.greenStart,
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

  Future<void> _createGoal() async {
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
      final currentAmount = _currentAmountController.text.isEmpty
          ? 0.0
          : double.parse(_currentAmountController.text);

      final ref = await _repo.addGoal(
        title: _titleController.text.trim(),
        targetAmount: targetAmount,
        targetDate: _targetDate,
        category: _selectedCategory,
      );

      if (currentAmount > 0) {
        await _repo.contributeToGoal(
          goalId: ref.id,
          amount: currentAmount,
        );
      }

      if (!mounted) return;

      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goal created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating goal: $e'),
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
