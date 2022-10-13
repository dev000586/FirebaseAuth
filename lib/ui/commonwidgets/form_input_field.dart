import 'package:flutter/material.dart';

Widget CustomFormInputField({
  Key? key,
  required String label,
  required String hintText,
  void Function(String)? onChanged,
  void Function()? onShowPassword,
  FormFieldValidator<String>? validator,
  TextEditingController? textController,
  isPassword = false,
  showPassword = false
}){
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 2),
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: TextFormField(
      key: key,
      onChanged: onChanged,
      validator: validator,
      controller: textController,
      obscureText: isPassword && !showPassword,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        label: Text(label),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black45),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffix: isPassword ? InkWell(
          onTap: onShowPassword,
            child: Icon(showPassword ? Icons.visibility_off : Icons.visibility, color: Colors.green, size: 18,))
            : const SizedBox(),
      ),
    ),
  );
}