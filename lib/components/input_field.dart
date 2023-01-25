import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController textValueController;
  // final String? valueKey;
  final valueKey;
  final String label;
  final Function? onValidate;
  final Function? onEditComplete;
  final String hint;
  final int? maxLine;
  final FocusNode node;
  final TextInputType? textInputType;
  final String? initialValue;
  final Widget? suffixIcon;
  final Function? onSuffixTap;
  final bool? enabled;

  InputField(
      {required this.textValueController,
      this.maxLine,
      this.textInputType,
      this.onSuffixTap,
      this.initialValue,
      this.suffixIcon,
      this.onEditComplete,
      this.onValidate,
      this.valueKey,
      this.enabled,
      required this.hint,
      required this.label,
      required this.node});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            '$label',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        TextFormField(
          enabled: enabled,
          style: TextStyle(
              fontSize: 12,
              color: enabled == null
                  ? Colors.black
                  : enabled!
                      ? Colors.black
                      : Colors.blueGrey),
          maxLines: maxLine,
          readOnly: onSuffixTap == null ? false : true,
          controller: textValueController,
          initialValue: initialValue,
          cursorColor: Colors.green,
          focusNode: node,
          key: valueKey,
          validator: onValidate as String? Function(String?)?,
          textInputAction: TextInputAction.next,
          onEditingComplete: onEditComplete as void Function()?,
          keyboardType: textInputType,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              // filled: true,
              suffixIcon: InkWell(
                onTap: onSuffixTap as void Function()?,
                child: suffixIcon!,
              ),
              hintText: hint),
        ),
      ],
    );
  }
}
