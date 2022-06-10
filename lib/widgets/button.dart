import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.backgroundColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String buttonText;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundColor)),
        onPressed: onPressed,
        child: Text(
          buttonText,
        ),
      ),
    );
  }
}
