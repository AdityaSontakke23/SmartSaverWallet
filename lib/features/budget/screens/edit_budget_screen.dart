import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/models/category.dart';
import '../models/budget_model.dart';
import '../services/budgets_repository.dart';

class EditBudgetScreen extends StatefulWidget {
  final BudgetModel budget;
  
  const EditBudgetScreen({Key? key, required this.budget}) : super(key: key);

  @override
  State<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  final _repo = BudgetsRepository();
  
  Category? _selectedCategory;
  String _selectedPeriod = 'Custom';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  final List<String> _periods = ['Weekly', 'Monthly', 'Yearly', 'Custom'];
  final List<double> _suggestedAmounts = [5000, 10000, 20000, 50000];

  final List<Category> _categories = [
    Category(id: 'food', name: 'Food', icon: Icons.restaurant, type: 'expense'),
    Category(id: 'shopping', name: 'Shopping', icon: Icons.shopping_bag, type: 'expense'),
    Category(id: 'transport', name: 'Transport', icon: Icons.directions_car, type: 'expense'),
    Category(id: 'bills', name: 'Bills', icon: Icons.receipt_long, type: 'expense'),
    Category(id: 'entertainment', name: 'Entertainment', icon: Icons.movie, type: 'expense'),
    Category(id: 'health', name: 'Healthcare', icon: Icons.local_hospital, type: 'expense'),
    Category(id: 'education', name: 'Education', icon: Icons.school, type: 'expense'),
    Category(id: 'other', name: 'Other', icon: Icons.category, type: 'expense'),
  ];

