import 'package:flutter/material.dart';

class Decorations {
  static Color getDateColor(DateTime date) {
    if (date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
      return Colors.red;
    } else {
      return Colors.indigo;
    }
  }
}
