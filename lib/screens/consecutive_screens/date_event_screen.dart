import 'package:custom_calendar/logic/models/marked_date_model.dart';
import 'package:custom_calendar/utils.dart';
import 'package:flutter/material.dart';

class DateEventScreen extends StatelessWidget {
  const DateEventScreen(this.event, {super.key});
  final MarkedDateEvent event;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: SizedBox.expand(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        Utils.getDateString(event.dateTime),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.015,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                        ),
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  if (event.description != null)
                    Text(
                      event.description!,
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