  @override
  void initState() {
    super.initState();
    // ✅ Pre-fill with existing budget data
    _titleController = TextEditingController(text: widget.budget.title);
    _amountController = TextEditingController(text: widget.budget.amount.toStringAsFixed(0));
    _startDate = widget.budget.startDate;
    _endDate = widget.budget.endDate;
    
    // Try to match category
    _selectedCategory = _categories.firstWhere(
      (cat) => cat.name.toLowerCase() == widget.budget.category.toLowerCase(),
      orElse: () => _categories.last, // Default to 'Other'
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
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
          // ✨ Beautiful gradient app bar
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
                    colors: [AppColors.purpleStart, AppColors.purpleEnd],
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
                        'Edit Budget',
                        style: AppTextStyles.h2(context).copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Update your budget settings',
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
                    // Budget Title
                    _buildSectionTitle('Budget Title'),
                    const SizedBox(height: 12),
                    _buildTitleInput(),
                    const SizedBox(height: 24),

                    // Select Category
                    _buildSectionTitle('Select Category'),
                    const SizedBox(height: 12),
                    _buildCategoryGrid(context),
                    const SizedBox(height: 24),

                    // Set Amount
                    _buildSectionTitle('Set Budget Amount'),
                    const SizedBox(height: 12),
                    _buildAmountSection(context),
                    const SizedBox(height: 24),

                    // Current Spent (Read-only info)
                    _buildSpentInfo(),
                    const SizedBox(height: 24),

                    // Budget Period
                    _buildSectionTitle('Budget Period'),
                    const SizedBox(height: 12),
                    _buildPeriodSection(context),
                    
                    const SizedBox(height: 16),
                    _buildDateRangePicker(context),
                    
                    const SizedBox(height: 32),

                    // Update Button
                    SizedBox(
                      height: 56,
                      child: GradientButton(
                        onPressed: _isLoading ? () {} : _updateBudget,
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
                                    'Update Budget',
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
          hintText: 'e.g., Monthly Groceries',
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
            return 'Please enter a budget title';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final isSelected = category == _selectedCategory;

        return GestureDetector(
          onTap: () {
            setState(() => _selectedCategory = category);
            HapticFeedback.selectionClick();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.purpleStart.withOpacity(0.15)
                  : isDark
                      ? AppColors.darkCardBackground
                      : AppColors.lightCardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.purpleStart : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category.icon,
                  size: 32,
                  color: isSelected
                      ? AppColors.purpleStart
                      : Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: isSelected
                        ? AppColors.purpleStart
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmountSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardBackground
                : AppColors.lightCardBackground,
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
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: AppTextStyles.h1(context).copyWith(
              color: AppColors.purpleStart,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: AppTextStyles.h1(context).copyWith(
                color: AppColors.purpleStart,
              ),
              hintText: '0',
              hintStyle: AppTextStyles.h1(context).copyWith(
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
                return 'Please enter an amount';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Please enter a valid amount';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Quick Select',
          style: AppTextStyles.bodySmall(context).copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestedAmounts.map((amount) {
            return ActionChip(
              label: Text('₹${_formatAmount(amount)}'),
              onPressed: () {
                setState(() {
                  _amountController.text = amount.toStringAsFixed(0);
                });
                HapticFeedback.selectionClick();
              },
              backgroundColor: isDark
                  ? AppColors.darkSurfaceColor
                  : AppColors.lightSurfaceColor,
              side: BorderSide(
                color: AppColors.purpleStart.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ✅ Show current spent amount (read-only)
  Widget _buildSpentInfo() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = widget.budget.amount > 0 
        ? widget.budget.spent / widget.budget.amount 
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.purpleStart.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Spending',
                style: AppTextStyles.bodyMedium(context),
              ),
              Text(
                '₹${widget.budget.spent.toStringAsFixed(0)}',
                style: AppTextStyles.h4(context).copyWith(
                  color: widget.budget.spent > widget.budget.amount
                      ? AppColors.error
                      : AppColors.purpleStart,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: isDark
                  ? AppColors.darkSurfaceColor
                  : AppColors.lightSurfaceColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.budget.spent > widget.budget.amount
                    ? AppColors.error
                    : AppColors.purpleStart,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% of budget used',
            style: AppTextStyles.bodySmall(context).copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSection(BuildContext context) {
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
      padding: const EdgeInsets.all(4),
      child: SegmentedButton<String>(
        segments: _periods.map((period) {
          IconData icon;
          switch (period) {
            case 'Weekly':
              icon = Icons.calendar_view_week;
              break;
            case 'Monthly':
              icon = Icons.calendar_month;
              break;
            case 'Yearly':
              icon = Icons.calendar_today;
              break;
            case 'Custom':
              icon = Icons.date_range;
              break;
            default:
              icon = Icons.calendar_today;
          }
          return ButtonSegment<String>(
            value: period,
            label: Text(period),
            icon: Icon(icon, size: 18),
          );
        }).toList(),
        selected: {_selectedPeriod},
        onSelectionChanged: (selection) {
          setState(() {
            _selectedPeriod = selection.first;
            if (_selectedPeriod != 'Custom') {
              _calculateDatesFromPeriod();
            }
          });
          HapticFeedback.selectionClick();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.purpleStart;
            }
            return Colors.transparent;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return Theme.of(context).colorScheme.onSurface;
          }),
        ),
      ),
    );
  }

  Widget _buildDateRangePicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.purpleStart.withOpacity(0.3),
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
        children: [
          InkWell(
            onTap: () => _selectStartDate(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceColor : AppColors.lightSurfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_outlined, color: AppColors.purpleStart),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date',
                        style: AppTextStyles.bodySmall(context).copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _startDate != null
                            ? DateFormat('dd MMM yyyy').format(_startDate!)
                            : 'Select start date',
                        style: AppTextStyles.bodyMedium(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _selectEndDate(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceColor : AppColors.lightSurfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_outlined, color: AppColors.purpleStart),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'End Date',
                        style: AppTextStyles.bodySmall(context).copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _endDate != null
                            ? DateFormat('dd MMM yyyy').format(_endDate!)
                            : 'Select end date',
                        style: AppTextStyles.bodyMedium(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.purpleStart,
              onPrimary: Colors.white,
              surface: Theme.of(context).cardColor,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
      HapticFeedback.selectionClick();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a start date first'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!.add(const Duration(days: 30)),
      firstDate: _startDate!,
      lastDate: _startDate!.add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.purpleStart,
              onPrimary: Colors.white,
              surface: Theme.of(context).cardColor,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
      HapticFeedback.selectionClick();
    }
  }

  void _calculateDatesFromPeriod() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case 'Weekly':
        _startDate = now;
        _endDate = now.add(const Duration(days: 7));
        break;
      case 'Monthly':
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case 'Yearly':
        _startDate = DateTime(now.year, 1, 1);
        _endDate = DateTime(now.year, 12, 31);
        break;
      default:
        break;
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  Future<void> _updateBudget() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and end dates'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text);

      await _repo.updateBudget(
        widget.budget.id,
        category: _selectedCategory!.name,
        title: _titleController.text.trim(),
        amount: amount,
      );

      if (!mounted) return;
      
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Budget updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating budget: $e'),
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
