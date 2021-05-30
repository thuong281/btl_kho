part of wemapgl;

WeMapStream<bool> visibleStream = WeMapStream<bool>();
WeMapStream<int> timeStream = WeMapStream<int>();
WeMapStream<int> distanceStream = WeMapStream<int>();
WeMapStream<List<instructionRoute>> insRouteStream =
    WeMapStream<List<instructionRoute>>();
WeMapStream<int> indexStream = WeMapStream<int>();
WeMapStream<List<LatLng>> routeStream = WeMapStream<List<LatLng>>();
WeMapStream<List<LatLng>> routePreviewStream = WeMapStream<List<LatLng>>();
WeMapStream<WeMapPlace> originPlaceStream = WeMapStream<WeMapPlace>();
WeMapStream<WeMapPlace> destinationPlaceStream = WeMapStream<WeMapPlace>();
WeMapStream<bool> isDrivingStream = WeMapStream<bool>();
WeMapStream<bool> fromHomeStream = WeMapStream<bool>();
int time = 0;
int _tripDistance = 0;

class WeMapDirections {
  Future<dynamic> getResponse(int indexOfTab, String from, String to) async {
    String url;
    switch (indexOfTab) {
      case 0:
        url = apiDirection(from, to, 'car');
        break;
//      case 1:
//        url = apiDirection(from, to, 'motorcycle');
//        break;
      case 1:
        url = apiDirection(from, to, 'bike');
        break;
      case 2:
        url = apiDirection(from, to, 'foot');
        break;
    }
    final response = await http.get(url);
    final json = JSON.json.decode(JSON.utf8.decode(response.bodyBytes));

    return json;
  }

  Future<dynamic> getResponseMultiRoute(int indexOfTab, List<LatLng> points) async {
    if(points.length >= 2){
      String url;
      switch (indexOfTab) {
        case 0:
          url = apiDirectionMultiPoint(points, 'car');
          break;
  //      case 1:
  //        url = apiDirection(from, to, 'motorcycle');
  //        break;
        case 1:
          url = apiDirectionMultiPoint(points, 'bike');
          break;
        case 2:
          url = apiDirectionMultiPoint(points, 'foot');
          break;
      }
      print(url);
      final response = await http.get(url);
      final json = JSON.json.decode(JSON.utf8.decode(response.bodyBytes));

      return json;
    } else {
      return null;
    }
  }

  List<LatLng> getRoute(json) {
    List<LatLng> _route = [];
    if (json != null &&
        json['message'] == null &&
        !json['paths'].isEmpty &&
        !json['paths'][0]['points'].isEmpty) {
      _route.clear();
      json['paths'][0]['points']['coordinates'].forEach((item) {
        if (item is List) {
          _route.add(new LatLng(item[1], item[0]));
        }
      });
    }

    return _route;
  }

  List<LatLng> getWayPoints(json) {
    List<LatLng> _route = [];
    if (json != null &&
        json['message'] == null &&
        !json['paths'].isEmpty &&
        !json['paths'][0]['points'].isEmpty) {
      _route.clear();
      json['paths'][0]['snapped_waypoints']['coordinates'].forEach((item) {
        if (item is List) {
          _route.add(new LatLng(item[1], item[0]));
        }
      });
    }

    return _route;
  }

  int getDistance(dynamic json) {
    int _tripDistance = 0;
    if (json != null &&
        json['message'] == null &&
        !json['paths'].isEmpty &&
        json['paths'][0]['distance'] != null) {
      _tripDistance = json['paths'][0]['distance'].toInt();
    }
    return _tripDistance;
  }

  int getTime(dynamic json) {
    int time = 0;
    if (json != null &&
        json['message'] == null &&
        !json['paths'].isEmpty &&
        json['paths'][0]['time'] != null) {
      time = json['paths'][0]['time'];
    }
    return time;
  }

