import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:social_tech_initiator/src/utils/utils.dart';

class FirebaseNotificationManager {

  static Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission();

    final token = await FirebaseMessaging.instance.getToken();
    flutterPrint("FCM Token: $token");


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      flutterPrint('Foreground message: ${message.notification?.title}');
    });

    flutterPrint("Firebase messaging initialized.");

    await subscribeUserToTopic();
  }

  static Future<void> subscribeUserToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('posts');
    flutterPrint('Subscribed to topic: posts');
  }
}
