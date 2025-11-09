import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';

class TransactionFormButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final String type;

  const TransactionFormButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpense = type == 'expense';
    final gradientColors = isExpense
        ? [AppColors.orangeStart, AppColors.orangeEnd]
        : [AppColors.greenStart, AppColors.greenEnd];

    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    text,
                    style: AppTextStyles.button(context).copyWith(
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