  List<instructionRoute> getInstructionRoute(dynamic json) {
    List<instructionRoute> insRoute = [];
    if (json != null &&
        json['message'] == null &&
        !json['paths'].isEmpty &&
        json['paths'][0]['instructions'] != null) {
      insRoute = (json['paths'][0]['instructions'] as List)
          .map((i) => new instructionRoute.fromJson(i))
          .toList();
    }
    return insRoute;
  }

  List<LatLng> getRoutePreview(
      List<LatLng> _route, List<instructionRoute> insRoute) {
    List<LatLng> routePreview = [];
    insRoute.map((ins) {
      List interval = ins.interval;
      routePreview.add(_route[interval[0]]);
    }).toList();

    return routePreview;
  }

  Future<void> loadRoute(
      WeMapController mapController,
      List<LatLng> _route,
      List<instructionRoute> insRoute,
      List<LatLng> rootPreview,
      bool visible,
      int indexOfTab,
      String from,
      String to) async {
    final json = await getResponse(indexOfTab, from, to);
    _route = await getRoute(json);
    _tripDistance = getDistance(json);
    time = getTime(json);
    insRoute = getInstructionRoute(json);
    rootPreview = getRoutePreview(_route, insRoute);

    if (_route != null) {
      visibleStream.increment(true);
      timeStream.increment(time);
      distanceStream.increment(_tripDistance);
      insRouteStream.increment(insRoute);
      routeStream.increment(_route);
      routePreviewStream.increment(rootPreview);
      await mapController.addLine(
        LineOptions(
          geometry: _route,
          lineColor: "#0071bc",
          lineWidth: 5.0,
          lineOpacity: 1,
        ),
      );
      await mapController.addCircle(CircleOptions(
          geometry: _route[0],
          circleRadius: 8.0,
          circleColor: '#d3d3d3',
          circleStrokeWidth: 1.5,
          circleStrokeColor: '#0071bc'));
      await mapController.addCircle(CircleOptions(
          geometry: _route[_route.length - 1],
          circleRadius: 8.0,
          circleColor: '#ffffff',
          circleStrokeWidth: 1.5,
          circleStrokeColor: '#0071bc'));
    }
  }

  String timeConvert(int time) {
    String string = '';
    if (time < 30000) {
      string = (time ~/ 500).toString() + ' ' + secondText;
    } else if (time >= 30000 && time < 1800000) {
      string = ((time ~/ 500) ~/ 60).toString() + ' ' + minuteText;
    } else if (time >= 1800000 && time < 43200000) {
      string = ((time ~/ 500) ~/ 3600).toString() +
          ' ' +
          hourText +
          ' ' +
          ((((time ~/ 500) % 3600) / 3600) * 60).toInt().toString() +
          ' ' +
          minuteText;
    } else if (time >= 43200000) {
      string = ((time ~/ 500) ~/ 3600).toString() + ' ' + hourText;
    }
    return string;
  }

  Future<void> animatedCamera(
      WeMapController mapController, LatLngBounds bounds) async {
    await mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
      ),
    );
  }

  Future<void> addMarker(
      LatLng latLng, WeMapController mapController, String iconImage) async {
    await mapController.addSymbol(SymbolOptions(
      geometry: latLng, // location is 0.0 on purpose for this example
      iconImage: iconImage,
      iconAnchor: "bottom",
    ));
  }

  Future<void> addCircle(
      LatLng latLng, WeMapController mapController, String color) async {
    await mapController.addCircle(CircleOptions(
        geometry: latLng,
        circleRadius: 8.0,
        circleColor: color,
        circleStrokeWidth: 1.5,
        circleStrokeColor: '#0071bc'));
  }

  LatLngBounds routeBounds(LatLng from, LatLng to) {
    LatLngBounds bounds;
    if (from.latitude <= to.latitude && from.longitude <= to.longitude)
      bounds = LatLngBounds(southwest: from, northeast: to);
    if (to.latitude <= from.latitude && to.longitude <= from.longitude)
      bounds = LatLngBounds(southwest: to, northeast: from);
    if (from.latitude <= to.latitude && from.longitude >= to.longitude)
      bounds = LatLngBounds(
          southwest: LatLng(from.latitude, to.longitude),
          northeast: LatLng(to.latitude, from.longitude));
    if (from.latitude >= to.latitude && from.longitude <= to.longitude)
      bounds = LatLngBounds(
          southwest: LatLng(to.latitude, from.longitude),
          northeast: LatLng(from.latitude, to.longitude));
    return bounds;
  }
}

