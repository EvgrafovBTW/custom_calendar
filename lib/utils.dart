import 'package:flutter/material.dart';

class Decorations {
  static Color getDateColor(BuildContext context, DateTime date) {
    ThemeData theme = Theme.of(context);
    if (date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
      return theme.colorScheme.tertiary;
    } else {
      return theme.colorScheme.onTertiary;
    }
  }
}
