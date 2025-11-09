import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_item.dart';
import 'add_transaction_screen.dart';
import '../services/transactions_repository.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  Stream<List<TransactionModel>> _transactionsStream() {
    final repo = TransactionsRepository();
    return repo
        .streamUserTransactions(limit: AppConstants.maxTransactionHistory)
        .map((snap) => snap.docs
            .map((doc) => TransactionModel.fromDocument(doc))
            .toList());
  }

  Future<void> _deleteTx(BuildContext context, String id) async {
    final repo = TransactionsRepository();
    await repo.deleteTransaction(id);
  }

  
  void _showQuickActions(BuildContext context, TransactionModel tx) {
    HapticFeedback.mediumImpact();
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.blueStart.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.edit, color: AppColors.blueStart),
              ),
              title: const Text('Edit Transaction'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddTransactionScreen(transaction: tx),
                  ),
                );
              },
            ),
            
            
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.greenStart.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.copy, color: AppColors.greenStart),
              ),
              title: const Text('Duplicate'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final repo = TransactionsRepository();
                  await repo.addTransaction(
                    amount: tx.amount,
                    type: tx.type,
                    category: tx.category,
                    description: '${tx.description} (Copy)',
                    date: DateTime.now(),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transaction duplicated!'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
            ),
            
            
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.delete, color: AppColors.error),
              ),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteTx(context, tx.id);
              },
            ),
          ],
        ),
      ),
    );
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
        title: const Text('Transactions'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: _transactionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button below to add your first transaction',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddTransactionScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Add Transaction'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                  ).wrapWithGradient(context),
                ),
              ),
              
              
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final tx = items[index];
                    
                    return GestureDetector(
                      onLongPress: () => _showQuickActions(context, tx),
                      child: TransactionItem(
                        transaction: tx,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddTransactionScreen(
                                transaction: tx,
                              ),
                            ),
                          );
                        },
                        onDelete: () => _deleteTx(context, tx.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


extension GradientButton on Widget {
  Widget wrapWithGradient(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.blueStart, AppColors.blueEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: this,
    );
  }
}
