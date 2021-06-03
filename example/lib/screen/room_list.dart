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
  List<Room> _room = [];
  List<Room> _roomFilter = [];
  bool _firstLoad = true;
  Future _future;
  Position position = new Position();

  @override
  void initState() {
    super.initState();
    _future = NetworkRequest.fetchRoomss();
  }

  circularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void fetch() {
    _room = NetworkRequest.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    fetch();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
          child: _searchBar(),
        ),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return circularProgress();
          } else {
            _room = snapshot.data;
            if (_firstLoad) {
              _firstLoad = false;
              _roomFilter = _room;
            }
            if (_roomFilter.length > 0) {
              return ListView.builder(
                itemCount: _roomFilter.length,
                itemBuilder: (context, index) {
                  return RoomTile(_roomFilter[index]);
                },
              );
            } else {
              return _emptyList();
            }
          }
        },
      ),
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
            _roomFilter = _room.where((room) {
              var roomAddress = room.address.toLowerCase();
              for (String word in words) {
                if (!roomAddress.contains(word)) return false;
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
}
