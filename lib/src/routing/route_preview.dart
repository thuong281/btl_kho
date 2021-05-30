part of wemapgl;

class Preview{
  Symbol buildMarker(String id, String iconImage, LatLng latLng) {
    return new Symbol(
        id,
        SymbolOptions(
            geometry: latLng,
            iconImage: iconImage,
            iconAnchor: 'bottom'
        )
    );
  }

  Circle buildCircle(String id, LatLng latLng) {
    return new Circle(
        id,
        CircleOptions(
          geometry: latLng,
        )
    );
  }

  void animatedMapMove(WeMapController mapController, LatLng latLng, double zoom){
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: zoom)
      ),
    );
  }

  void loadLine(WeMapController mapController, List<LatLng> _route){
    mapController.addLine(
      LineOptions(
        geometry: _route,
        lineColor: "#ff0000",
        lineWidth: 5.0,
        lineOpacity: 1,
      ),
    );
  }

  void loadPreviewFromDetail(WeMapController mapController, List<LatLng> rootPreview, int index, bool isFromDetail) {
    if (isFromDetail == true) {
      animatedMapMove(mapController, rootPreview[index], 18);
    } else {}
  }
}

class WeMapDirectionPreview extends StatefulWidget {
  WeMapPlace originPlace;
  WeMapPlace destinationPlace;
  List<instructionRoute> listIns;
  List<LatLng> route;
  List<LatLng> rootReview;
  bool isFromDetail;
  int indexFromDetail;
  int indexOfTab;
  List<Image> iconRoute;
  WeMapDirectionPreview(
      {this.listIns,
        this.route,
        this.rootReview,
        this.isFromDetail,
        this.indexFromDetail,
        this.iconRoute,
        this.indexOfTab,
        this.originPlace,
        this.destinationPlace});
  @override
  _WeMapDirectionPreviewState createState() => new _WeMapDirectionPreviewState();
}

class _WeMapDirectionPreviewState extends State<WeMapDirectionPreview> with TickerProviderStateMixin {
  WeMapController mapController;
  SnaplistController snaplistController;
  ListPreviewCard previewList;
  LatLng lat;
  LatLng lon = new LatLng(20.037, 105.7876);
  AppBar appBar;
  bool isOn = true;
  int center;
  int position = 0;

  LatLng latLng = LatLng(21.037, 105.7876);
  final List<Symbol> markers = [];
  final List<Circle> circles = [];
  List<LatLng> rootPreview = [];

