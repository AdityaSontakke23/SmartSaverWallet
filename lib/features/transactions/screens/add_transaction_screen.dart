import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/models/category.dart';
import '../models/transaction_model.dart';
import '../services/transactions_repository.dart';
import '../widgets/amount_input.dart';
import '../widgets/category_picker.dart';
import '../widgets/date_picker_input.dart';
import '../widgets/note_input.dart';
import '../widgets/transaction_form_button.dart';
import '../widgets/transaction_type_selector.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddTransactionScreen({
    Key? key,
    this.transaction,
  }) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  late String _selectedType;
  Category? _selectedCategory;
  late DateTime _selectedDate;
  bool _isLoading = false;


  bool get _isEditMode => widget.transaction != null;

  final List<Category> _expenseCategories = [
    Category(id: '1', name: 'Food', icon: Icons.restaurant, type: 'expense'),
    Category(id: '2', name: 'Shopping', icon: Icons.shopping_bag, type: 'expense'),
    Category(id: '3', name: 'Transport', icon: Icons.directions_car, type: 'expense'),
    Category(id: '4', name: 'Bills', icon: Icons.receipt_long, type: 'expense'),
    Category(id: '5', name: 'Entertainment', icon: Icons.movie, type: 'expense'),
  ];

  final List<Category> _incomeCategories = [
    Category(id: '6', name: 'Salary', icon: Icons.work, type: 'income'),
    Category(id: '7', name: 'Freelance', icon: Icons.computer, type: 'income'),
    Category(id: '8', name: 'Investment', icon: Icons.trending_up, type: 'income'),
    Category(id: '9', name: 'Gift', icon: Icons.card_giftcard, type: 'income'),
  ];

  List<Category> get _categories =>
      _selectedType == 'expense' ? _expenseCategories : _incomeCategories;

  @override
  void initState() {
    super.initState();
    

    if (_isEditMode) {
      final tx = widget.transaction!;
      _amountController.text = tx.amount.toStringAsFixed(0);
      _noteController.text = tx.description ?? '';
      _selectedType = tx.type;
      _selectedDate = tx.date;
      

      final allCategories = [..._expenseCategories, ..._incomeCategories];
      _selectedCategory = allCategories.firstWhere(
        (cat) => cat.name.toLowerCase() == tx.category.toLowerCase(),
        orElse: () => allCategories.first,
      );
    } else {
      _selectedType = 'expense';
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.tryParse(_amountController.text) ?? 0;
      if (amount <= 0) {
        throw 'Please enter a valid amount';
      }

      final repo = TransactionsRepository();


      if (_isEditMode) {
        await repo.updateTransaction(
          widget.transaction!.id,
          amount: amount,
          type: _selectedType,
          category: _selectedCategory!.name,
          description: _noteController.text.trim(),
          date: _selectedDate,
        );
      } else {
        await repo.addTransaction(
          amount: amount,
          type: _selectedType,
          category: _selectedCategory!.name,
          description: _noteController.text.trim(),
          date: _selectedDate,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Transaction updated successfully!'
                  : 'Transaction added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _isEditMode ? 'Edit Transaction' : 'Add Transaction',
          style: TextStyle(
            color: AppColors.primaryText(context),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryText(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              
              Opacity(
                opacity: _isEditMode ? 0.5 : 1.0,
                child: IgnorePointer(
                  ignoring: _isEditMode,
                  child: TransactionTypeSelector(
                    selectedType: _selectedType,
                    onTypeSelected: (type) {
                      setState(() {
                        _selectedType = type;
                        _selectedCategory = null;
                      });
                    },
                  ),
                ),
              ),
              AmountInput(
                controller: _amountController,
                type: _selectedType,
                onChanged: (_) => setState(() {}),
              ),
              CategoryPicker(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                type: _selectedType,
              ),
              DatePickerInput(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              NoteInput(
                controller: _noteController,
              ),
              TransactionFormButton(
                text: _isEditMode
                    ? 'Update ${_selectedType.toUpperCase()}'
                    : 'Add ${_selectedType.toUpperCase()}',
                onPressed: _submitForm,
                isLoading: _isLoading,
                type: _selectedType,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
