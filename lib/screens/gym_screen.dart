import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/gym_data.dart';
import 'package:mini_pocket_personal_trainer/widgets/custom_qr_button.dart';
import 'package:mini_pocket_personal_trainer/widgets/gym_map.dart';

import 'photo_screen.dart';

class GymScreen extends StatefulWidget {
  final GymData academia;

  GymScreen(this.academia);
  @override
  _GymScreenState createState() => _GymScreenState(academia);
}

class _GymScreenState extends State<GymScreen> {
  final GymData academia;

  _GymScreenState(this.academia);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.only(bottom: 50.0),
      child: Scaffold(
          appBar: AppBar(
            title: Text(academia.name),
            centerTitle: true,
          ),
          body: ListView(children: <Widget>[
            Container(
              height: 375.0,
              child: AspectRatio(
                aspectRatio: 0.8,
                child: Carousel(
                  images: academia.images.map((url) {
                    return CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => FlareActor(
                        'assets/animations/WeightSpin.flr',
                        animation: 'Spin',
                      ),
                    );
                  }).toList(),
                  dotSize: 4.0,
                  dotSpacing: 15.0,
                  dotBgColor: Colors.transparent,
                  dotColor: color,
                  autoplay: false,
                  onImageTap: (image) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PhotoScreen(
                            academia.name, academia.images[image])));
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  academia.name,
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                academia.address,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                softWrap: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                academia.city,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child:  multiPhoneText(),
            ),

            GymMap(
                latitude: academia.location["latitude"],
                longitude: academia.location["longitude"]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomQrButton(academia.name),
              ],
            ),
          ])),
    );
  }

  Widget multiPhoneText() {
    
    if(academia.phones.length == 1){
      return Text('${academia.phones.single}',
      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300),
      );  
    }else {
      return Text('${
          academia.phones.join(" , ")
          }', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300),
      );
    }
  }
}

