import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await AppPushNotificationService.instance.setupFlutterNotifications();
    await AppPushNotificationService.instance.showNotification(message);
    appLog("Background message received: ${message.messageId}");
  } catch (e) {
    errorLog("_firebaseMessagingBackgroundHandler", e);
  }
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {
  appLog("Background Notification Clicked: ${details.payload}");
  AppPushNotificationService.instance.handleNotificationClick(details.payload);
}

class AppPushNotificationService {
  AppPushNotificationService._privateConstructor();
  static final AppPushNotificationService _instance = AppPushNotificationService._privateConstructor();
  static AppPushNotificationService get instance => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool _isNotificationSetup = false;
  String? _lastMessageId;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Setup background handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Request permissions
      await _requestPermission();

      // Setup notification channels
      await _setupNotificationChannels();

      // Setup message handlers
      await _setupMessageHandlers();

      // Get FCM token
      _getFcmToken();

      _isInitialized = true;
      appLog("Push Notification Service Initialized");
    } catch (e) {
      errorLog("initialize", e);
    }
  }

  Future<void> _requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true, provisional: false);

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        appLog("Notification permission granted");
      } else {
        appLog("Notification permission denied: ${settings.authorizationStatus}");
      }
    } catch (e) {
      errorLog("_requestPermission", e);
    }
  }

  Future<void> _setupNotificationChannels() async {
    try {
      // Android channel
      const androidChannel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Channel',
        description: 'Rent Me Notifications',
        importance: Importance.high,
      );

      await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
        androidChannel,
      );

      // iOS permissions
      await _localNotifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      errorLog("_setupNotificationChannels", e);
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (_isNotificationSetup) return;

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings();

      final settings = InitializationSettings(android: androidSettings, iOS: darwinSettings);

      await _localNotifications.initialize(
        settings,
        onDidReceiveNotificationResponse: (details) {
          appLog("Notification Clicked: ${details.payload}");
          handleNotificationClick(details.payload);
        },
        onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
      );

      _isNotificationSetup = true;
      appLog("Flutter notifications setup complete");
    } catch (e) {
      errorLog("setupFlutterNotifications", e);
    }
  }

  Future<void> _setupMessageHandlers() async {
    try {
      // Foreground messages
      FirebaseMessaging.onMessage.listen((message) {
        appLog("Foreground message received: ${message.messageId}");
        showNotification(message);
      });

      // When app is opened from terminated state
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        appLog("Initial message received: ${initialMessage.messageId}");
        _handleMessage(initialMessage);
      }

      // When app is opened from background
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        appLog("App opened from background with message: ${message.messageId}");
        _handleMessage(message);
      });
    } catch (e) {
      errorLog("_setupMessageHandlers", e);
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      // Prevent showing duplicate notifications
      if (_lastMessageId == message.messageId) return;
      _lastMessageId = message.messageId;

      final notification = message.notification;
      final android = message.notification?.android;
      final apple = message.notification?.apple;

      if (notification == null || (android == null && apple == null)) return;

      await _localNotifications.show(
        message.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android:
              android != null
                  ? AndroidNotificationDetails(
                    'high_importance_channel',
                    'High Importance Channel',
                    channelDescription: 'Rent Me',
                    importance: Importance.high,
                    priority: Priority.high,
                    icon: android.smallIcon,
                  )
                  : null,
          iOS: apple != null ? DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true) : null,
        ),
        payload: message.data.toString(),
      );

      appLog("Notification shown: ${message.messageId}");
    } catch (e) {
      errorLog("showNotification", e);
    }
  }

  void _handleMessage(RemoteMessage message) {
    try {
      // Handle message when app is opened from notification
      final data = message.data;
      if (data.isNotEmpty) {
        appLog("Message data: $data");
        // Add your navigation logic here based on message data
      }
    } catch (e) {
      errorLog("_handleMessage", e);
    }
  }

  void handleNotificationClick(String? payload) {
    try {
      if (payload != null) {
        appLog("Handling notification click with payload: $payload");
        // Add your navigation logic here based on payload
      }
    } catch (e) {
      errorLog("handleNotificationClick", e);
    }
  }

  Future<void> _getFcmToken() async {
    try {
      final token = await _messaging.getToken();
      appLog("FCM Token: $token");
      // Save this token to your server if needed
    } catch (e) {
      errorLog("_getFcmToken", e);
    }
  }
}

