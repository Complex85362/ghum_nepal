import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/auth_hero_panel.dart';
import '../../../../core/widgets/app_logo.dart';
import '../providers/auth_provider.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success =
    await auth.logIn(_emailController.text.trim(), _passwordController.text);
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _submitGoogle() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithGoogle();
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  InputDecoration _fieldDecoration({required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.outline, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
    );
  }

  Widget _formCard(bool isMobile) {
    final auth = context.watch<AuthProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? AppSpacing.lg : AppSpacing.xl,
        vertical: AppSpacing.xl,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back, Explorer!', style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Log in to continue your journey.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),

            Text('Email Address', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _emailController,
              decoration: _fieldDecoration(hint: 'name@example.com', icon: Icons.mail_outline),
              validator: (v) =>
              (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Password', style: AppTextStyles.label),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset isn\'t available yet.')),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: _fieldDecoration(
                hint: '••••••••',
                icon: Icons.lock_outline,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppColors.outline,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
            ),
            if (auth.status == AuthStatus.error && auth.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(auth.errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
            ],
            const SizedBox(height: AppSpacing.lg),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: auth.status == AuthStatus.loading ? null : _submit,
                icon: auth.status == AuthStatus.loading
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Icon(Icons.arrow_forward, size: 18),
                label: const Text('Log In'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Row(
              children: [
                Expanded(child: Divider(color: AppColors.divider)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Text('OR', style: AppTextStyles.caption),
                ),
                Expanded(child: Divider(color: AppColors.divider)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: auth.status == AuthStatus.loading ? null : _submitGoogle,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  side: const BorderSide(color: AppColors.border),
                  foregroundColor: AppColors.textPrimary,
                ),
                icon: const Icon(Icons.g_mobiledata, size: 26, color: AppColors.primary),
                label: const Text('Continue with Google'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Center(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  children: [
                    const TextSpan(text: "Don't have an account? "),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpScreen()),
                        ),
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.label.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    if (isMobile) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeroPanel(
                imageUrl: 'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
                isMobile: true,
                topLeft: const AppLogo(size: 32, textColor: Colors.white),
                title: 'Discover Your Own Country',
                subtitle: 'Your next Nepali adventure starts here.',
              ),
              _formCard(true),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          AuthHeroPanel(
            imageUrl: 'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
            isMobile: false,
            topLeft: const AppLogo(size: 32, textColor: Colors.white),
            title: 'Discover Your Own Country',
            subtitle:
            'Revisit the magic of the peaks and the whispers of the valleys. Your next Nepali adventure starts here.',
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: _formCard(false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}