class WeMapDirection extends StatefulWidget {
  String originIcon;
  String destinationIcon;
  WeMapPlace originPlace;
  WeMapPlace destinationPlace;

  WeMapDirection(
      {this.originIcon,
      this.destinationIcon,
      this.originPlace,
      this.destinationPlace});

  @override
  State createState() => WeMapDirectionState();
}

class WeMapDirectionState extends State<WeMapDirection> {
  WeMapSearch search;
  WeMapController mapController;
  var mapKey = new GlobalKey();
  GlobalKey<ChooseLocationState> _chooseKey = GlobalKey();
  LatLng myLatLng;
  Color primaryColor = Color.fromRGBO(0, 113, 188, 1);
  Color primaryColorTransparent = Color.fromRGBO(0, 113, 188, 0);
  int indexOfTab = 0;
  List<LatLng> _route = [];
  List<LatLng> rootPreview = [];
  List<instructionRoute> insRoute = [];
  bool isController = false;
  bool _changeBackground = false;
  double _panelClosed = 75.0;
  double _panelOpened;
  double _panelCenter = 300.0;
  bool visible = false;
  bool isYour = true;
  bool myLatLngEnabled = true;
  String placeName;
  double paddingBottom;
  String from;
  String to;

  Future<void> _onMapCreated(WeMapController controller) async {
    mapController = controller;
  }

  Future<void> onSelected() async {
    if (myLatLng == null && mapController != null)
      myLatLng = await mapController.requestMyLocationLatLng();
    fromHomeStream.increment(false);
    if ((widget.originPlace == null && _chooseKey.currentState != null && _chooseKey.currentState.ori != null) ||
        (widget.originPlace != null && _chooseKey.currentState.ori != null)) {
      widget.originPlace = new WeMapPlace(
          location: _chooseKey.currentState.ori,
          description: _chooseKey.currentState.location1);
      originPlaceStream.increment(widget.originPlace);
      widget.originPlace.location = _chooseKey.currentState.ori;
    }
    if ((widget.destinationPlace == null &&
            _chooseKey.currentState != null && _chooseKey.currentState.des != null) ||
        (widget.destinationPlace != null &&
            _chooseKey.currentState.des != null)) {
      widget.destinationPlace = new WeMapPlace(
          location: _chooseKey.currentState.des,
          description: _chooseKey.currentState.location2);
      destinationPlaceStream.increment(widget.destinationPlace);
      widget.destinationPlace.location = _chooseKey.currentState.des;
    }
    if (widget.originPlace != null && widget.destinationPlace == null) {
      await mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          widget.originPlace.location,
          18.0,
        ),
      );
      mapController.clearSymbols();
      mapController.clearCircles();
      await WeMapDirections()
          .addCircle(widget.originPlace.location, mapController, '#d3d3d3');
//      await WeMapDirections().addMarker(widget.originPlace.location, mapController, widget.originIcon);
//      myLatLngEnabled = false;
    }
    if (widget.originPlace == null && widget.destinationPlace != null) {
      await mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          widget.destinationPlace.location,
          18.0,
        ),
      );
      mapController.clearSymbols();
      mapController.clearCircles();
      await WeMapDirections().addMarker(widget.destinationPlace.location,
          mapController, widget.destinationIcon);
