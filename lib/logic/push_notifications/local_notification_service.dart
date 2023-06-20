import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

int id = 0;

class LocalNotificationService {
  late FlutterLocalNotificationsPlugin pushPlugin;

  static final LocalNotificationService instance =
      LocalNotificationService._internal();

  LocalNotificationService._internal();
  factory LocalNotificationService(FlutterLocalNotificationsPlugin pushPlugin) {
    instance.pushPlugin = pushPlugin;
    return instance;
  }

  Future<void> initializeService() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // didReceiveLocalNotificationStream.add(
        //   ReceivedNotification(
        //     id: id,
        //     title: title,
        //     body: body,
        //     payload: payload,
        //   ),
        // );
      },
      notificationCategories: [],
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await pushPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        print(notificationResponse);
        // switch (notificationResponse.notificationResponseType) {
        //   case NotificationResponseType.selectedNotification:
        //     selectNotificationStream.add(notificationResponse.payload);
        //     break;
        //   case NotificationResponseType.selectedNotificationAction:
        //     if (notificationResponse.actionId == navigationActionId) {
        //       selectNotificationStream.add(notificationResponse.payload);
        //     }
        //     break;
        // }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
  }

  Future<void> showNotification({int? gid}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id4',
      'your channel name4',
      channelDescription: 'your channel description2',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: false,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await pushPlugin.show(
      gid ?? id++,
      'plain title${gid ?? id}',
      'plain body${gid ?? id}',
      notificationDetails,
      payload: 'item ${gid ?? id}',
    );
  }

  Future<void> queueNotification({
    int? gid,
    required tz.TZDateTime showTime,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'queue',
      'your s name4',
      channelDescription: 'your channel description2',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: false,
      usesChronometer: true,
      chronometerCountDown: true,
      when: showTime.microsecondsSinceEpoch,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await pushPlugin.zonedSchedule(
      gid ?? id++,
      'plain title${gid ?? id}',
      'plain body${gid ?? id}',
      showTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'item ${gid ?? id}',
    );
  }
}
