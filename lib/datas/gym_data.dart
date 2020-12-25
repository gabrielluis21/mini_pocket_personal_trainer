import 'package:cloud_firestore/cloud_firestore.dart';

class GymData {
  String name;
  String address;
  String city;
  String state;
  List phones;

  List images;

  Map<dynamic, dynamic> location = Map();

  GymData.fromDocument(DocumentSnapshot doc) {
    this.name = doc.data["name"];
    this.address = doc.data["address"];
    this.phones = doc.data["phones"];
    this.city = doc.data["city"];
    this.state = doc.data["state"];
    this.images = doc.data["images"];
    this.location = doc.data["location"];
  }
}
