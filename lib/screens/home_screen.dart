import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/sharephoto_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/settings_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/todolist_screen.dart';
import 'package:mini_pocket_personal_trainer/tabs/category_tab.dart';
import 'package:mini_pocket_personal_trainer/tabs/gym_tab.dart';
import 'package:mini_pocket_personal_trainer/tabs/user_tab.dart';
import 'package:mini_pocket_personal_trainer/widgets/custom_drawer.dart';
import 'package:firebase_admob/firebase_admob.dart';


const String adUnitId = "ca-app-pub-8831023011848191/8849749584";

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['fitness', 'fitness apps', 'fitness equipament', 'gym'],
    contentUrl: 'https://flutter.io',
    birthday: DateTime.now(),
    childDirected: false,
    designedForFamilies: false,
    gender: MobileAdGender.male,
    testDevices: <String>["90AC6E90F00D0E963CDEC31A359461FA"],
  );

  BannerAd myBanner = BannerAd(
    adUnitId: adUnitId,
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  @override
  Widget build(BuildContext context) {
    myBanner
    // typically this happens well before the ad is shown
      ..load()
      ..show(
        // Banner Position
        anchorType: AnchorType.bottom,
      );
    return Padding(
      padding: new EdgeInsets.only(bottom: 50.0),
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
           Scaffold(
             appBar: AppBar(
               title: Text("Pocket Personal Trainer"),
               centerTitle: true,
               actions: <Widget>[
                 IconButton(
                   icon: Icon(Icons.camera_alt),
                   onPressed: () async{
                     File imgFile = await ImagePicker
                          .pickImage(source: ImageSource.camera);
                     if(imgFile == null) return;
                     StorageUploadTask task = FirebaseStorage.instance
                       .ref().child("photos").child(
                         UserModel.of(context).firebaseUser.uid +
                              DateTime.now().millisecondsSinceEpoch.toString())
                       .putFile(imgFile);
                     StorageTaskSnapshot snap = await task.onComplete;
                     String url = await snap.ref.getDownloadURL();
                     Navigator.push(context,
                       MaterialPageRoute(
                           builder: (context) => SharePhotoScreen(url)
                     )
                   );
                  },
                 )
               ]
             ),
             floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ToDoListScreen())
                  );
                },
               child: Icon(Icons.fullscreen),
             ),
             drawer: CustomDrawer(_pageController),
             body: UserTab(),
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
             body: GymTab()
           ),
           Scaffold(
             appBar: AppBar(
                title: Text("Configurações"),
                centerTitle: true,
             ),
             drawer: CustomDrawer(_pageController),
             body: SettingsScreen(),
           ),
        ]
      ),
    );
  }
}