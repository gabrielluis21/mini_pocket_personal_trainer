import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/settings_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/sharephoto_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/todolist_screen.dart';
import 'package:mini_pocket_personal_trainer/tabs/category_tab.dart';
import 'package:mini_pocket_personal_trainer/tabs/gym_tab.dart';
import 'package:mini_pocket_personal_trainer/tabs/user_tab.dart';
import 'package:mini_pocket_personal_trainer/widgets/custom_drawer.dart';
import 'package:scoped_model/scoped_model.dart';

const String adUnitId = "ca-app-pub-8831023011848191/8849749584";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  final picker = ImagePicker();

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['fitness', 'fitness apps', 'fitness equipament', 'gym'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>["90AC6E90F00D0E963CDEC31A359461FA", ],
  );
  BannerAd myBanner = BannerAd(
    adUnitId: adUnitId,
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        statusBarIconBrightness: Brightness.light));

    myBanner
      // typically this happens well before the ad is shown
      ..load()
      ..show(
        // Banner Position
        anchorType: AnchorType.bottom,
      );

    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Padding(
          padding: new EdgeInsets.only(bottom: 50.0),
          child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Scaffold(
                  appBar: AppBar(
                      title: Text(
                        "Pocket Personal Trainer",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      centerTitle: true,
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            size: 25.0,
                          ),
                          onPressed: () async {
                            PickedFile imgFile = await picker.getImage(
                                source: ImageSource.camera);
                            if (imgFile == null) return;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SharePhotoScreen(new File(imgFile.path))));
                          },
                        )
                      ]),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ToDoListScreen()));
                    },
                    icon: Icon(Icons.zoom_out_map),
                    label: Text("Ver lista completa"),
                  ),
                  drawerDragStartBehavior: DragStartBehavior.start,
                  drawer: CustomDrawer(_pageController),
                  body: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: UserTab(model),
                  ),
                ),
                Scaffold(
                  appBar: AppBar(
                    title: Text("Exercicios"),
                    centerTitle: true,
                  ),
                  drawer: CustomDrawer(_pageController),
                  body: CategoryTab(),
                ),
                Scaffold(
                    appBar: AppBar(
                      title: Text("Academias parceiras"),
                      centerTitle: true,
                    ),
                    drawer: CustomDrawer(_pageController),
                    body: GymTab()),
                Scaffold(
                  appBar: AppBar(
                    title: Text("Configurações"),
                    centerTitle: true,
                  ),
                  drawer: CustomDrawer(_pageController),
                  body: SettingsScreen(model),
                ),
              ]),
        );
      },
    );
  }
}
