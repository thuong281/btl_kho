import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:wemapgl_example/model/room.dart';
import 'package:wemapgl_example/screen/room_detail.dart';

class PlaceSymbolBody extends StatefulWidget {
  final List<Room> room;
  PlaceSymbolBody({this.room});

  @override
  State<StatefulWidget> createState() => PlaceSymbolBodyState();
}

class PlaceSymbolBodyState extends State<PlaceSymbolBody> {
  static final LatLng center = const LatLng(20.8275, 105.3391);
  String iconImage = "assets/symbols/origin.png";
  HashMap map = new HashMap<String, Room>();
  bool show = true;
  WeMapController controller;
  int _symbolCount = 0;
  Symbol _selectedSymbol;
  WeMap weMap;

  void _onMapCreated(WeMapController controller) {
    this.controller = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  @override
  void dispose() {
    controller?.onSymbolTapped?.remove(_onSymbolTapped);
    super.dispose();
  }

  void _onSymbolTapped(Symbol symbol) {
    if (_selectedSymbol != null) {
      _updateSelectedSymbol(
        SymbolOptions(
          iconSize: 1.0,
          iconImage: iconImage,
        ),
      );
    }
    setState(() {
      _selectedSymbol = symbol;
    });
    _updateSelectedSymbol(
      SymbolOptions(
        iconSize: 1.6,
        iconImage: "assets/symbols/destination.png",
      ),
    );
  }

  void _updateSelectedSymbol(SymbolOptions changes) {
    controller.updateSymbol(_selectedSymbol, changes);
  }

  void _add(String iconImage) {
    controller.addSymbol(
      SymbolOptions(
        geometry: LatLng(
          center.latitude,
          center.longitude,
        ),
        iconImage: iconImage,
      ),
    );
    setState(() {
      print(_symbolCount);
      _symbolCount += 1;
    });
  }

  void _remove() {
    controller.removeSymbol(_selectedSymbol);
    setState(() {
      _selectedSymbol = null;
      _symbolCount -= 1;
    });
  }

  void _changePosition() {
    final LatLng current = _selectedSymbol.options.geometry;
    final Offset offset = Offset(
      center.latitude - current.latitude,
      center.longitude - current.longitude,
    );
    _updateSelectedSymbol(
      SymbolOptions(
        geometry: LatLng(
          center.latitude + offset.dy,
          center.longitude + offset.dx,
        ),
      ),
    );
  }

  void _changeIconOffset() {
    Offset currentAnchor = _selectedSymbol.options.iconOffset;
    if (currentAnchor == null) {
      // default value
      currentAnchor = Offset(0.0, 0.0);
    }
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    _updateSelectedSymbol(SymbolOptions(iconOffset: newAnchor));
  }

  Future<void> _changeIconAnchor() async {
    String current = _selectedSymbol.options.iconAnchor;
    if (current == null || current == 'center') {
      current = 'bottom';
    } else {
      current = 'center';
    }
    _updateSelectedSymbol(
      SymbolOptions(iconAnchor: current),
    );
  }

  Future<void> _toggleDraggable() async {
    bool draggable = _selectedSymbol.options.draggable;
    if (draggable == null) {
      // default value
      draggable = false;
    }

    _updateSelectedSymbol(
      SymbolOptions(draggable: !draggable),
    );
  }

  Future<void> _changeAlpha() async {
    double current = _selectedSymbol.options.iconOpacity;
    if (current == null) {
      // default value
      current = 1.0;
    }

    _updateSelectedSymbol(
      SymbolOptions(iconOpacity: current < 0.1 ? 1.0 : current * 0.75),
    );
  }

  Future<void> _changeRotation() async {
    double current = _selectedSymbol.options.iconRotate;
    if (current == null) {
      // default value
      current = 0;
    }
    _updateSelectedSymbol(
      SymbolOptions(iconRotate: current == 330.0 ? 0.0 : current + 30.0),
    );
  }

  Future<void> _toggleVisible() async {
    double current = _selectedSymbol.options.iconOpacity;
    if (current == null) {
      // default value
      current = 1.0;
    }

    _updateSelectedSymbol(
      SymbolOptions(iconOpacity: current == 0.0 ? 1.0 : 0.0),
    );
  }

  Future<void> _changeZIndex() async {
    int current = _selectedSymbol.options.zIndex;
    if (current == null) {
      // default value
      current = 0;
    }
    _updateSelectedSymbol(
      SymbolOptions(zIndex: current == 12 ? 0 : current + 1),
    );
  }

  void initRoomOnMap() {
    for (Room room in widget.room) {
      controller.addSymbol(
        SymbolOptions(
          geometry: LatLng(
            room.lat,
            room.long,
          ),
          iconSize: 1,
          iconImage: iconImage,
        ),
        room.toJson(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    weMap = WeMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: LatLng(21.0278, 105.8342),
        zoom: 14.0,
      ),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   for (Room room in widget.room) {
  //     controller.addSymbol(
  //       SymbolOptions(
  //         geometry: LatLng(
  //           room.lat,
  //           room.long,
  //         ),
  //         iconImage: iconImage,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: SizedBox(
              height: 400.0,
              child: weMap,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 28,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedSymbol != null
                          ? Room.fromJson(_selectedSymbol.data).address
                          : "No data",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.zoom_out_map,
                size: 28,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedSymbol != null
                          ? Room.fromJson(_selectedSymbol.data).area
                          : "No data",
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
          Row(
            children: [
              Icon(
                Icons.monetization_on_sharp,
                size: 28,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedSymbol != null
                          ? Room.fromJson(_selectedSymbol.data).price
                          : "No data",
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text("Ẩn/hiện trên bản đồ"),
                onPressed: () {
                  if (show) {
                    for (Room room in widget.room) {
                      controller.addSymbol(
                        SymbolOptions(
                          geometry: LatLng(
                            room.lat,
                            room.long,
                          ),
                          iconSize: 1,
                          iconImage: iconImage,
                        ),
                        room.toJson(),
                      );
                    }
                    show = false;
                  } else {
                    controller.clearSymbols();
                    setState(() {
                      _selectedSymbol = null;
                    });
                    show = true;
                  }
                },
              ),
              ElevatedButton(
                child: Text("Xem chi tiết"),
                onPressed: () {
                  Room selectedRoom = Room.fromJson(_selectedSymbol.data);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomDetail(selectedRoom),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
