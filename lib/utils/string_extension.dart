import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension EmptyPadding on num {
  SizedBox get pw => SizedBox(width: toDouble());
  SizedBox get ph => SizedBox(height: toDouble());
}