//      myLatLngEnabled = false;
    }
    if (widget.originPlace != null && widget.destinationPlace != null) {
      from =
          '${widget.originPlace.location.latitude},${widget.originPlace.location.longitude}';
      to =
          '${widget.destinationPlace.location.latitude},${widget.destinationPlace.location.longitude}';
      LatLngBounds bounds = WeMapDirections().routeBounds(
          widget.originPlace.location, widget.destinationPlace.location);
      await WeMapDirections().animatedCamera(mapController, bounds);
      mapController.clearLines();
      mapController.clearCircles();
//      await WeMapDirections().addMarker(widget.originPlace.location, mapController, widget.originIcon);
      await WeMapDirections().loadRoute(mapController, _route, insRoute, rootPreview,
          visible, indexOfTab, from, to);
      mapController.clearSymbols();
      await WeMapDirections().addMarker(widget.destinationPlace.location,
          mapController, widget.destinationIcon);
//      myLatLngEnabled = false;
      if ((widget.originPlace.description != wemap_yourLocation) &&
          (widget.destinationPlace.description != wemap_yourLocation)) {
        isDrivingStream.increment(false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    timeStream.increment(0);
    distanceStream.increment(0);
    insRouteStream.increment(insRoute);
    indexStream.increment(0);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _panelOpened = size.height - MediaQuery.of(context).padding.top;
    return new Scaffold(
        body: Container(
      constraints: BoxConstraints.expand(),
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          WeMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition:
                const CameraPosition(target: LatLng(21.03, 105.78), zoom: 15.0),
            onStyleLoadedCallback: onSelected,
            myLocationEnabled: myLatLngEnabled,
            compassEnabled: true,
            compassViewMargins: Point(24, 550),
            onMapClick: (point, latlng, place) async {},
          ),
          Positioned(
            key: mapKey,
            height: 156 + MediaQuery.of(context).padding.top,
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 0, left: 0, right: 0, bottom: 55),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 0, left: 0, right: 0, bottom: 0),
                            child: ChooseLocation(
                              searchLocation: myLatLng,
                              originPlace: widget.originPlace,
                              destinationPlace: widget.destinationPlace,
                              originIcon: widget.originIcon,
                              destinationIcon: widget.destinationIcon,
                              /*callback: (val) => setState(() => address = val),*/
                              key: _chooseKey,
                              onSelected: onSelected,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Visibility(
                                  visible: false,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: PopupMenuButton<String>(
                                      onSelected: (value) {},
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuItem<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'Lưu',
                                          child: Text(routeShareText),
                                        ),
                                      ],
                                    ),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 5, left: 0, right: 0, bottom: 0),
                                child: IconButton(
                                  onPressed: () async {
                                    _chooseKey.currentState.locationSwap(
                                        widget.originPlace,
                                        widget.destinationPlace);
                                  },
                                  icon: Icon(
                                    Icons.swap_vert,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 45,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: indexOfTab == 0
                                            ? primaryColor
                                            : Colors.transparent,
                                        style: BorderStyle.solid,
                                        width: 2),
                                    top: BorderSide(
                                        color: Colors.transparent,
                                        style: BorderStyle.solid,
                                        width: 2))),
                            child: CupertinoButton(
                                pressedOpacity: 0.8,
                                padding: EdgeInsets.all(0),
                                child: Icon(
                                  Icons.directions_car,
                                  color: indexOfTab == 0
                                      ? primaryColor
                                      : Colors.blueGrey,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    indexOfTab = 0;
                                  });
                                  if (from != null && to != null) {
                                    await mapController.clearLines();
                                    await WeMapDirections().loadRoute(
                                        mapController,
                                        _route,
                                        insRoute,
                                        rootPreview,
                                        visible,
                                        indexOfTab,
                                        from,
                                        to);
                                  }
                                }),
                          ),
                        ),
