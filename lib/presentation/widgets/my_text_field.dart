import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
 const MyTextField({super.key,required this.text, required this.contentPadding, required this.isHidden, required this.validator, required this.controller});
 final double contentPadding;
 final String text;
 final bool isHidden;
 final FormFieldValidator<String> validator;
 final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isHidden,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: text,
          contentPadding: EdgeInsets.symmetric(
            vertical: contentPadding,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orange)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue, width: 2)
          ),
          
        ),
      ),
    );
  }
}
