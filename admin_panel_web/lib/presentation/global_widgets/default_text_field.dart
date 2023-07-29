import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? label;
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool enabled;
  final int? maxLines;
  final TextInputType keyboardType;
  final String? initialValue;
  final bool disabled;
  const DefaultTextField(
      {super.key,
      this.onChanged,
      this.enabled = true,
      this.disabled = false,
      this.label,
      this.keyboardType = TextInputType.text,
      this.maxLines,
      this.focusNode,
      this.initialValue,
      this.onTap,
      this.width,
      this.obscureText = false,
      this.height,
      this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      readOnly: !enabled,
      enabled: !disabled,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        filled: disabled,
        fillColor: disabled ? Colors.grey[200] : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        labelStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: width ?? 450,
        ),
      ),
      controller: controller,
      obscureText: obscureText,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      inputFormatters: [
        if (keyboardType == TextInputType.number)
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
    );
  }
}
