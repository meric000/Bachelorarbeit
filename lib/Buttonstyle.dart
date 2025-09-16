import 'package:flutter/material.dart';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.black,
  backgroundColor: Colors.deepPurpleAccent,
  minimumSize: Size(58, 36),
  padding: EdgeInsets.symmetric(horizontal: 8),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

final ButtonStyle strechedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.black,
  backgroundColor: Colors.greenAccent,
  minimumSize: Size(550,60),
  padding: EdgeInsets.symmetric(horizontal: 8),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);


 final ButtonStyle logoutButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.red.shade700,
  foregroundColor: Colors.white,
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  elevation: 4,
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  ),
);