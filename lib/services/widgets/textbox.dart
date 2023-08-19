import 'package:flutter/material.dart';

class MEdit extends StatelessWidget {
  final String hint;
  final Function(String)? onChange;
  final bool autofocus;
  final bool password;
  final bool notempty;
  final bool autoCorrect;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final TextInputType? inputType;
  final bool readOnly;
  final int? maxLines;
  const MEdit({
    required this.hint,
    this.onChange,
    this.notempty = false,
    this.autofocus = false,
    this.password = false,
    this.validate,
    this.autoCorrect = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.controller,
    this.inputType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      maxLines: maxLines,
      autocorrect: autoCorrect,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), gapPadding: 20),
          labelText: hint,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
      obscureText: password,
      controller: controller,
      readOnly: readOnly,
      onChanged: onChange,
      validator: validate,
    );
  }
}
