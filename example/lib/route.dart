import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:wemapgl_example/model/room.dart';

class Routing extends StatefulWidget {
  Room room;
  Position position;
  Routing({this.position, this.room});

  @override
  _RoutingState createState() => _RoutingState();
}

class _RoutingState extends State<Routing> {
  @override
  void initState() {
    super.initState();
    print(widget.position.latitude.toString() + "cac");
  }

  @override
  Widget build(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
//    _panelOpened = size.height - MediaQuery.of(context).padding.top;
    return WeMapDirection(
        originPlace: WeMapPlace(
            location:
                LatLng(widget.position.latitude, widget.position.longitude)),
        destinationPlace:
            WeMapPlace(location: LatLng(widget.room.lat, widget.room.long)),
        originIcon: "assets/symbols/origin.png",
        destinationIcon: "assets/symbols/destination.png");
  }
}
