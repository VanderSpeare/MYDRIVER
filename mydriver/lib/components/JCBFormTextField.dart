import 'package:flutter/material.dart';
import 'package:mydriver/extensions/Color.dart';
import 'package:mydriver/extensions/Colors.dart';
import '/utils/Constants.dart';

// ignore: must_be_immutable
class JCBFormTextField extends StatefulWidget {
  String label;
  double? width;
  TextFieldType textFieldType;
  TextInputAction? textInputAction;
  TextEditingController? controller;
  FocusNode? focus;
  FocusNode? nextFocus;
  bool? autoFocus;
  TextInputType? keyboardType;
  bool? labelSpace;
  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;

  JCBFormTextField({
    this.controller,
    this.width,
    this.autoFocus,
    this.focus,
    required this.label,
    this.nextFocus,
    required this.textFieldType,
    this.textInputAction,
    this.keyboardType,
    this.labelSpace,
    this.validator,
    this.onChanged,
  });

  @override
  State<JCBFormTextField> createState() => _JCBFormTextFieldState();
}

class _JCBFormTextFieldState extends State<JCBFormTextField> {
  String checkText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (checkText.isNotEmpty)
          Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: jcbGreyColor,
              fontSize: 14,
            ),
          )
        else if (widget.labelSpace == true)
          const Text(
            '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          )
        else
          const SizedBox.shrink(),
        if (widget.labelSpace == true) const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: jcbSecBorderColor),
            borderRadius: BorderRadius.circular(jcbButtonRadius),
          ),
          width: widget.width ?? MediaQuery.of(context).size.width - 32,
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focus,
            onSubmitted: (value) {
              if (widget.nextFocus != null) {
                FocusScope.of(context).requestFocus(widget.nextFocus);
              }
            },
            autofocus: widget.autoFocus ?? false,
            keyboardType: widget.keyboardType ?? TextInputType.name,
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            style: const TextStyle(fontWeight: FontWeight.bold),
            onChanged: (val) {
              setState(() {
                checkText = val;
              });
              widget.onChanged?.call(val);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.label,
              hintStyle: const TextStyle(
                color: jcbGreyColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Enum to mimic nb_utils TextFieldType (used for consistency)
enum TextFieldType {
  NAME,
  EMAIL,
  PASSWORD,
  PHONE,
  ADDRESS,
  MULTILINE,
  NUMBER,
  URL,
  OTHER,
}