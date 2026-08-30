import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/auth_hero_panel.dart';
import '../../../../core/widgets/app_logo.dart';
import '../providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms & Conditions to continue.')),
      );
      return;
    }
    final auth = context.read<AuthProvider>();
    final success = await auth.signUp(
      _emailController.text.trim(),
      _usernameController.text.trim(),
      _passwordController.text,
    );
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isMobile) ...[
              const Center(child: AppLogo(size: 40)),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text('Start Your Adventure', style: AppTextStyles.heading1, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Create an account to save destinations and share your discoveries.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            Align(alignment: Alignment.centerLeft, child: Text('Full Name', style: AppTextStyles.label)),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _usernameController,
              decoration: _fieldDecoration(hint: 'Enter your full name', icon: Icons.person_outline),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            Align(alignment: Alignment.centerLeft, child: Text('Email Address', style: AppTextStyles.label)),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _emailController,
              decoration: _fieldDecoration(hint: 'name@example.com', icon: Icons.mail_outline),
              validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            Align(alignment: Alignment.centerLeft, child: Text('Password', style: AppTextStyles.label)),
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
            const SizedBox(height: AppSpacing.md),

            Align(alignment: Alignment.centerLeft, child: Text('Confirm Password', style: AppTextStyles.label)),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _confirmController,
              obscureText: _obscureConfirm,
              decoration: _fieldDecoration(
                hint: '••••••••',
                icon: Icons.lock_reset_outlined,
                suffix: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppColors.outline,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _agreedToTerms,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 13),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: ' of GhumNepal.'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (auth.status == AuthStatus.error && auth.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(auth.errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
            ],
            const SizedBox(height: AppSpacing.lg),

            ElevatedButton.icon(
              onPressed: auth.status == AuthStatus.loading ? null : _submit,
              icon: auth.status == AuthStatus.loading
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Create Account'),
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

            OutlinedButton.icon(
              onPressed: auth.status == AuthStatus.loading ? null : _submitGoogle,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 48),
                side: const BorderSide(color: AppColors.border),
                foregroundColor: AppColors.textPrimary,
              ),
              icon: const Icon(Icons.g_mobiledata, size: 26, color: AppColors.primary),
              label: const Text('Sign up with Google'),
            ),
            const SizedBox(height: AppSpacing.lg),

            Center(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Log In',
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
                imageUrl: 'https://images.unsplash.com/photo-1551632811-561732d1e306',
                isMobile: true,
                topLeft: _TrekkerBadge(),
                title: 'Join the Community',
                subtitle: 'Discover hidden trails and vibrant culture.',
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
            imageUrl: 'https://images.unsplash.com/photo-1551632811-561732d1e306',
            isMobile: false,
            topLeft: _TrekkerBadge(),
            title: 'Join the Community of Explorers',
            subtitle:
            'Discover the hidden trails, ancient temples, and vibrant cultures of Nepal with a global network of adventure seekers.',
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: _formCard(false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrekkerBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.landscape_outlined, size: 16, color: Colors.white),
          SizedBox(width: 6),
          Text('4.9k+ Active Trekkers', style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}