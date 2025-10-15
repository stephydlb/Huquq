import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/gold_price.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> showGoldPriceNotification(GoldPrice price) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'gold_price_channel',
          'Prix de l\'or',
          channelDescription: 'Notifications pour les prix de l\'or',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      0,
      'Prix de l\'or mis à jour',
      'Prix par kilo: ${price.pricePerKilo.toStringAsFixed(2)} ${price.currency}\n'
          'Prix par mithqal: ${price.pricePerMithqal.toStringAsFixed(2)} ${price.currency}',
      details,
    );
  }

  static Future<void> scheduleDailyNotification() async {
    await _notificationsPlugin.zonedSchedule(
      1,
      'Rappel quotidien',
      'Vérifiez les prix de l\'or actuels',
      _nextInstanceOfNineAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Rappel quotidien',
          channelDescription: 'Rappel quotidien pour les prix de l\'or',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfNineAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      9,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
