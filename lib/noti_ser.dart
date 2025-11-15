import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:start/main.dart';

class NotificationService {
  final FirebaseMessaging Messaging = FirebaseMessaging.instance;

  Future<void> initNotif() async {
    await Messaging.requestPermission();

    final token = await Messaging.getToken();
    if (token != null) {
      log("Firebase Messaging Token: $token");
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      log("🔔 Foreground message received");
      handleMessage(message, fromBackground: false);
    });

    // When user taps the notification (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("📲 Notification tapped!");
      handleMessage(message, fromBackground: true);
    });

    // When the app is opened by tapping a notification (terminated state)
    final initialMessage = await Messaging.getInitialMessage();
    if (initialMessage != null) {
      log("🚀 App opened from terminated via notification");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleMessage(initialMessage, fromBackground: true);
      });
    }
  }

  void handleMessage(RemoteMessage? message, {required bool fromBackground}) {
    if (message == null) return;

    final data = message.data;
    final title = data['title'] ?? message.notification?.title ?? 'No Title';
    final messagetext = data['message'] ?? message.notification?.body ?? 'No Message';

    log("Message Data → $title - $messagetext");

    if (fromBackground) {
      // Delay navigation until UI is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushNamed(
          '/detail',
          arguments: {
            'title': title,
            'message': messagetext,
          },
        );
      });
    }
  }
}
