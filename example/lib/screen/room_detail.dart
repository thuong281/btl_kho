import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wemapgl_example/model/room.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:wemapgl_example/route.dart';

class RoomDetail extends StatefulWidget {
  @required
  final Room room;

  RoomDetail(this.room);
  @override
  _RoomDetailState createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return position;
  }

  circularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future _future = getCurrentLocation();
    Position position;
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return circularProgress();
        } else {
          position = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.green,
              title: Padding(
                padding: EdgeInsets.fromLTRB(35, 0, 50, 0),
                child: Column(
                  children: [
                    Text(
                      widget.room.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${widget.room.price}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(7, 2, 7, 10),
              child: ListView(
                children: [
                  Text(
                    widget.room.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Carousel(
                      indicatorBgPadding: 7,
                      dotSize: 4,
                      images: widget.room.image.map<CachedNetworkImage>(
                        (String imagePath) {
                          return CachedNetworkImage(
                            imageUrl: imagePath,
                            placeholder: (context, url) =>
                                Image.asset('assests/placeholder.jpg'),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 28,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.room.address,
                              style: TextStyle(
                                color: Colors.blue[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(widget.room.description),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.local_phone_outlined,
                        size: 22,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.room.phone,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.zoom_out_map,
                        size: 22,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Diện tích: " + widget.room.area,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on_sharp,
                        size: 22,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tiền thuê: " + widget.room.price.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Routing(
                            room: widget.room,
                            position: position,
                          ),
                        ),
                      );
                    },
                    child: Text("Chỉ đường"),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
