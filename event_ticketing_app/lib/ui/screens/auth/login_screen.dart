import 'package:event_ticket_app/providers/auth_provider.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/widgets/custom_text_button.dart';
import 'package:event_ticket_app/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final colorScheme = context.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.confirmation_number_rounded,
                      size: 56.sp,
                      color: colorScheme.primary,
                    ),
                    verticalSpaceSmall,
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    verticalSpaceTiny,
                    Text(
                      'Sign in to browse events and manage your tickets',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    verticalSpaceMedium,
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    verticalSpaceSmall,
                    CustomTextField(
                      obscureText: true,
                      controller: _passwordController,
                      hintText: 'Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    if (authState.error != null && authState.error!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Text(
                          authState.error!,
                          style: TextStyle(
                            color: colorScheme.error,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    verticalSpaceMedium,
                    CustomTextButton(
                      text: 'Sign in',
                      isPrimary: true,
                      isLoading: authState.isLoading,
                      onPressed: _login,
                    ),
                    verticalSpaceSmall,
                    TextButton(
                      onPressed: () => context.go('/auth/register'),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
    if (success && mounted) context.go('/home');
  }
}