  void animatedMapMove(LatLng latLng, double zoom) async {
    await mapController.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, zoom)
    );
  }

  Future<void> _onMapCreated(WeMapController controller) async {
    mapController = controller;
    circles.clear();
    rootPreview.clear();

    for (var i in widget.rootReview) {
      rootPreview.add(i);
    }
    // print(rootPreview);
    // print(widget.listIns.length);
    // print(widget.isFromDetail);
    // print(widget.indexFromDetail);
    // print(routeStream.data);
  }

  Future<void> onStyleLoadedCallback() async {
    mapController.addLine(
      LineOptions(
        geometry: routeStream.data,
        lineColor: "#0071bc",
        lineWidth: 5.0,
        lineOpacity: 1,
      ),
    );
    for (var i in rootPreview){
      Circle c = await mapController.addCircle(
          CircleOptions(
              geometry: i,
              circleRadius: 10.0,
              circleColor: '#ffffff',
              circleStrokeWidth: 1.5,
              circleStrokeColor: '#0071bc'
          )
      );
      circles.add(c);
    }
  }

  @override
  void initState() {
    super.initState();
    snaplistController = new SnaplistController(
      initialPosition:
      widget.isFromDetail == true ? widget.indexFromDetail : 0,
    );
    if (widget.isFromDetail == false){
      animatedMapMove(rootPreview[0], 18);
    }
    if (widget.isFromDetail == true){
      animatedMapMove(rootPreview[widget.indexFromDetail], 18);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar = AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            circles.clear();
            rootPreview.clear();
            Navigator.pop(context);
          },
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: new Text(preview,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        elevation: 1.0,
      ),
      body: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.white,
          child: Stack(children: <Widget>[
            WeMap(
              onMapCreated: _onMapCreated,
              compassEnabled: true,
              compassViewMargins: Point(24,172),
              initialCameraPosition:
              CameraPosition(target: routeStream.data[0], zoom: 18.0),
              onStyleLoadedCallback: onStyleLoadedCallback,
            ),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              child: FloatingActionButton(
                onPressed: () {
                  if (isOn) {
                    setState(() {
                      isOn = false;
                    });
                  } else if (!isOn) {
                    setState(() {
                      isOn = true;
                    });
                  }
                },
                child: isOn
                    ? new Icon(Icons.volume_up)
                    : new Icon(Icons.volume_off),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                mini: true,
              ),
            ),
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height -
                  100 -
                  MediaQuery.of(context).size.width * 0.02 -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top,
              right: 0,
              child: Container(
                color: Colors.transparent,
                height: 100,
                child: previewList = ListPreviewCard(
                  listIns: widget.listIns,
                  snaplistController: snaplistController,
                  mapMove: animatedMapMove,
                  latLng: rootPreview,
                  isOn: isOn,
                  iconRoute: widget.iconRoute,
                  circles: circles,
                  position: (int pos) {
                    setState(() {
                      position = pos;
                      center = previewList.center;
                    });
                  },
                  mapController: mapController,
                ),
              ),
            ),
            Positioned(
              bottom: 100 + MediaQuery.of(context).size.width * 0.04,
              left: 44 + MediaQuery.of(context).size.width * 0.02,
              child: FloatingActionButton(
                onPressed: position == 2
                    ? null
                    : () async {
                      if (previewList.center == null && center == null) {
                        widget.isFromDetail == true
                            ? center = widget.indexFromDetail
                            : center = 0;
                        //horizontalTab.onUpdatePosition(center);
                      }
                      if (previewList.center != null) {
                        //horizontalTab.center = horizontalTab.center +1;
                        previewList.center = previewList.center + 1;
                        center = previewList.center;
                        if (center >= 0 &&
                            center < widget.listIns.length - 1) {
                          if (center > 0 &&
                              center < widget.listIns.length - 1) {
                            if (circles.length > 0) {
                              circles.removeLast();
                            }
                            circles.add(
                                Preview().buildCircle('$center',widget.rootReview[center]));
                          }
                          if (center == 0 ||
                              center == widget.listIns.length - 1) {
                            if (circles.length > 0) {
                              circles.removeLast();
                            }
                          }
                          previewList.snaplistController.positionChanged(center);
                          previewList.center = previewList.center + 1;
                          previewList.onUpdatePosition(center);
                        } else {}
                      }
                      if (previewList.center == null && center != null) {
                        if (center >= 0 &&
                            center < widget.listIns.length - 1) {
                          center = center + 1;
                          if (center > 0 &&
                              center < widget.listIns.length - 1) {
                            if (circles.length > 0) {
                              circles.removeLast();
                            }
                            circles.add(
                                Preview().buildCircle('$center',widget.rootReview[center]));
                          }
                          if (center == 0 ||
                              center == widget.listIns.length - 1) {
                            if (circles.length > 0) {
                              circles.removeLast();
                            }
                          }
                          previewList.snaplistController.positionChanged(center);
                          previewList.center = center;
                          previewList.onUpdatePosition(center);
                        } else {}
                      }
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: position == 2 ? Colors.grey : Colors.black,
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                heroTag: 'next',
                highlightElevation: 0.0,
                elevation: 0.0,
                shape: RoundedRectangleBorder(),
                mini: true,
              ),
            ),
            Positioned(
              bottom: 100 + MediaQuery.of(context).size.width * 0.04,
              left: MediaQuery.of(context).size.width * 0.02,
              child: FloatingActionButton(
                onPressed: position == 0
                    ? null
                    : () async {
                    if (previewList.center == null && center == null) {
                      widget.isFromDetail == true
                          ? center = widget.indexFromDetail
                          : center = 0;
                      //horizontalTab.onUpdatePosition(center);
                    }
                    if (previewList.center != null) {
                      previewList.center = previewList.center - 1;
                      center = previewList.center;
                      if (center > 0 &&
                          center <= widget.listIns.length - 1) {
                        if (center > 0 &&
                            center < widget.listIns.length - 1) {
                          if (circles.length > 0) {
                            circles.removeLast();
                          }
                          circles.add(
                              Preview().buildCircle('$center',widget.rootReview[center]));
                        }
                        if (center == 0 ||
                            center == widget.listIns.length - 1) {
                          if (circles.length > 0) {
                            circles.removeLast();
                          }
                        }
                        previewList.snaplistController
                            .positionChanged(center);
                        previewList.center = previewList.center - 1;
                        previewList.onUpdatePosition(center);
                      } else {}
                    }
                    if (previewList.center == null && center != null) {
                      if (center > 0 &&
                          center <= widget.listIns.length - 1) {
                        center = center - 1;
                        if (center > 0 &&
                            center < widget.listIns.length - 1) {
                          if (circles.length > 0) {
                            circles.removeLast();
                          }
                          circles.add(
                              Preview().buildCircle('$center',widget.rootReview[center]));
                        }
                        if (center == 0 ||
                            center == widget.listIns.length - 1) {
                          if (circles.length > 0) {
                            circles.removeLast();
                          }
                        }
                        previewList.snaplistController
                            .positionChanged(center);
                        previewList.center = center;
                        previewList.onUpdatePosition(center);
                      } else {}
                    }
                },
                child: Icon(Icons.arrow_back_ios,
                    color: position == 0 ? Colors.grey : Colors.black),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                heroTag: 'prev',
                elevation: 0.0,
                highlightElevation: 0.0,
                shape: RoundedRectangleBorder(),
                mini: true,
              ),
            ),
          ])),
    );
  }
}

