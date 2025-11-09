import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/validators.dart';
import '../services/auth_repository.dart';
import 'signup_screen.dart';
import '../../home/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final void Function(ThemeMode)? onThemeChange;
  const LoginScreen({Key? key, this.onThemeChange}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final user = await AuthRepository().login(
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
            style: AppTypography.caption(context).copyWith(color: Colors.white),
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

  // ✅ Forgot Password Function
  Future<void> _forgotPassword() async {
    final emailController = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your email address and we\'ll send you a password reset link.',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(FontAwesomeIcons.envelope, size: 20),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter your email address'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }

              try {
                await AuthRepository().resetPassword(
                  email: emailController.text.trim(),
                );
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset email sent! Check your inbox.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  // ✅ Updated Logo with app_logo.png
 Widget _buildLogo() {
  return Container(
    width: 120, // Reduced from 140
    height: 120, // Reduced from 140
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
    padding: const EdgeInsets.all(18), // Reduced from 20
    child: ClipOval(
      child: Image.asset(
        'assets/images/logo/app_logo.png',
        fit: BoxFit.cover,
      ),
    ),
  );
}


  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Welcome Back',
            style: AppTypography.sectionHeader(context),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to continue managing your finances',
            style: AppTypography.caption(context),
          ),
          const SizedBox(height: 32),
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _forgotPassword, // ✅ Implemented
              child: Text(
                'Forgot Password?',
                style: AppTypography.caption(context).copyWith(
                  color: AppColors.accentText(context),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
  onPressed: _loading ? null : _login,
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
          width: 220, // ✅ Same size as CircularProgressIndicator was
          height: 60,
          child: Lottie.asset(
            'assets/animations/loading.json',
            fit: BoxFit.fill,
          ),
        )
      : Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: AppTypography.caption(context).copyWith(
                  color: AppColors.accentText(context),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignUpScreen(
                        onThemeChange: widget.onThemeChange ?? (_) {},
                      ),
                    ),
                  );
                },
                child: Text(
                  'Sign Up',
                  style: AppTypography.caption(context).copyWith(
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
  final size = MediaQuery.of(context).size;
  final padding = MediaQuery.of(context).padding;
  
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 113, 135, 231), // Your chosen blue
            Color.fromARGB(255, 139, 104, 175), // Your chosen purple
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ✅ Logo Section - Constrained height
            Expanded(
              flex: 2, // Reduced from 3 to 2
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 12), // Reduced from 16
                    Text(
                      'SmartSaver',
                      style: AppTypography.largeTitle(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32, // Reduced from 36
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6), // Reduced from 8
                    Text(
                      'Manage Money, Build Wealth',
                      style: AppTypography.caption(context).copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13, // Reduced from 14
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Login Form Section - Takes more space
            Expanded(
              flex: 3, // Increased from 5 to 3 (relative to new flex:2 above)
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
                  child: _buildLoginForm(),
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
