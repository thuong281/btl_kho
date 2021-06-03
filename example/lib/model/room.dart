// To parse this JSON data, do
//
//     final room = roomFromJson(jsonString);

import 'dart:convert';

List<Room> roomFromJson(String str) =>
    List<Room>.from(json.decode(str).map((x) => Room.fromJson(x)));

String roomToJson(List<Room> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Room {
  Room({
    this.name,
    this.price,
    this.area,
    this.district,
    this.image,
    this.description,
    this.address,
    this.phone,
    this.lat,
    this.long,
  });

  String name;
  String price;
  String area;
  String district;
  List<String> image;
  String description;
  String address;
  String phone;
  double lat;
  double long;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        name: json["name"],
        price: json["price"],
        area: json["area"] == null ? null : json["area"],
        district: json["district"],
        image: List<String>.from(json["image"].map((x) => x)),
        description: json["description"],
        address: json["address"],
        phone: json["phone"],
        lat: json["lat"].toDouble(),
        long: json["long"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "area": area == null ? null : area,
        "district": district,
        "image": List<dynamic>.from(image.map((x) => x)),
        "description": description,
        "address": address,
        "phone": phone,
        "lat": lat,
        "long": long,
      };
}
