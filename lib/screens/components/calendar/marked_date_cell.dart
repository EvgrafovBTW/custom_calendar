import 'package:flutter/material.dart';

class DateCell extends StatelessWidget {
  const DateCell({
    super.key,
    required this.day,
    this.isMarked = false,
  });
  final DateTime day;
  final bool isMarked;

  @override
  Widget build(BuildContext context) {
    if (isMarked) {
      return MarkedDateCell(day);
    }
    return Column(
      children: [
        Text(
          day.day.toString(),
        ),
      ],
    );
  }
}

class MarkedDateCell extends StatelessWidget {
  const MarkedDateCell(
    this.day, {
    super.key,
  });
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    Color getDateColor(DateTime date) {
      if (date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
        return Colors.red;
      } else {
        return Colors.indigo;
      }
    }

    return Column(
      children: [
        Text(
          day.day.toString(),
        ),
        Icon(
          Icons.star,
          color: getDateColor(day),
          // size: MediaQuery.of(context).size.height * 0.05,
        ),
      ],
    );
  }
}
