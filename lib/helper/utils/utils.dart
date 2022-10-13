import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Color color){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: color,
          ),
          child: Text(
            message,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
            ),
          )),
        padding: EdgeInsets.zero,
        duration: const Duration(milliseconds: 1300),
      ));
}