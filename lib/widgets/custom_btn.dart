import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget btnLarge(
    String text, Color bgColor, Color textColor, VoidCallback onPress) {
  return SizedBox(
    height: 40,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        // Action à effectuer lors de l'appui sur le bouton
        onPress();
      },
      style: ElevatedButton.styleFrom(
        // padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: bgColor, // Couleur rouge comme sur l'image
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          // fontSize: 16,
        ),
      ),
    ),
  );
}
