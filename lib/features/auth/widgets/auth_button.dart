import 'package:flutter/material.dart';
import '../../../core/theme/text_styles.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;

  const AuthButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: onPressed,
            child: Text(label, style: AppTextStyles.button(context)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          );
  }
}
