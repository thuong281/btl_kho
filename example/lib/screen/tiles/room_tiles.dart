import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wemapgl_example/model/room.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wemapgl_example/screen/room_detail.dart';

class RoomTile extends StatelessWidget {
  @required
  final Room room;

  const RoomTile(this.room);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RoomDetail(room)));
        },
        title: Row(
          children: <Widget>[
            SizedBox(
              width: 85,
              height: 85,
              child: AspectRatio(
                aspectRatio: 1,
                child: FittedBox(
                  child: CachedNetworkImage(
                    imageUrl: room.image[0],
                    placeholder: (context, url) =>
                        Image.asset('assests/placeholder.jpg'),
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    room.name,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      wordSpacing: -0.15,
                    ),
                  ),
                  Text(
                    room.area.toString(),
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      wordSpacing: -0.15,
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: room.price.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            wordSpacing: -0.4,
                            color: Color.fromRGBO(234, 52, 31, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
