import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputCommon extends StatelessWidget {
  String? errorText;
  String? labelText;
  String? hintText;
  bool obscureText;
  InputBorder? inputBorder;
  TextEditingController txtController;
  Function(String textChange)? textOnChange;
  InputDecoration? decoration;
   InputCommon(
      {Key? key,
      required this.txtController,
       this.errorText,
       this.textOnChange,
       this.decoration,this.labelText,this.hintText,this.inputBorder,this.obscureText=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: txtController,
      decoration: InputDecoration(
        errorText: errorText,
        labelText: labelText,
        hintText: hintText,
        border: inputBorder,
        isDense: true,
      ),
      obscureText: obscureText,
      onChanged: textOnChange,
    );
  }
}
