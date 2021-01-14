import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';

class NotificationServices {
  bool _isActivated;

  String token;

  FirebaseMessaging _messaging = FirebaseMessaging();

  void activeNotifications(UserModel user, Map<String, dynamic> dataNotify) {
    _isActivated = true;
    _configFirebaseMessaging(user, dataNotify);
  }

  void desactiveNotifications() {
    _isActivated = false;
    _messaging = null;
  }

  bool notificationsIsActivated() {
    return _isActivated != null;
  }

  void _configFirebaseMessaging(
      UserModel user, Map<String, dynamic> dataNotify) {
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
    );
    _messaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _messaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Setting required: $settings');
    });
    _messaging.getToken().then((String token) {
      dataNotify["token"] = token;
      this.token = token;
      _saveDeviceToken(dataNotify, user);
    });
  }

  _saveDeviceToken(Map<String, dynamic> dataNotify, UserModel user) async {
    if (token != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.firebaseUser.uid)
          .collection("NotificationSettings")
          .doc().set(dataNotify);
    }
  }
}
