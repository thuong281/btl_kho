import 'package:flutter/material.dart';
import 'package:wemapgl_example/model/room.dart';
import 'package:wemapgl_example/network/network_request.dart';
import 'package:wemapgl_example/screen/room_list.dart';
import 'package:wemapgl_example/screen/room_on_map.dart';

class Options extends StatefulWidget {
  @override
  _OptionsState createState() => _OptionsState();
}

circularProgress() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

class _OptionsState extends State<Options> {
  Future _future;
  List<Room> _room = [];

  @override
  void initState() {
    super.initState();
    _future = NetworkRequest.fetchRooms();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return circularProgress();
        } else {
          _room = snapshot.data;
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("List of room"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomList(
                          room: _room,
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text("Map"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceSymbolBody(
                          room: _room,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
