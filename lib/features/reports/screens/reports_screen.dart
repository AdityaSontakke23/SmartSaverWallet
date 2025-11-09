import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/chart_widget.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final reportData = [
      {'category': 'Food', 'amount': 250.0},
      {'category': 'Transport', 'amount': 120.0},
      {'category': 'Bills', 'amount': 300.0},
      {'category': 'Entertainment', 'amount': 90.0},
      {'category': 'Shopping', 'amount': 180.0},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text('Spending by Category',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: ChartWidget(data: reportData),
            ),
          ],
        ),
      ),
    );
  }
}
