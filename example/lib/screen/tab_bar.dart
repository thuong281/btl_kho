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
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              backgroundColor: Colors.green,
              title: Text('Tìm phòng trọ'),
            ),
          ),
          bottomNavigationBar: menu(),
          body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return circularProgress();
              } else {
                _room = snapshot.data;
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    RoomList(
                      room: _room,
                    ),
                    PlaceSymbolBody(
                      room: _room,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget menu() {
    return Container(
      color: Colors.green,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.white,
        tabs: [
          Tab(
            icon: Icon(Icons.list),
          ),
          Tab(
            icon: Icon(Icons.map_outlined),
          ),
        ],
      ),
    );
  }
}
