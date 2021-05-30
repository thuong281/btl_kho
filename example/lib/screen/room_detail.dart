import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wemapgl_example/model/room.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:wemapgl_example/route.dart';

class RoomDetail extends StatefulWidget {
  @required
  final Room room;
  final Position position;

  RoomDetail(this.room, this.position);
  @override
  _RoomDetailState createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Color.fromRGBO(238, 241, 243, 1),
        title: Padding(
          padding: EdgeInsets.fromLTRB(35, 0, 50, 0),
          child: Column(
            children: [
              Text(
                widget.room.title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${widget.room.price}\$',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.red,
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
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Carousel(
                indicatorBgPadding: 7,
                dotSize: 4,
                images: widget.room.imageUrl.map<CachedNetworkImage>(
                  (String imagePath) {
                    return CachedNetworkImage(
                      imageUrl: imagePath,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                        widget.room.location,
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
                        "Diện tích: " + widget.room.area.toString() + "m\u00B2",
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
                        "Số tiền cọc: " + widget.room.price.toString() + " đ",
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Routing(
                      room: widget.room,
                      position: widget.position,
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
}
