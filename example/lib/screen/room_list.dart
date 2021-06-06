import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wemapgl_example/model/room.dart';
import 'package:wemapgl_example/network/network_request.dart';
import 'package:wemapgl_example/screen/tiles/room_tiles.dart';
import 'package:tiengviet/tiengviet.dart';

class RoomList extends StatefulWidget {
  final List<Room> room;
  RoomList({this.room});

  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  List<Room> _roomFilter = [];
  bool _firstLoad = true;
  Future _future;
  Position position = new Position();

  @override
  void initState() {
    super.initState();
    _future = NetworkRequest.fetchRooms();
  }

  circularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(2),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: new Icon(
          Icons.search,
          color: Colors.red,
          size: 25,
        ),
        hintText: 'Tìm kiếm theo địa chỉ',
      ),
      onChanged: (text) {
        text = text.toLowerCase();
        List<String> words = text.split(" ");
        setState(
          () {
            _roomFilter = widget.room.where((room) {
              var roomAddress = room.address.toLowerCase();
              for (String word in words) {
                if (!TiengViet.parse(roomAddress)
                    .contains(TiengViet.parse(word))) return false;
              }
              return true;
            }).toList();
          },
        );
      },
    );
  }

  Widget _emptyList() {
    return Center(
      child: Text('Không tìm thấy phòng'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_firstLoad) {
      _firstLoad = false;
      _roomFilter = widget.room;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
          child: _searchBar(),
        ),
      ),
      body: _roomFilter.length > 0
          ? ListView.builder(
              itemCount: _roomFilter.length,
              itemBuilder: (context, index) {
                return RoomTile(_roomFilter[index]);
              },
            )
          : _emptyList(),
    );
  }
}