class ListPreviewCard extends StatelessWidget {
  final List<instructionRoute> listIns;
  final VoidCallback loadMore;
  final List<LatLng> latLng;
  SnaplistController snaplistController;
  final bool isOn;
  final Function (LatLng, double) mapMove;
//  final AudioPlayer audioPlayer;
  List<Image> iconRoute;
  List<Circle> circles = [];
  void Function (int position) position;
  int center = 0;
  WeMapController mapController;

  ListPreviewCard({Key key, this.listIns, this.loadMore,this.latLng, this.snaplistController,this.isOn,/*this.audioPlayer,*/ this.mapMove, this.center, this.iconRoute, this.position, this.circles, this.mapController}) : super(key: key);

  int distance(double lat1, double lon1, double lat2, double lon2){
    var p = math.pi/180;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    double temp = 12742 * asin(sqrt(a)) * 1000;
    return temp.toInt();
  }

  ///Move camera on Position of Route Preview and route by audio
  Future<void> onUpdatePosition (int i) async {
//    AudioPlayer audioPlugin = new AudioPlayer();
    String string;
    double dis;
    if(listIns[i].distance < 1000 && listIns[i].distance != 0){
      dis = listIns[i].distance;
      string = textDirection(i) + continueText + dis.toInt().toString() + meterText;
    }
    if(listIns[i].distance >= 1000){
      double dis;
      dis = ((listIns[i].distance ~/ 100))/10;
      string = textDirection(i) + continueText + dis.toString() + kilometerText;
    }
    if(listIns[i].distance == 0){
      double dis;
      dis = ((listIns[i].distance ~/ 100))/10;
      string = textDirection(i);
    }

    /*if(isOn){
      if(i < images.length -1 && i > 0){
        handleMapMove(i);
        position(1);
      }
      if(i == images.length - 1){
        mapMove(latLng[i], latLng[i], 18.0);
        position(2);
      }
      if(i==0){
        mapMove(latLng[i], latLng[i], 18.0);
        position(0);
      }
      String url = "https://wemap.vn/voice?address=$string";
      final response = await http.get(url);
      final json = JSON.json.decode(JSON.utf8.decode(response.bodyBytes));
      String str = json['audio_url'];
      print(str);
      await audioPlugin.play(str);
    }
    if(!isOn){
      if(i < images.length -1 && i > 0){
        mapMove(latLng[i - 1], latLng[i], 18.0);
        position(1);
      }
      if(i == images.length - 1){
        mapMove(latLng[i-1], latLng[i], 18.0);
        position (2);
      }
      if(i <= images.length - 1 && i == 0){
        mapMove(latLng[i + 1], latLng[i], 18.0);
        position (0);
      }
    }*/

    if(isOn){
      String str;
      if(i < listIns.length -1 && i > 0){
        await mapMove(routePreviewStream.data[i], 18.0);
        position(1);
      }
      if(i == listIns.length - 1){
        await mapMove(routePreviewStream.data[i], 18.0);
        position(2);
      }
      if(i < listIns.length - 1 && i == 0){
        await mapMove(routePreviewStream.data[i], 18.0);
        position(0);
      }
//      String url = apiVoice(string);
//      try{
//        final response = await http.get(url);
//        final json = JSON.json.decode(JSON.utf8.decode(response.bodyBytes));
//        str = json['audio_url'];
//        print(str);
//      } catch (e) {
//        print('voice api error' + '$e');
//      }
//      if(str != null){
//        await audioPlugin.play(str);
//      }
    }
    if(!isOn){
      if(i < listIns.length -1 && i > 0){
        await mapMove(routePreviewStream.data[i], 18.0);
        position(1);
      }
      if(i == listIns.length - 1){
        await mapMove(routePreviewStream.data[i], 18.0);
        position(2);
      }
      if(i < listIns.length - 1 && i == 0){
        await mapMove(routePreviewStream.data[i], 18.0);
        position(0);
      }
    }
  }

