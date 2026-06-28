import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  /// Initialize Awesome Notifications
  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'attendance_channel',
          channelName: 'StuHub Notifications',
          channelDescription: 'Daily reminders for StuHub',
          importance: NotificationImportance.High,
          defaultColor: const Color(0xFF4CAF50),
          ledColor: Colors.white,
          playSound: true,
          enableVibration: true,
          channelShowBadge: true,
        ),
      ],
      debug: true,
    );

    bool allowed =
        await AwesomeNotifications().isNotificationAllowed();

    if (!allowed) {
      allowed = await AwesomeNotifications()
          .requestPermissionToSendNotifications();
    }

    if (!allowed) return;

    await ensureDailyNotifications();
    final scheduled = await AwesomeNotifications().listScheduledNotifications();

debugPrint("Scheduled notifications: ${scheduled.length}");

for (final n in scheduled) {
  debugPrint(
    "ID: ${n.content?.id}, Title: ${n.content?.title}, Schedule: ${n.schedule}",
  );
}
  }

  /// Makes sure the fixed reminders exist
  Future<void> ensureDailyNotifications() async {
    final scheduled =
        await AwesomeNotifications().listScheduledNotifications();

    final hasMorning =
        scheduled.any((e) => e.content?.id == 1);

    final hasBackup =
        scheduled.any((e) => e.content?.id == 2);

    if (!hasMorning) {
      await scheduleDailyNotification(
        id: 1,
        hour: 8,
        minute: 0,
        title: "🌤️ Good Morning!",
        body: "Don't forget to mark today's attendance.",
      );
    }

    if (!hasBackup) {
      await scheduleDailyNotification(
        id: 2,
        hour: 20,
        minute: 0,
        title: "☁️ Backup Reminder",
        body: "Don't forget to backup today's attendance data.",
      );
    }
  }

  /// Generic daily notification scheduler
  Future<void> scheduleDailyNotification({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'attendance_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        repeats: true,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );
  }

  /// Instant notification (for testing)
  Future<void> showTestNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 999,
        channelKey: 'attendance_channel',
        title: "📚 StuHub",
        body: "Notifications are working 🎉",
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  /// Cancel one notification
  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}