//                            Expanded(
//                              flex: 1,
//                              child: Container(
//                                decoration: BoxDecoration(
//                                    border: Border(
//                                        bottom: BorderSide(
//                                            color: indexOfTab == 1
//                                                ? primaryColor
//                                                : Colors.transparent,
//                                            style: BorderStyle.solid,
//                                            width: 2),
//                                        top: BorderSide(
//                                            color: Colors.transparent,
//                                            style: BorderStyle.solid,
//                                            width: 2))),
//                                child: CupertinoButton(
//                                    pressedOpacity: 0.8,
//                                    padding: EdgeInsets.all(0),
//                                    child: Icon(
//                                      Icons.motorcycle,
//                                      color: indexOfTab == 1
//                                          ? primaryColor
//                                          : Colors.blueGrey,
//                                    ),
//                                    onPressed: () async {
//                                      setState(() {
//                                        indexOfTab = 1;
//                                      });
//                                      await mapController.clearLines();
//                                      await WeMapDirections().loadRoute(mapController, _route, insRoute, rootPreview, visible, indexOfTab, from, to);
//                                    }),
//                              ),
//                            ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: indexOfTab == 1
                                            ? primaryColor
                                            : Colors.transparent,
                                        style: BorderStyle.solid,
                                        width: 2),
                                    top: BorderSide(
                                        color: Colors.transparent,
                                        style: BorderStyle.solid,
                                        width: 2))),
                            child: CupertinoButton(
                                pressedOpacity: 0.8,
                                padding: EdgeInsets.all(0),
                                child: Icon(
                                  Icons.directions_bike,
                                  color: indexOfTab == 1
                                      ? primaryColor
                                      : Colors.blueGrey,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    indexOfTab = 1;
                                  });
                                  if (from != null && to != null) {
                                    await mapController.clearLines();
                                    await WeMapDirections().loadRoute(
                                        mapController,
                                        _route,
                                        insRoute,
                                        rootPreview,
                                        visible,
                                        indexOfTab,
                                        from,
                                        to);
                                  }
                                }),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: indexOfTab == 2
                                            ? primaryColor
                                            : Colors.transparent,
                                        style: BorderStyle.solid,
                                        width: 2),
                                    top: BorderSide(
                                        color: Colors.transparent,
                                        style: BorderStyle.solid,
                                        width: 2))),
                            child: CupertinoButton(
                                pressedOpacity: 0.8,
                                padding: EdgeInsets.all(0),
                                child: Icon(
                                  Icons.directions_walk,
                                  color: indexOfTab == 2
                                      ? primaryColor
                                      : Colors.blueGrey,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    indexOfTab = 2;
                                  });
                                  if (from != null && to != null) {
                                    await mapController.clearLines();
                                    await WeMapDirections().loadRoute(
                                        mapController,
                                        _route,
                                        insRoute,
                                        rootPreview,
                                        visible,
                                        indexOfTab,
                                        from,
                                        to);
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          WeMapDirectionDetails(
              originPlace: originPlaceStream.data,
              destinationPlace: destinationPlaceStream.data,
              changeBackground: _changeBackground,
              upper: _panelOpened,
              lower: _panelClosed,
              half: _panelCenter,
              route: _route,
              visible: visible,
              indexOfTab: indexOfTab,
              timeConvert: WeMapDirections().timeConvert,
              onSlided: (double pos) {
                setState(() {
                  if (pos < _panelCenter) {
                    paddingBottom = pos;
                  }
                  if (pos >= 0.8) {
                    _changeBackground = true;
                  } else {
                    _changeBackground = false;
                  }
                });
              }),
        ],
      ),
    ));
  }
}

class instructionRoute {
  String text;
  dynamic distance;
  List interval;
  int sign;
  int time;
  String road;

  instructionRoute.fromJson(Map json) {
    this.text = json['text'];
    this.distance = json['distance'];
    this.interval = json['interval'];
    this.sign = json['sign'];
    this.time = json['time'];
    this.road = json['street_name'];
  }
}
