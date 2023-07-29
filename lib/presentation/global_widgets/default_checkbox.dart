import 'package:flutter/material.dart';

class DefaultCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  const DefaultCheckbox(
      {super.key, required this.value, this.onChanged, this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: (value) {
            onChanged?.call(value ?? false);
          },
        ),
        if (label != null)
          Text(label!, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
