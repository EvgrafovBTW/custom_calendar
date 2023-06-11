import 'dart:io';

import 'package:flutter/material.dart';

class AppCloseDialog extends StatelessWidget {
  /// Диалог, который отсреливает, если нажать "назад" на главной странице
  const AppCloseDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Dialog(
        child: SizedBox.fromSize(
          size: MediaQuery.of(context).size / 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Expanded(
                flex: 2,
                child: Text(
                  'Выйти из приложения?',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.028,
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: const Text(
                        'Да',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'нет',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
