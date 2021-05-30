import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:location/location.dart' as LOCATION;
import 'package:geolocator/geolocator.dart';

class FullMap extends StatefulWidget {
  Position position;
  FullMap({this.position});

  @override
  _FullMapState createState() => _FullMapState();
}

class _FullMapState extends State<FullMap> {
  WeMapController mapController;
  int searchType = 1; //Type of search bar
  String searchInfoPlace = "Tìm kiếm ở đây"; //Hint text for InfoBar
  String searchPlaceName;
  LatLng myLatLng = LatLng(21.038282, 105.782885);
  bool reverse = true;
  WeMapPlace place;
  Position currentPosition;
  var geoLocator = Geolocator();

  void _onMapCreated(WeMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          WeMap(
            onMapClick: (point, latlng, _place) async {
              place = _place;
            },
            onPlaceCardClose: () {
              // print("Place Card closed");
            },
            reverse: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(widget.position.latitude, widget.position.longitude),
              zoom: 15.0,
            ),
            destinationIcon: "assets/symbols/destination.png",
          ),
          // WeMapSearchBar(
          //   location: myLatLng,
          //   onSelected: (_place) {
          //     setState(() {
          //       print(widget.long);
          //       place = _place;
          //     });
          //     mapController.moveCamera(
          //       CameraUpdate.newCameraPosition(
          //         CameraPosition(
          //           target: place.location,
          //           zoom: 14.0,
          //         ),
          //       ),
          //     );
          //     mapController.showPlaceCard(place);
          //   },
          //   onClearInput: () {
          //     setState(() {
          //       place = null;
          //       mapController.showPlaceCard(place);
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}
