import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_item.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryBackground
          : AppColors.lightPrimaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.blueStart, AppColors.blueEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'SmartSaver',
                        style: AppTextStyles.h2(context).copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Version 1.0.0',
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  SettingsCard(
                    children: [
                      SettingsItem(
                        title: 'Contact Support',
                        subtitle: 'adison23.official@gmail.com',
                        leadingIcon: Icons.email_outlined,
                        iconColor: AppColors.greenStart,
                        trailing: const Icon(Icons.copy),
                        onTap: () {
                          Clipboard.setData(
                            const ClipboardData(text: 'adison23.official@gmail.com'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email copied to clipboard'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCardBackground
                          : AppColors.lightCardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About SmartSaver',
                          style: AppTextStyles.h4(context),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'SmartSaver is your personal finance companion, helping you track expenses, set budgets, and achieve your savings goals.',
                          style: AppTextStyles.bodyMedium(context),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(context, 'Version', '1.0.0'),
                        _buildInfoRow(context, 'Build', '10'),
                        _buildInfoRow(context, 'Developer', 'Aditya Sontakke'),
                        _buildInfoRow(context, 'Platform', 'Flutter'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SettingsCard(
                    children: [
                      SettingsItem(
                        title: 'Privacy Policy',
                        leadingIcon: Icons.privacy_tip_outlined,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showPrivacyPolicy(context),
                      ),
                      SettingsItem(
                        title: 'Terms of Service',
                        leadingIcon: Icons.description_outlined,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showTermsOfService(context),
                      ),
                      SettingsItem(
                        title: 'Licenses',
                        leadingIcon: Icons.article_outlined,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => showLicensePage(context: context),
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          '© 2025 SmartSaver',
                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Made in India',
                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            'Privacy Policy\n\n'
            'SmartSaver respects your privacy and is committed to protecting your personal data.\n\n'
            'Data Collection:\n'
            '- We collect transaction data, budget information, and savings goals\n'
            '- All data is stored securely in Firebase\n\n'
            'Data Usage:\n'
            '- Your data is used solely for app functionality\n'
            '- We do not share your data with third parties\n\n'
            'Data Security:\n'
            '- All data is encrypted and secured\n'
            '- You can delete your account and data at any time',
            style: AppTextStyles.bodyMedium(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Text(
            'Terms of Service\n\n'
            '1. Acceptance of Terms\n'
            'By using SmartSaver, you agree to these terms.\n\n'
            '2. Use of Service\n'
            'SmartSaver is provided for personal financial management.\n\n'
            '3. User Responsibilities\n'
            '- Maintain account security\n'
            '- Provide accurate information\n'
            '- Use the app legally\n\n'
            '4. Disclaimer\n'
            'SmartSaver is provided "as is" without warranties.\n\n'
            '5. Changes to Terms\n'
            'We may update these terms at any time.',
            style: AppTextStyles.bodyMedium(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
