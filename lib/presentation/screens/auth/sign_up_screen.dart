import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_top_nav.dart';

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

  Widget _formCard() {
    final auth = context.watch<AuthProvider>();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sign Up', style: AppTextStyles.heading1),
            const SizedBox(height: AppSpacing.lg),
            _label('Email'),
            TextFormField(
              controller: _emailController,
              validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _label('Username'),
            TextFormField(
              controller: _usernameController,
              validator: (v) => (v == null || v.isEmpty) ? 'Enter a username' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _label('Password'),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _label('Confirm Password'),
            TextFormField(
              controller: _confirmController,
              obscureText: true,
              validator: (v) =>
              v != _passwordController.text ? 'Passwords do not match' : null,
            ),
            if (auth.status == AuthStatus.error && auth.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(auth.errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
            ],
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: auth.status == AuthStatus.loading ? null : _submit,
                child: auth.status == AuthStatus.loading
                    ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Align(
    alignment: Alignment.centerLeft,
    heightFactor: 1.0,
    child: Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(text, style: AppTextStyles.label),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Scaffold(
      appBar: const AppTopNav(),
      body: isMobile
          ? SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: _formCard(),
      )
          : Row(
        children: [
          Expanded(
            child: Image.network(
              'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
              fit: BoxFit.cover,
              height: double.infinity,
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _formCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}