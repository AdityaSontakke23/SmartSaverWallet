import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/services/storage_service.dart';
import '../services/auth_repository.dart';
import 'login_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../../core/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  final void Function(ThemeMode)? onThemeChange;
  const SignUpScreen({Key? key, this.onThemeChange}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final user = await AuthRepository().signUp(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      await StorageService().setUserId(user.uid);
      await StorageService().setLoggedIn(true);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(onThemeChange: widget.onThemeChange),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            e.toString(),
            style: AppTextStyles.bodyMedium(context).copyWith(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Widget _buildLogo() {
  return Container(
    width: 80, // ✅ Reduced from 100
    height: 80, // ✅ Reduced from 100
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(0.15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 30,
          spreadRadius: 5,
        ),
      ],
    ),
    padding: const EdgeInsets.all(12), // ✅ Reduced from 15
    child: ClipOval(
      child: Image.asset(
        'assets/images/logo/app_logo.png',
        fit: BoxFit.cover,
      ),
    ),
  );
}

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create Account',
            style: AppTextStyles.sectionHeader(context),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign up to start managing your finances',
            style: AppTextStyles.caption(context),
          ),
          const SizedBox(height: 24),
          
          // Name Field
          TextFormField(
            controller: _nameCtrl,
            validator: Validators.name,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(
                FontAwesomeIcons.user,
                size: 20,
                color: AppColors.tealStart,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Email Field
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            decoration: InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(
                FontAwesomeIcons.envelope,
                size: 20,
                color: AppColors.tealStart,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Password Field
          TextFormField(
            controller: _passCtrl,
            obscureText: true,
            validator: Validators.password,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(
                FontAwesomeIcons.lock,
                size: 20,
                color: AppColors.tealStart,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Confirm Password Field
          TextFormField(
            controller: _confirmCtrl,
            obscureText: true,
            validator: (v) => Validators.confirmPassword(v, _passCtrl.text),
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: Icon(
                FontAwesomeIcons.lock,
                size: 20,
                color: AppColors.tealStart,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Sign Up Button
          ElevatedButton(
            onPressed: _loading ? null : _signUp,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.tealStart,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _loading
                ? SizedBox(
                    width: 220, // ✅ Your requested size
                    height: 60,
                    child: Lottie.asset(
                      'assets/animations/loading.json',
                      fit: BoxFit.fill, // ✅ Your requested fit
                    ),
                  )
                : Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          
          // Already have account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.accentText(context),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(
                        onThemeChange: widget.onThemeChange ?? (_) {},
                      ),
                    ),
                  );
                },
                child: Text(
                  'Login',
                  style: AppTextStyles.caption(context).copyWith(
                    color: AppColors.tealStart,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 113, 135, 231), // Your gradient
              Color.fromARGB(255, 139, 104, 175),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Logo Section
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 12),
                      Text(
                        'SmartSaver',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sign Up Form Section
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground(context),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildSignUpForm(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
