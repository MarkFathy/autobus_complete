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
  // CRITICAL FIX: When an FCM message contains a 'notification' payload (from Firebase Console or API),
  // the Android OS native FCM SDK automatically displays the notification in the status bar when the app is in background/closed.
  // Calling Awesome Notifications here causes a 2nd DUPLICATE notification banner on Android.
  // Therefore, only trigger Awesome Notifications in background for data-only messages (message.notification == null).
  if (message.notification == null) {
    _showAwesomeNotificationFromRemoteMessage(message);
  }
}

final Set<String> _processedMessageIds = {};

void _showAwesomeNotificationFromRemoteMessage(RemoteMessage message) {
  final notification = message.notification;
  final title = notification?.title ?? message.data['title'] ?? 'أتوبيس كومبليت';
  final body = notification?.body ?? message.data['body'] ?? '';
  final imageUrl = notification?.android?.imageUrl ??
      notification?.apple?.imageUrl ??
      message.data['image'];

  final hasImage = imageUrl != null && imageUrl.isNotEmpty;

  // Use deterministic notification ID based on messageId so same message NEVER duplicates
  final notificationId = message.messageId != null
      ? (message.messageId.hashCode.abs() % 100000)
      : DateTime.now().millisecondsSinceEpoch.remainder(100000);

  if (title.isNotEmpty || body.isNotEmpty) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        bigPicture: hasImage ? imageUrl : null,
        notificationLayout:
            hasImage ? NotificationLayout.BigPicture : NotificationLayout.Default,
        payload: Map<String, String>.from(message.data),
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

    // Foreground: show notification via awesome_notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground FCM message received: ${message.data}');
      _showAwesomeNotificationFromRemoteMessage(message);
    });

    // App opened from notification (background → foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification tapped (background): ${message.data}');
    });

    // App opened from terminated state via notification
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App launched from notification: ${initialMessage.data}');
    }

    // 4. Subscribe to topic 'all' for dashboard broadcast notifications
    await _fcm.subscribeToTopic('all');
    debugPrint('[NotificationService] Subscribed to topic: all');

    // 5. Listen to Firestore notifications_log for instant guaranteed delivery
    _listenToFirestoreNotifications();

    // 6. Save FCM token when user signs in or on token refresh
    await updateFcmTokenInFirestore();
    _fcm.onTokenRefresh.listen((newToken) {
      _saveTokenToUserDocument(newToken);
    });
  }

  /// Realtime Firestore listener for instant notification delivery from Dashboard
  void _listenToFirestoreNotifications() {
    final sessionStartTime = Timestamp.now();
    _firestore
        .collection('notifications_log')
        .where('createdAt', isGreaterThan: sessionStartTime)
        .snapshots()
        .listen((snapshot) {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          if (data == null) continue;

          final targetUserId = data['targetUserId'] as String?;
          final currentUid = _auth.currentUser?.uid;

          if (targetUserId == 'ALL' ||
              (currentUid != null && targetUserId == currentUid)) {
            final title = data['title'] as String? ?? 'أتوبيس كومبليت';
            final body = data['body'] as String? ?? '';
            final imageUrl = data['imageUrl'] as String?;

            final docId = change.doc.id;
            if (_processedMessageIds.contains(docId)) continue;
            _processedMessageIds.add(docId);

            AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: docId.hashCode.abs() % 100000,
                channelKey: channelKey,
                title: title,
                body: body,
                bigPicture: (imageUrl != null && imageUrl.isNotEmpty) ? imageUrl : null,
                notificationLayout: (imageUrl != null && imageUrl.isNotEmpty)
                    ? NotificationLayout.BigPicture
                    : NotificationLayout.Default,
              ),
            );
          }
        }
      }
    });
  }

  /// Request permissions for local and remote notifications
  Future<bool> requestPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
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
    } catch (e) {
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
      } catch (e) {
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
  Future<void> setNotificationsEnabled(bool enable) async {
    await CacheStorage.write(notificationSettingKey, enable);
    if (enable) {
      await requestPermission();
      await updateFcmTokenInFirestore();
    } else {
      // Remove token from Firestore and delete FCM instance token
      final uid = _auth.currentUser?.uid;
      if (uid != null && uid.isNotEmpty) {
        try {
          await _firestore.collection('users').doc(uid).update({
            'fcmToken': FieldValue.delete(),
          });
        } catch (_) {}
      }
      try {
        await _fcm.deleteToken();
      } catch (_) {}
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
