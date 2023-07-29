import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';

final class DefaultCardDropdown extends Equatable {
  final Iterable<DefaultMenuItem> items;
  final ValueChanged<DefaultMenuItem>? onChanged;
  final int? valueId;
  final String? additionalValueId;
  final String? label;

  const DefaultCardDropdown({
    required this.items,
    this.onChanged,
    this.valueId,
    this.additionalValueId,
    this.label,
  });

  @override
  List<Object?> get props =>
      [items, onChanged, valueId, label, additionalValueId];
}

final class DefaultCardItem extends Equatable {
  final String? title;
  final String? simpleText;
  final VoidCallback? onSimpleTextTapped;
  final ValueChanged<bool>? onChecked;
  final bool? checked;
  final String? checkedLabel;
  final Widget? customWidget;
  final int? maxLines;
  final TextEditingController? controller;
  final DefaultCardDropdown? dropdown;
  final bool isObscured;
  final bool isRequired;
  final bool disabled;

  const DefaultCardItem({
    this.title,
    this.controller,
    this.checkedLabel,
    this.isRequired = false,
    this.disabled = false,
    this.maxLines,
    this.isObscured = false,
    this.onSimpleTextTapped,
    this.onChecked,
    this.checked,
    this.simpleText,
    this.customWidget,
    this.dropdown,
  });

  @override
  List<Object?> get props => [
        title,
        simpleText,
        checked,
        customWidget,
        maxLines,
        controller,
        dropdown,
        isObscured,
        checkedLabel,
        onChecked,
        onSimpleTextTapped,
        isRequired,
      ];
}

class DefaultCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final List<DefaultCardItem> items;
  final bool isExpanded;
  const DefaultCard({
    Key? key,
    required this.title,
    required this.items,
    this.isExpanded = false,
    this.trailing,
    this.width = 650,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return titleWithDivider(
      title,
      Container(
          width: isExpanded ? double.infinity : width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            dividerColor: Theme.of(context).dividerColor.withOpacity(.5),
            mergeDividerWithSpace: true,
            verticalSpace: 8,
            children: [
              for (var item in items)
                if (item.customWidget != null)
                  item.customWidget!
                else
                  labelWithField(
                    context,
                    item,
                    labelWidth: width / 3,
                  ),
            ],
          )),
      context,
    );
  }

  Widget titleWithDivider(String? title, Widget? child, BuildContext context) {
    return SpacedColumn(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title.isNotEmpty)
            SpacedRow(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              horizontalSpace: 6,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          if (title != null && title.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: isExpanded ? double.infinity : width,
              height: 1,
              color: Colors.grey,
            ),
          if (child != null) child,
        ]);
  }

  Widget labelWithField(BuildContext context, DefaultCardItem item,
      {double? labelWidth}) {
    return SpacedRow(
      horizontalSpace: 12,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: labelWidth!,
          child: item.isRequired
              ? SpacedRow(
                  horizontalSpace: 2,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "*",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.red),
                    ),
                    SizedBox(
                      width: labelWidth - 12,
                      child: Text(
                        "${item.title}:",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                )
              : Text(
                  "${item.title}:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
        ),
        _textField(
          context,
          item,
        ),
      ],
    );
  }

  Widget _textField(
    BuildContext context,
    DefaultCardItem item,
  ) {
    if (item.controller != null) {
      return DefaultTextField(
        width: width / 1.8,
        validator: (value) {
          if (item.isRequired && value!.isEmpty) {
            return "This field is required";
          }
          return null;
        },
        disabled: item.disabled,
        height: (item.maxLines ?? 1) * 40,
        label: item.title,
        controller: item.controller,
        maxLines: item.maxLines,
        obscureText: item.isObscured,
      );
    }
    if (item.onChecked != null && item.checked != null) {
      return DefaultSwitch(
        value: item.checked!,
        label: item.checkedLabel,
        isLabelFirst: false,
        onChanged: item.onChecked!,
        activeIcon: Icons.check,
        inactiveIcon: Icons.close,
      );
    }
    if (item.dropdown != null) {
      return DefaultDropdown(
        hasSearchBox: true,
        width: width / 1.8,
        label: "Select ${item.title ?? ""}",
        items: item.dropdown!.items.toList(),
        onChanged: item.dropdown?.onChanged,
        valueId: item.dropdown!.valueId,
        valueAdditionalId: item.dropdown!.additionalValueId,
      );
    }
    return SizedBox(
      width: width / 1.8,
      child: InkWell(
        onTap: item.onSimpleTextTapped,
        child: Text(
          item.simpleText == null
              ? "-"
              : (item.simpleText!.isEmpty ? "-" : item.simpleText!),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                decoration: item.onSimpleTextTapped != null
                    ? TextDecoration.underline
                    : null,
                decorationColor: Theme.of(context).primaryColor,
                decorationThickness: 2,
                color: item.onSimpleTextTapped != null
                    ? Theme.of(context).primaryColor
                    : null,
              ),
        ),
      ),
    );
  }
}
