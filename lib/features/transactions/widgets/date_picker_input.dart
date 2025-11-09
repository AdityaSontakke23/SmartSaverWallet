import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';

class DatePickerInput extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DatePickerInput({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? ColorScheme.dark(
                    primary: AppColors.tealStart,
                    onPrimary: Colors.white,
                    surface: AppColors.darkCardBackground,
                    onSurface: Colors.white,
                  )
                : ColorScheme.light(
                    primary: const Color(0xFF0099CC),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: const Color(0xFF1A1A1A),
                  ),
            dialogBackgroundColor: isDarkMode
                ? AppColors.darkPrimaryBackground
                : Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // ✅ Theme-aware colors
    final iconColor = isDarkMode
        ? Colors.white.withOpacity(0.7)
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
    
    final textColor = isDarkMode
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;

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
      child: InkWell(
        onTap: () => _selectDate(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: iconColor, // ✅ Fixed: Theme-aware
              ),
              const SizedBox(width: 12),
              Text(
                DateFormat('d MMMM, y').format(selectedDate),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: textColor, // ✅ Fixed: Theme-aware
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
