import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'guardian_alerts',
          channelKey: 'guardian_alerts',
          channelName: 'Guardian Alerts',
          channelDescription: 'Security alerts for family protection',
          defaultColor: const Color(0xFF1E3A5F),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
      debug: true,
    );

    // Request notification permissions
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> triggerGuardianAlert(String memberName, String threatType) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'guardian_alerts',
        title: '🚨 Guardian Alert',
        body: '$memberName detected $threatType threat!',
        category: NotificationCategory.Alarm,
        notificationLayout: NotificationLayout.Default,
        payload: {
          'memberName': memberName,
          'threatType': threatType,
          'timestamp': DateTime.now().toIso8601String(),
        },
        autoDismissible: false,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'VIEW_DETAILS',
          label: 'View Details',
          actionType: ActionType.Default,
        ),
        NotificationActionButton(
          key: 'MARK_SAFE',
          label: 'Mark Safe',
          actionType: ActionType.Default,
        ),
      ],
    );
  }

  Future<void> triggerScamAlert(String scamType, String message) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'guardian_alerts',
        title: '⚠️ Scam Detected',
        body: 'Potential $scamType scam detected: ${message.substring(0, 50)}...',
        category: NotificationCategory.Message,
        notificationLayout: NotificationLayout.Default,
        payload: {
          'scamType': scamType,
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
        },
        autoDismissible: false,
      ),
    );
  }

  Future<void> triggerSystemAlert(String title, String message) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'guardian_alerts',
        title: title,
        body: message,
        category: NotificationCategory.Status,
        notificationLayout: NotificationLayout.Default,
        payload: {
          'type': 'system',
          'timestamp': DateTime.now().toIso8601String(),
        },
      ),
    );
  }
}
