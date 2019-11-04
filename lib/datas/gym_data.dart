import 'package:cloud_firestore/cloud_firestore.dart';

class GymData{

  String name;
  String address;
  String city;
  String state;
  String phone;

  List images;

  double latitude;
  double longitude;

  GymData.fromDocument(DocumentSnapshot doc){
    this.name = doc.data["name"];
    this.address = doc.data["address"];
    this.phone = doc.data["phone"];
    this.city = doc.data["city"];
    this.state = doc.data["state"];
    this.images = doc.data["images"];

    this.longitude = doc.data["longitude"];
    this.latitude = doc.data["latitude"];
  }


}