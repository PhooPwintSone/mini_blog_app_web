import 'package:flutter/material.dart';

class AuthTextfield extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  const AuthTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
  });

  @override
  State<AuthTextfield> createState() => _AuthTextfieldState();
}

class _AuthTextfieldState extends State<AuthTextfield> {
  //local state to track visibility
  late bool isObscure;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isObscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.isObscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(isObscure ? Icons.lock_outline : Icons.lock_open),
              )
            : null,
      ),
      obscureText: isObscure,
      obscuringCharacter: "*",

      validator: (value) {
        if (value!.isEmpty) {
          return " ${widget.hintText} is missing !";
        }

        return null;
      },
    );
  }
}
