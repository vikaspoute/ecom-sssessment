import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.autofillHints,
    this.semanticLabel,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.autovalidateMode,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final Iterable<String>? autofillHints;
  final String? semanticLabel;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onFieldSubmitted;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final effectiveMaxLines = obscureText ? 1 : maxLines;
    final accessibleLabel = semanticLabel ?? labelText ?? hintText;

    return Semantics(
      textField: true,
      label: accessibleLabel,
      enabled: enabled,
      obscured: obscureText,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        keyboardType: obscureText
            ? TextInputType.visiblePassword
            : keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        maxLength: maxLength,
        maxLines: effectiveMaxLines,
        minLines: obscureText ? 1 : minLines,
        autofillHints: autofillHints,
        autocorrect: obscureText ? false : autocorrect,
        enableSuggestions: obscureText ? false : enableSuggestions,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefix: prefix,
          prefixIcon: prefixIcon,
          suffix: suffix,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
