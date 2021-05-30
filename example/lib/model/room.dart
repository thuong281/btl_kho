class Room {
  int id;
  String title;
  List<String> imageUrl;
  String price;
  double area;
  double lat;
  double long;
  String location;
  String description;
  String furniture;
  String phone;

  Room(
      {this.id,
      this.title,
      this.imageUrl,
      this.price,
      this.area,
      this.lat,
      this.long,
      this.location,
      this.description,
      this.furniture,
      this.phone});

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    price = json['price'];
    area = json['area'];
    lat = json['lat'];
    long = json['long'];
    location = json['code'];
    description = json['description'];
    furniture = json['furniture'];
    phone = json['phone'];
  }
}