  String textDirection(int i){
    String text;
    if(listIns[i].text == 'Rẽ phải theo rẽ phải'){
      text = turnRightTo + listIns[i].road;
    } else if(listIns[i].text == 'Rẽ trái theo rẽ trái'){
      text = turnLeftTo + listIns[i].road;
    } else if(listIns[i].text == 'Rẽ phải nhẹ theo rẽ phải nhẹ'){
      text = slightRightTo + listIns[i].road;
    } else if(listIns[i].text == 'Rẽ trái nhẹ theo rẽ trái nhẹ'){
      text = slightLeftTo + listIns[i].road;
    } else if(listIns[i].text == 'Rẽ phải ngay theo rẽ phải ngay'){
      text = sharpRightTo + listIns[i].road;
    } else if(listIns[i].text == 'Rẽ trái ngay theo rẽ trái ngay'){
      text = sharpLeftTo + listIns[i].road;
    } else if(listIns[i].text == 'Make a U-turn theo make a U-turn'){
      text = makeUTurnTo + listIns[i].road;
    } else if(listIns[i].text == 'Make a U-turn'){
      text = makeUTurn;
    } else if(listIns[i].text == 'Keep right theo keep right'){
      text = turnRightOn + listIns[i].road;
    } else if(listIns[i].text == 'Keep left theo keep left'){
      text = turnLeftOn + listIns[i].road;
    } else if(listIns[i].text == 'Keep right'){
      text = goToRight;
    } else if(listIns[i].text == 'Keep left'){
      text = goToLeft;
    } else {
      text = listIns[i].text;
    }
    return text;
  }

  Image imageRoute (int index){
    Image icons;
    switch (listIns[index].sign) {
      case -98:
        icons = new Image.asset(
          'assets/icons/u_turn.png',
          width: 40,
          height: 40,
        );
        break;
      case -8:
        icons = new Image.asset(
          'assets/icons/u_turn.png',
          width: 40,
          height: 40,
        );
        break;
      case -7:
        icons = new Image.asset(
          'assets/icons/keep_left.png',
          width: 40,
          height: 40,
        );
        break;
      case -3:
        icons = new Image.asset(
          'assets/icons/sharp_left.png',
          width: 40,
          height: 40,
        );
        break;
      case -2:
        icons = new Image.asset(
          'assets/icons/left.png',
          width: 40,
          height: 40,
        );
        break;
      case -1:
        icons = new Image.asset(
          'assets/icons/slight_left.png',
          width: 40,
          height: 40,
        );
        break;
      case 0:
        icons = new Image.asset(
          'assets/icons/continue.png',
          width: 40,
          height: 40,
        );
        break;
      case 1:
        icons = new Image.asset(
          'assets/icons/slight_right.png',
          width: 40,
          height: 40,
        );
        break;
      case 2:
        icons = new Image.asset(
          'assets/icons/right.png',
          width: 40,
          height: 40,
        );
        break;
      case 3:
        icons = new Image.asset(
          'assets/icons/sharp_right.png',
          width: 40,
          height: 40,
        );
        break;
      case 4:
        icons = new Image.asset(
          'assets/icons/finish.png',
          width: 40,
          height: 40,
        );
        break;
      case 5:
        icons = new Image.asset(
          'assets/icons/via.png',
          width: 40,
          height: 40,
        );
        break;
      case 6:
        icons = new Image.asset(
          'assets/icons/roundabout.png',
          width: 40,
          height: 40,
        );
        break;
      case 7:
        icons = new Image.asset(
          'assets/icons/keep_right.png',
          width: 40,
          height: 40,
        );
        break;
      case 8:
        icons = new Image.asset(
          'assets/icons/u_turn.png',
          width: 40,
          height: 40,
        );
        break;
    }
    return icons;

  }

  @override
  Widget build(BuildContext context) {
    final Size cardSize = Size(MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.04, 460.0);
    return SnapList(
      snaplistController: snaplistController,
      padding: EdgeInsets.only(
          left: (MediaQuery.of(context).size.width - cardSize.width) / 2, right: (MediaQuery.of(context).size.width - cardSize.width) / 2 ),
      sizeProvider: (index, data) => cardSize,
      separatorProvider: (index, data) => Size(10.0, 10.0),
      positionUpdate: (int index) async {
        await mapMove(routePreviewStream.data[index], 18);
        if(index <= 0) {
          center = index;
          position(0);
        }
        if(index > 0 && index < routePreviewStream.data.length - 1) {
          center = index;
          position(1);
        }
        if(index >= routePreviewStream.data.length - 1) {
          center = index;
          position(2);
        }
      },
      builder: (context, index, data) {
        return ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child: Container(
              //padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Container(
//                              child: imageRoute(index),
                            )
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 16),
                                child: Text(textDirection(index),style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16,),),
                              ),
                              Text(listIns[index].distance < 1000 ? listIns[index].distance.toInt().toString() + ' ' + mText : (((listIns[index].distance ~/ 100))/10).toString() + ' ' + kmText,textAlign: TextAlign.start,),
                            ],
                          ),
                        ),
                      ],
                    )
                )
            )
        );
      },
      count: listIns.length,
    );
  }
}

