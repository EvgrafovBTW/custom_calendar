import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Decorations {
  static Color getDateColor(BuildContext context, DateTime date) {
    ThemeData theme = Theme.of(context);
    if (date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
      return theme.colorScheme.tertiary;
    } else {
      return theme.colorScheme.onTertiary;
    }
  }

  static List<Color> settingsColors = [
    Colors.teal,
    Colors.greenAccent,
    Colors.green,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.lime,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.blue,
    Colors.cyan,
    Colors.lightBlue,
    Colors.pink,
    Colors.pinkAccent,
    Colors.orange,
    Colors.deepOrange,
    const Color.fromARGB(255, 104, 20, 14),
    Colors.brown,
    const Color(0xffbb86fc),
    const Color(0xff6200ee),
    Colors.grey,
  ];
}

class Utils {
  static String getShortDescription(String description) {
    String desc = description;
    if (description.length > 150) {
      desc = description.substring(0, 150);

      desc = '$desc...';
    }
    return desc;
  }

  static Map<int, String> monthsById = {
    0: 'Январь',
    1: 'Феварль',
    2: 'Март',
    3: 'Апрель',
    4: 'Май',
    5: 'Июнь',
    6: 'Июль',
    7: 'Август',
    8: 'Сентябрь',
    9: 'Октябрь',
    10: 'Ноябрь',
    11: 'Декабрь',
  };

  static String getDateString(DateTime dateTime) {
    String dateString = '';
    dateString = dateTime
        .toIso8601String()
        .substring(0, dateTime.toIso8601String().indexOf('T'));
    List<String> dateContructor = dateString.split('-');
    dateContructor = dateContructor.reversed.toList();
    dateString =
        '${dateContructor.first}.${dateContructor[1]}.${dateContructor.last}';
    return dateString;
  }

  static platformNavigateTo({
    required BuildContext context,
    required Widget screen,
    MaterialPageRouteData? materialPageRouteData,
    CupertinoPageRouteData? cupertinoPageRouteData,
  }) {
    Navigator.push(
      context,
      platformPageRoute(
        material: (context, platform) =>
            materialPageRouteData ?? MaterialPageRouteData(),
        cupertino: (context, platform) =>
            cupertinoPageRouteData ?? CupertinoPageRouteData(),
        context: context,
        builder: (context) => screen,
      ),
    );
  }
}
