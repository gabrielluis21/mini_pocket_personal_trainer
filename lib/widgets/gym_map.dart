import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class GymMap extends StatelessWidget {
  final double latitude, longitude;

  GymMap({this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      height: 350.0,
      child: FlutterMap(
        options:
            MapOptions(center: LatLng(-21.4000000, -48.5000000), zoom: 13.0),
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
                point: new LatLng(latitude, longitude),
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
    );
  }
}
