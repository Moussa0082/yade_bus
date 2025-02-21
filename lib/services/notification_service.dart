import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationService.instance.sendFlutterNotifications();
  NotificationService.instance.showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool isFlutterLocalNotificationsInitialized = false;

  Future<void> requestPermissions() async {
    final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false);
    print("Permissions statut : ${settings.authorizationStatus}");
  }

  late AndroidNotificationChannel channel;

  Future<void> initialize() async {
  //     if (Platform.isIOS) {
  //   // Demander la permission de recevoir des notifications
  //   await _messaging.requestPermission();

  //   // Récupérer le token APNS
  //   String? token = await _messaging.getAPNSToken();
  //   print("APNS Token: $token");

  //   // Abonnement à un topic Firebase (si besoin)
  //   // FirebaseMessaging.instance.subscribeToTopic('all');

  //   // Vérifie si on est sur un simulateur
  //   // if (Platform.) {
  //   //   print('Running on an iOS simulator, APNS/FCM will not work');
  //   // }
  // }
    await requestPermissions();
    await sendFlutterNotifications(); 
    await setupMessageHandler();

    // final token = await _messaging.getToken();
    // final tokenkey = await _messaging.ge();
    // print("FCM token ${token}");
  }

  Future<void> sendFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    // android config
    // default FCM channel to enable heads up notifications.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // // ios config
    // final initializationSettingDarwin = DarwinInitializationSettings(
    //   onDidReceiveLocalNotification:(){

    //   },
    // );
    final initializationSetting =
        InitializationSettings(android: initializationSettingAndroid);
    isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb && isFlutterLocalNotificationsInitialized) {
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
              iOS: DarwinNotificationDetails(
                  presentAlert: true, presentBadge: true, presentSound: true)),
          payload: message.data.toString());
    }
  }

  Future<void> setupMessageHandler() async {
    // foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showFlutterNotification(message);
    });

    // background message

    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data['type'] == "chat") {
      // ouvrir le chat
    }
  }
}
