import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final String type;
  final ValueChanged<String> onChanged;

  const AmountInput({
    Key? key,
    required this.controller,
    required this.type,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpense = type == 'expense';
    final gradientColors = isExpense
        ? [AppColors.orangeStart, AppColors.orangeEnd]
        : [AppColors.greenStart, AppColors.greenEnd];

    
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradientColors[0].withOpacity(0.2),
            gradientColors[1].withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.transparent
              : gradientColors[0].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            '₹',
            style: AppTextStyles.h1(context).copyWith(
              color: textColor,
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: AppTextStyles.amountLarge(context).copyWith(
              color: textColor,
              fontSize: 48,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '0.00',
              hintStyle: AppTextStyles.amountLarge(context).copyWith(
                color: textColor.withOpacity(0.5),
                fontSize: 48,
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
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
            onChanged: onChanged,
          ),
          Text(
            'Tap to enter amount',
            style: AppTextStyles.bodySmall(context).copyWith(
              color: textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
