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