// import 'package:com_bryanmonge_rentalapp/utils/app_log.dart';
// import 'package:com_bryanmonge_rentalapp/utils/error_log.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// @pragma("vm:entry-point")
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   try {
//     await AppPushNotificationServices.instance.setupFlutterNotifications();
//     await AppPushNotificationServices.instance.showNotification(message);
//     appLog(message.messageId);
//   } catch (e) {
//     errorLog("_firebaseMessagingBackgroundHandler notification", e);
//   }
// }

// // Top-level function for handling background notification responses
// @pragma('vm:entry-point')
// void onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {
//   appLog("Background Notification Clicked: ${details.payload}");
// }

// class AppPushNotificationServices {
//   ////////////  contactor start
//   AppPushNotificationServices._privateConstructor();
//   static final AppPushNotificationServices _instance = AppPushNotificationServices._privateConstructor();
//   static AppPushNotificationServices get instance => _instance;
//   ////////////  contactor end
//   ////////////  object start
//   final _messaging = FirebaseMessaging.instance;
//   final _localNotification = FlutterLocalNotificationsPlugin();
//   bool _isFlutterLOcalNotificationInitialized = false;

//   ////////////  object end

//   //////////////  function

//   Future initialize() async {
//     try {
//       FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         _firebaseMessagingBackgroundHandler(message);
//       });

//       ///////////  request permission
//       await _requestPermission();
//       ///////////  setup message handlers
//       await _setupMessageHandlers();

//       //////////////  get fcm token
//       _messaging.getToken().then((String? token) {
//         appLog("FCM Token: $token");
//       }).catchError((e) {
//         errorLog("getToken error", e);
//       });
//     } catch (e) {
//       errorLog("initialize", e);
//     }
//   }

//   Future<void> _requestPermission() async {
//     try {
//       // await _messaging.requestPermission(alert: true, badge: true, sound: true, provisional: false, announcement: false, carPlay: false, criticalAlert: false);
//       NotificationSettings settings = await _messaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//         announcement: false,
//         carPlay: false,
//         criticalAlert: false,
//       );

//       if (settings.authorizationStatus != AuthorizationStatus.authorized) {
//         appLog("Notification permission denied!");
//       } else {
//         appLog("Notification permission granted!");
//       }
//     } catch (e) {
//       errorLog("_requestPermission notification", e);
//     }
//   }

//   Future<void> setupFlutterNotifications() async {
//     try {
//       if (_isFlutterLOcalNotificationInitialized) {
//         return;
//       }

//       ///////////  android setup
//       const androidChanel =
//           AndroidNotificationChannel("high_importance_channel", "High Importance Channel", description: "Rent Me", importance: Importance.high);

//       await _localNotification
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(androidChanel);

//       const initializationSettingAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");

//       ////////////////  ios setup

//       final initializationSettingDarwin = DarwinInitializationSettings(
//         notificationCategories: [
//           DarwinNotificationCategory(
//             'demoCategory',
//             actions: <DarwinNotificationAction>[
//               DarwinNotificationAction.plain('id_1', 'Action 1'),
//               DarwinNotificationAction.plain(
//                 'id_2',
//                 'Action 2',
//                 options: <DarwinNotificationActionOption>{
//                   DarwinNotificationActionOption.destructive,
//                 },
//               ),
//               DarwinNotificationAction.plain(
//                 'id_3',
//                 'Action 3',
//                 options: <DarwinNotificationActionOption>{
//                   DarwinNotificationActionOption.foreground,
//                 },
//               ),
//             ],
//             options: <DarwinNotificationCategoryOption>{
//               DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
//             },
//           )
//         ],
//       );
//       // Request iOS permissions
//       await _localNotification.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
//             alert: true,
//             badge: true,
//             sound: true,
//           );
//       final initializationSettings = InitializationSettings(android: initializationSettingAndroid, iOS: initializationSettingDarwin);

//       //////////////  flutter notification setup

//       await _localNotification.initialize(
//         initializationSettings,
//         onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
//         onDidReceiveNotificationResponse: (details) {
//           appLog("Notification Clicked: ${details.payload}");
//         },
//       );

//       _isFlutterLOcalNotificationInitialized = true;
//     } catch (e) {
//       errorLog("_setupFlutterNotifications notification", e);
//     }
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     try {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       AppleNotification? apple = message.notification?.apple;
//       if (notification != null && apple != null || android != null) {
//         appLog(apple?.subtitle);
//         await _localNotification.show(
//           notification.hashCode,
//           notification?.title ?? "",
//           notification?.body ?? "",
//           NotificationDetails(
//             android: android != null
//                 ? AndroidNotificationDetails("high_importance_channel", "High Importance Channel",
//                     channelDescription: "Rent Me", importance: Importance.high, priority: Priority.high, icon: "@mipmap/ic_launcher")
//                 : null,
//             iOS: apple != null
//                 ? DarwinNotificationDetails(
//                     presentAlert: true,
//                     presentBadge: true,
//                     presentSound: true,
//                   )
//                 : null,
//           ),
//           payload: message.data.toString(),
//         );
//       }
//     } catch (e) {
//       errorLog("showNotification notification", e);
//     }
//   }

//   Future<void> _setupMessageHandlers() async {
//     try {
//       ///////////  foreground message
//       FirebaseMessaging.onMessage.listen((message) {
//         showNotification(message);
//       });

//       ///////////  background message
//       FirebaseMessaging.onMessageOpenedApp.listen((message) {
//         _handleBackgroundMessage(message);
//       });
//       /////////// opened app
//       final initialMessage = await _messaging.getInitialMessage();
//       if (initialMessage != null) {
//         _handleBackgroundMessage(initialMessage);
//       }
//     } catch (e) {
//       errorLog("_setupMessageHandlers notification", e);
//     }
//   }

//   void _handleBackgroundMessage(RemoteMessage message) {
//     try {
//       if (message.data["type"] == "screen") {}
//     } catch (e) {
//       errorLog("_handleBackgroundMessage notification", e);
//     }
//   }
// }
