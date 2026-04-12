

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../firebase_options.dart';
import '../notification_service.dart';

class FirebaseInitializer {
  static bool _isInitialized = false;

  static Future<void> setup() async {
    if (_isInitialized) return;

    try {
      print("🚀 Tentative d'initialisation Firebase...");
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await FirebaseMessaging.instance.requestPermission(
        alert: true, badge: true, sound: true,
      );

      await NotificationService.instance.initialize();
      await FirebaseMessaging.instance.subscribeToTopic('all_users');
      
      _isInitialized = true;
      print("✅ Firebase initialisé avec succès");
    } catch (e) {
      print("⚠️ Firebase erreur: $e");
    }
  }
}