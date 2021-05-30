import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wemapgl_example/model/room.dart';
import 'package:wemapgl_example/network/network_request.dart';
import 'package:wemapgl_example/screen/tiles/room_tiles.dart';

class RoomList extends StatefulWidget {
  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  List<Room> room = [];

  Future _future;
  Position position = new Position();

  @override
  void initState() {
    super.initState();
    _future = getCurrentLocation();
  }

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

  void fetch() {
    room = NetworkRequest.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    fetch();
    return Scaffold(
      appBar: AppBar(
        title: Text("bu cac tao"),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return circularProgress();
          } else {
            position = snapshot.data;
            return ListView.builder(
              itemCount: room.length,
              itemBuilder: (context, index) {
                return RoomTile(room[index], position);
              },
            );
          }
        },
      ),
    );
  }
}
