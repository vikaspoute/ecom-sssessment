import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/utils/validators.dart';
import 'package:ecom/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

/// Reusable password input field featuring visibility toggle and validation.
class PasswordField extends StatefulWidget {
  /// Creates a [PasswordField].
  const PasswordField({
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
    this.validator = Validators.password,
    this.autovalidateMode,
  });

  /// The text editing controller for the password string.
  final TextEditingController? controller;

  /// Focus node controlling focus state.
  final FocusNode? focusNode;

  /// Callback when password input changes.
  final ValueChanged<String>? onChanged;

  /// Callback when user submits field from software keyboard.
  final ValueChanged<String>? onFieldSubmitted;

  /// Whether the field is enabled for input.
  final bool enabled;

  /// Action key type on soft keyboard.
  final TextInputAction textInputAction;

  /// Validation function for the password value.
  final FormFieldValidator<String>? validator;

  /// Form validation triggering mode.
  final AutovalidateMode? autovalidateMode;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      labelText: 'Password',
      hintText: 'Enter your password',
      obscureText: _obscured,
      enabled: widget.enabled,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      autofillHints: const [AutofillHints.password],
      semanticLabel: 'Password',
      suffixIcon: IconButton(
        key: const ValueKey('password_visibility'),
        tooltip: _obscured ? 'Show password' : 'Hide password',
        onPressed: () => setState(() => _obscured = !_obscured),
        constraints: const BoxConstraints(
          minWidth: AppSizes.minTouchTarget,
          minHeight: AppSizes.minTouchTarget,
        ),
        icon: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: AppSizes.iconMd,
        ),
      ),
    );
  }
}
