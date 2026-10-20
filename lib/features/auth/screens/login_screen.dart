import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/core/utils/validators.dart';
import 'package:ecom/features/auth/cubit/auth_cubit.dart';
import 'package:ecom/features/auth/cubit/auth_state.dart';
import 'package:ecom/features/auth/widgets/login_demo_footer.dart';
import 'package:ecom/features/auth/widgets/login_header.dart';
import 'package:ecom/features/auth/widgets/password_field.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:ecom/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Authentication screen supporting decoupled per-field validation and mock demo sign-in.
class LoginScreen extends StatefulWidget {
  /// Creates a [LoginScreen].
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _emailValid = false;
  bool _passwordValid = false;

  bool get _isFormValid => _emailValid && _passwordValid;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    final isValid = Validators.email(value) == null;
    if (isValid != _emailValid) {
      setState(() => _emailValid = isValid);
    }
  }

  void _onPasswordChanged(String value) {
    final isValid = Validators.password(value) == null;
    if (isValid != _passwordValid) {
      setState(() => _passwordValid = isValid);
    }
  }

  void _submit() {
    final cubit = context.read<AuthCubit>();
    if (cubit.state is AuthLoading) {
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();
    cubit.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.products);
        }
      },
      builder: (context, state) {
        final colorScheme = context.colorScheme;
        final isLoading = state is AuthLoading;
        final failureMessage = state is AuthFailure ? state.message : null;

        return Scaffold(
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.maxContentWidth,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: AutofillGroup(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const LoginHeader(),
                          AppSpacing.sectionGap.verticalGap,
                          AppTextField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            labelText: 'Email',
                            hintText: 'you@example.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            enabled: !isLoading,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: Validators.email,
                            onChanged: _onEmailChanged,
                            onFieldSubmitted: (_) {
                              _passwordFocus.requestFocus();
                            },
                          ),
                          AppSpacing.formFieldGap.verticalGap,
                          PasswordField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            enabled: !isLoading,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: _onPasswordChanged,
                            onFieldSubmitted: (_) {
                              if (_isFormValid) {
                                _submit();
                              }
                            },
                          ),
                          if (failureMessage != null) ...[
                            AppSpacing.lg.verticalGap,
                            Semantics(
                              liveRegion: true,
                              child: Text(
                                failureMessage,
                                style: AppTypography.bodySmall.copyWith(
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                          AppSpacing.sectionGap.verticalGap,
                          AppButton(
                            label: 'Log in',
                            expand: true,
                            size: AppButtonSize.large,
                            isLoading: isLoading,
                            onPressed: _isFormValid && !isLoading
                                ? _submit
                                : null,
                          ),
                          const LoginDemoFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
