import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mini_pocket_personal_trainer/datas/gym_data.dart';
import 'package:mini_pocket_personal_trainer/widgets/custom_qr_button.dart';

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
            Text(
              academia.name,
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            Text(
              academia.address,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Text(
              academia.city,
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            Text(
              academia.phone.length == 1
                  ? '${academia.phone.first}'
                  : academia.phone.map((phone) => '$phone'),
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              height: 350.0,
              child: FlutterMap(
                options: MapOptions(
                    center: LatLng(-21.4000000, -48.5000000), zoom: 13.0),
                layers: [
                  new TileLayerOptions(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/gabrielluis-21/ck1tqvcip6pp11cqryom8gea1/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZ2FicmllbGx1aXMtMjEiLCJhIjoiY2sxdDlsODV2MDA1dzNibHdhaXV5eTNiOSJ9.cgxQVxtyLZrgI2DAXh7sdQ",
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoiZ2FicmllbGx1aXMtMjEiLCJhIjoiY2sxdDl3eGJvMDBxYjNmbXJyNWtvYXJ6NSJ9.beuFPzsDk-kwfbBI2dIZoA',
                      'id': 'mapbox.mapbox-streets-v8',
                    },
                  ),
                  new MarkerLayerOptions(
                    markers: [
                      new Marker(
                        width: 40.0,
                        height: 50.0,
                        point:
                            new LatLng(academia.latitude, academia.longitude),
                        builder: (ctx) => new Container(
                            child: IconButton(
                          icon: Icon(Icons.location_on),
                          color: Theme.of(context).primaryColor,
                          iconSize: 25.0,
                          onPressed: () {},
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomQrButton(academia.name),
              ],
            ),
          ])),
    );
  }
}
