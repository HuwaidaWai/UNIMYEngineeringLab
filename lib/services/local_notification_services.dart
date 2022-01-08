import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', "High Importance Notifcations",
      // "This channel is used important notification",
      groupId: "Notification_group");
  //* Setup singleton factory
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    print('Factory initialized');
    return _notificationService;
  }

  NotificationService._internal();

  Future init() async {
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_unimy');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    //?KIV: Is it to return or just make it void
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  //?Handle notification tapped
  static Future selectNotification(String? payload) async {
    if (payload == 'data') {
      //log('Hai awak tekan notification, ini datanya :$payload');
    }
  }

  //? Handle notification for iOS when tapped
  // KIV: If this will be implement or not
  static Future onDidReceiveLocalNotification(
      int i, String? string1, String? string2, String? string3) async {
    //log('Message: $string1');
  }

  Future showNotification(
    RemoteNotification notification,
  ) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      '1',
      'asda',

      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      fullScreenIntent: true,
      styleInformation: BigTextStyleInformation(''),
      // sound: RawResourceAndroidNotificationSound("slow_spring_board"),
      groupKey: '1',
      autoCancel: false,
      // styleInformation: inboxStyleInformation
    );

    IOSNotificationDetails iOSPlatformChannelSpecifics =
        const IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
        android: androidPlatformChannelSpecifics);

    String? title = notification.title;
    String? body = notification.body;

    await flutterLocalNotificationsPlugin.show(
        notification.hashCode, title, body, platformChannelSpecifics,
        payload: 'data');
  }
}
