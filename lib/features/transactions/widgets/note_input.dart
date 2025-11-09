import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';

class NoteInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;

  const NoteInput({
    Key? key,
    required this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // ✅ Theme-aware colors
    final iconColor = isDarkMode
        ? Colors.white.withOpacity(0.7)
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 3,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: AppColors.primaryText(context), // ✅ Already theme-aware
        ),
        decoration: InputDecoration(
          hintText: 'Add a note',
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.primaryText(context).withOpacity(0.5), // ✅ Already theme-aware
          ),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.note_outlined,
            color: iconColor, // ✅ Fixed: Theme-aware
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
