import 'package:flutter/material.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final bool isVisible;

  const BalanceCard({
    Key? key,
    required this.balance,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = balance >= 0
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Balance', style: AppTextStyles.bodyMedium(context)),
            const SizedBox(height: 12),
            Text(
              isVisible
                  ? '\₹${balance.toStringAsFixed(2)}'
                  : '₹••••••',
              style: AppTextStyles.h1(context).copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
