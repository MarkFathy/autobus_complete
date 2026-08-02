import 'dart:async';

import 'package:autobus_complete/src/core/helpers/cache_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background FCM message: ${message.messageId}');
  _showAwesomeNotificationFromRemoteMessage(message);
}

void _showAwesomeNotificationFromRemoteMessage(RemoteMessage message) {
  final notification = message.notification;
  final title = notification?.title ?? (message.data['title'] as String?) ?? 'أتوبيس كومبليت';
  final body = notification?.body ?? (message.data['body'] as String?) ?? '';

  if (title.isNotEmpty || body.isNotEmpty) {
    unawaited(
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: 'basic_channel',
          title: title,
          body: body,
          payload: Map<String, String>.from(message.data),
        ),
      ),
    );
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String channelKey = 'basic_channel';

  /// Initialize Awesome Notifications and FCM setup
  Future<void> initialize() async {
    // 1. Initialize Awesome Notifications Channels
    await AwesomeNotifications().initialize(
      null, // uses default app icon
      [
        NotificationChannel(
          channelKey: channelKey,
          channelName: 'General Notifications',
          channelDescription: 'Notification channel for Autobus Complete game updates and alerts',
          defaultColor: const Color(0xFFF9A825),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
      debug: kDebugMode,
    );

    // 2. Request Notification Permissions
    await requestPermission();

    // 3. Register FCM Handlers
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Foreground FCM message received: ${message.data}');
      _showAwesomeNotificationFromRemoteMessage(message);
    });

    // 4. Save FCM token when user signs in or on token refresh
    await updateFcmTokenInFirestore();
    _fcm.onTokenRefresh.listen(_saveTokenToUserDocument);
  }

  /// Request permissions for local and remote notifications
  Future<bool> requestPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    final settings = await _fcm.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Fetch current FCM token and save to current user document in Firestore
  Future<String?> updateFcmTokenInFirestore() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        debugPrint('====================================================');
        debugPrint('FCM REGISTRATION TOKEN FOR TESTING: $token');
        debugPrint('====================================================');
        await _saveTokenToUserDocument(token);
      }
      return token;
    } on Object catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> _saveTokenToUserDocument(String token) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      try {
        await _firestore.collection('users').doc(uid).set({
          'fcmToken': token,
          'lastTokenUpdate': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint('FCM Token successfully saved for user: $uid');
      } on Object catch (e) {
        debugPrint('Error saving FCM Token to Firestore: $e');
      }
    }
  }

  static const String notificationSettingKey = 'user_notifications_enabled';

  /// Check if notifications are enabled by user preference
  bool isNotificationsEnabled() {
    final val = CacheStorage.read(notificationSettingKey);
    if (val is bool) return val;
    return true; // Default to true
  }

  /// Enable or disable notifications
  Future<void> setNotificationsEnabled({required bool enable}) async {
    await CacheStorage.write(notificationSettingKey, enable);
    if (enable) {
      await requestPermission();
      await updateFcmTokenInFirestore();
    } else {
      // Remove token from Firestore and delete FCM instance token
      final uid = _auth.currentUser?.uid;
      if (uid != null && uid.isNotEmpty) {
        try {
          await _firestore.collection('users').doc(uid).update({'fcmToken': FieldValue.delete()});
        } on Object catch (_) {}
      }
      try {
        await _fcm.deleteToken();
      } on Object catch (_) {}
    }
  }

  /// Trigger a local custom notification programmatically
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    if (!isNotificationsEnabled()) return;
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: channelKey,
        title: title,
        body: body,
        payload: payload,
      ),
    );
  }
}
