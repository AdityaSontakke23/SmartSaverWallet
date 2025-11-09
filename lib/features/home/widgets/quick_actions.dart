import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/routes.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: Icons.add,
          label: "Transactions",
          color: Colors.blue,
          onPressed: () {
            Navigator.pushNamed(context, RoutePaths.transactions);
          },
        ),
        const SizedBox(width: 8),
        _ActionButton(
          icon: Icons.account_balance_wallet,
          label: "Add Budget",
          color: Colors.orange,
          onPressed: () {
            Navigator.pushNamed(context, RoutePaths.budget);
          },
        ),
        const SizedBox(width: 8),
        _ActionButton(
          icon: Icons.flag,
          label: "Add Goal",
          color: Colors.green,
          onPressed: () {
            Navigator.pushNamed(context, RoutePaths.goals);
          },
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 22),
        label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          elevation: 2,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
