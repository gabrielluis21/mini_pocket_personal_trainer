import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_pocket_personal_trainer/models/exercise_model.dart';
import 'package:mini_pocket_personal_trainer/screens/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_model.dart';
import 'package:theme_manager/theme_manager.dart';

const String appId = "ca-app-pub-8831023011848191~6860707039";

int firstLaunch = 0;

const String oneSignalAppId = "bc94702a-76ad-4c30-8168-80f3168ff6a1";

_initApp() async{
  final prefs = await SharedPreferences.getInstance();
  firstLaunch = prefs.getInt('counter') ?? 0;
  prefs.setInt('counter', firstLaunch+1);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAdMob.instance.initialize(appId: appId);
  await OneSignal.shared.init(oneSignalAppId);
  _initApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return ThemeManager(
      defaultBrightnessPreference: BrightnessPreference.light,
      data: (brightness) => ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 90, 90, 253),
        brightness: brightness
      ),
      loadBrightnessOnStart: true,
      themedWidgetBuilder: (context, theme){
        return ScopedModel<UserModel>(
            model: UserModel(),
            child: ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
                return ScopedModel<ExercisesModel>(
                  model: ExercisesModel(model),
                  child: MaterialApp(
                    title: 'Pocket Personal Trainer',
                    theme: theme,
                    debugShowCheckedModeBanner: false,
                    home: SplashScreen(firstLaunch),
                  ),
                );
              },
            )
        );
      },
    );
  }
}