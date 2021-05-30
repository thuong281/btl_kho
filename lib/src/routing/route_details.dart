part of wemapgl;

class RouteItem {
  String from;
  String to;
  double fromPointLatitude;
  double fromPointLongitude;
  double toPointLatitude;
  double toPointLongitude;
  int indexOfTab;
  bool done;

  RouteItem({this.from, this.to, this.fromPointLatitude, this.fromPointLongitude, this.toPointLatitude, this.toPointLongitude, this.indexOfTab, this.done});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['from'] = from;
    m['to'] = to;
    m['fromPointLatitude'] = fromPointLatitude;
    m['fromPointLongitude'] = fromPointLongitude;
    m['toPointLatitude'] = toPointLatitude;
    m['toPointLongitude'] = toPointLongitude;
    m['index'] = indexOfTab;
    m['done'] = done;

    return m;
  }
}

class RouteList {
  List<RouteItem> items;

  RouteList() {
    items = new List();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

class WeMapDirectionDetails extends StatefulWidget {
  WeMapPlace originPlace;
  WeMapPlace destinationPlace;
  LatLng from;
  LatLng to;
  bool changeBackground;
  double upper;
  double lower;
  double half;
  bool visible;
  int tripDistance;
  List<LatLng> route = [];
  List<LatLng> rootPreview = [];
  List<instructionRoute> insRoute = [];
  bool isFromDetail;
  int indexOfTab;
  LatLng your;
  int time;
  bool isDriving;
  List<int> fromDriving;
  final Function(int) timeConvert;
  int link;

  final Function(double position) onSlided;

  WeMapDirectionDetails(
      {this.changeBackground,
        this.upper,
        this.lower,
        this.half,
        this.onSlided,
        this.insRoute,
        this.tripDistance,
        this.rootPreview,
        this.route,
        this.timeConvert,
        this.visible,
        this.isFromDetail,
        this.indexOfTab,
        this.your,
        this.time,
        this.isDriving,
        this.fromDriving,
        this.from,
        this.to,
        this.link,
        this.originPlace,
        this.destinationPlace
      });

  @override
  WeMapDirectionDetailsState createState() => WeMapDirectionDetailsState();
}

class WeMapDirectionDetailsState extends State<WeMapDirectionDetails> with TickerProviderStateMixin {
  RubberAnimationController _controller;

  ScrollController _scrollController = ScrollController();

  GlobalKey _globalKey = GlobalKey();

  int counter = 0;
  List<Image> iconRoute = [];

  double appbarHeight;
  int time = 0;

  List<Uint8List> images = [];

  final RouteList list = new RouteList();
  bool initialized = false;

  @override
  void initState() {
    _controller = RubberAnimationController(
        vsync: this,
        upperBoundValue: AnimationControllerValue(pixel: widget.upper),
        lowerBoundValue: AnimationControllerValue(pixel: widget.lower),
        springDescription: SpringDescription.withDampingRatio(
            mass: 1, stiffness: Stiffness.HIGH, ratio: DampingRatio.NO_BOUNCY),
        duration: Duration(milliseconds: 0))
      ..addListener(() {
        if (widget.onSlided != null) widget.onSlided(_controller.value);
      });

    images.add(base64.decode(wemap_details_u_turn));
    images.add(base64.decode(wemap_details_u_turn_left));
    images.add(base64.decode(wemap_details_u_turn_right));
    images.add(base64.decode(wemap_details_continue));
    images.add(base64.decode(wemap_details_via));
    images.add(base64.decode(wemap_details_finish));
    images.add(base64.decode(wemap_details_keep_left));
    images.add(base64.decode(wemap_details_keep_right));
    images.add(base64.decode(wemap_details_left));
    images.add(base64.decode(wemap_details_right));
    images.add(base64.decode(wemap_details_roundabout));
    images.add(base64.decode(wemap_details_sharp_left));
    images.add(base64.decode(wemap_details_sharp_right));
    images.add(base64.decode(wemap_details_slight_left));
    images.add(base64.decode(wemap_details_slight_right));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appbarHeight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    return Stack(
      children: <Widget>[
        RubberBottomSheet(
          key: _globalKey,
          scrollController: _scrollController,
          lowerLayer: _getLowerLayer(),
          upperLayer: _getUpperLayer(),
          animationController: _controller,
        ),
        Positioned(
          child: AnimatedOpacity(
            opacity: (_controller.value * MediaQuery.of(context).size.height >
                MediaQuery.of(context).size.height - (75 + MediaQuery.of(context).padding.top))
                ? 1.0
                : 0.0,
            duration: Duration(milliseconds: 300),
            child: Visibility(
              visible: (_controller.value * MediaQuery.of(context).size.height >
                  MediaQuery.of(context).size.height - (75 + MediaQuery.of(context).padding.top)),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 5)],
                  ),
                  width: double.infinity,
                  height: 75 + MediaQuery.of(context).padding.top,
                  padding: EdgeInsets.only(top: 16 + MediaQuery.of(context).padding.top, left: 16, right: 16, bottom: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Icon(Icons.directions, color: Color.fromRGBO(0, 113, 188, 1),),
                          margin: EdgeInsets.only(right: 16.0),
                          padding: EdgeInsets.only(right: 16.0),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    (distanceStream.data < 1000
                                        ? distanceStream.data.toString() + ' ' + mText
                                        : (((distanceStream.data ~/ 100)) / 10)
                                        .toString() +
                                        ' ' + kmText) +
                                        ' ',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .title),
                                Text('(' +
                                    widget.timeConvert(timeStream.data) +
                                    ')',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .body1)
                              ]),
                        ),
                      ),
                      // Expanded(
                      //   flex: 7,
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 0, left: 0, right: 5, bottom: 0),
                      //     height: 40,
                      //     child: Container(
                      //       decoration: _containerDecoration(),
                      //       child: _buttonShare(),
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          padding: EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 0),
                          height: 40,
                          child: Container(
                            child: isDrivingStream.data == true ? _buttonNavigation() : _buttonPreview(),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _getLowerLayer() {
    return Visibility(
      visible: false,
      child: Container(color: Colors.transparent),
    );
  }

  Widget _getUpperLayer() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: widget.changeBackground
                ? null
                : [
              BoxShadow(
                blurRadius: 8.0,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              )
            ],
            borderRadius: widget.changeBackground
                ? null
                : BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0))),
        child: _panel());
  }

  Widget _panel() {
    return StreamBuilder(
      initialData: false,
      stream: visibleStream.stream,
      builder: (context, snapdata){
        return Visibility(
          visible: snapdata.data,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            controller: _scrollController,
            children: <Widget>[
              AnimatedCrossFade(
                firstChild: Container(
                    width: double.infinity,
                    height: 75,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Icon(Icons.directions, color: Color.fromRGBO(0, 113, 188, 1),
                            ),
                            margin: EdgeInsets.only(right: 16.0),
                            padding: EdgeInsets.only(right: 16.0),
                          ),

                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            padding: EdgeInsets.only(left: 4),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      (distanceStream.data < 1000
                                          ? distanceStream.data.toString() + ' ' + mText
                                          : (((distanceStream.data ~/ 100)) / 10)
                                          .toString() +
                                          ' ' + kmText) +
                                          ' ',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .title),
                                  Text('(' +
                                      widget.timeConvert(timeStream.data) +
                                      ')',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .body1)
                                ]),
                          ),
                        ),
                        // Expanded(
                        //   flex: 7,
                        //   child: Container(
                        //     padding: EdgeInsets.only(top: 0, left: 0, right: 5, bottom: 0),
                        //     height: 40,
                        //     child: Container(
                        //       decoration: _containerDecoration(),
                        //       child: _buttonShare(),
                        //     ),
                        //     //padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                        //   ),
                        // ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            padding: EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 0),
                            height: 40,
                            child: Container(
                              //decoration: _containerDecoration(),
                              child: isDrivingStream.data == true ? _buttonNavigation() : _buttonPreview(),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                secondChild: Container(
                  height: 75,
                ),
                duration: Duration(milliseconds: 300),
                crossFadeState:
                !(_controller.value * MediaQuery.of(context).size.height >
                    MediaQuery.of(context).size.height - (75 + MediaQuery.of(context).padding.top))
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
              Column(
                  children: insRouteStream.data.map((ins) {
                    List<Widget> children = [];
                    int dis = ins.distance.toInt();
                    Image icons;
                    int index = insRouteStream.data.indexOf(ins);
                    String text;
//                if(ins.text == 'Rẽ phải theo rẽ phải'){
//                  text = turnRightTo + ins.road;
//                } else if(ins.text == 'Rẽ trái theo rẽ trái'){
//                  text = turnLeftTo + ins.road;
//                } else if(ins.text == 'Rẽ phải nhẹ theo rẽ phải nhẹ'){
//                  text = slightRightTo + ins.road;
//                } else if(ins.text == 'Rẽ trái nhẹ theo rẽ trái nhẹ'){
//                  text = slightLeftTo + ins.road;
//                } else if(ins.text == 'Rẽ phải ngay theo rẽ phải ngay'){
//                  text = sharpRightTo + ins.road;
//                } else if(ins.text == 'Rẽ trái ngay theo rẽ trái ngay'){
//                  text = sharpLeftTo + ins.road;
//                } else if(ins.text == 'Make a U-turn theo make a U-turn'){
//                  text = makeUTurnTo + ins.road;
//                } else if(ins.text == 'Make a U-turn'){
//                  text = makeUTurn;
//                } else if(ins.text == 'Keep right theo keep right'){
//                  text = turnRightOn + ins.road;
//                } else if(ins.text == 'Keep left theo keep left'){
//                  text = turnLeftOn + ins.road;
//                } else if(ins.text == 'Keep right'){
//                  text = goToRight;
//                } else if(ins.text == 'Keep left'){
//                  text = goToLeft;
//                } else {
                    text = ins.text;
                    switch (ins.sign) {
                      case -98:
                        icons = new Image.memory(
                          images[0],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case -8:
                        icons = new Image.memory(
                          images[0],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case -7:
                        icons = new Image.memory(
                          images[6],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case -3:
                        icons = new Image.memory(
                          images[11],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case -2:
                        icons = new Image.memory(
                          images[8],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case -1:
                        icons = new Image.memory(
                          images[13],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case 0:
                        icons = new Image.memory(
                          images[3],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case 1:
                        icons = new Image.memory(
                          images[14],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case 2:
                        icons = new Image.memory(
                          images[9],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case 3:
                        icons = new Image.memory(
                          images[12],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case 4:
                        icons = new Image.memory(
                          images[5],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case 5:
                        icons = new Image.memory(
                          images[4],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case 6:
                        icons = new Image.memory(
                          images[10],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case 7:
                        icons = new Image.memory(
                          images[7],
                          width: 25,
                          height: 25,
                        );
                        break;
                      case 8:
                        icons = new Image.memory(
                          images[2],
                          width: 25,
                          height: 25,
                        );
                        break;
                    }
                    iconRoute.add(icons);
                    children.add(ListTile(
                      leading: icons,
                      title: Text(text),
                      subtitle: Text(
                        dis < 1000
                            ? dis.toString() + ' ' + mText
                            : ((dis ~/ 100) / 10).toString() + ' ' + kmText,
                      ),
                      onTap: () {
//                    setState(() {
//                      widget.isFromDetail = true;
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (context) => RootReview(urls: widget.insRoute, route: widget.route, rootReview: widget.rootPreview, isFromDetail: widget.isFromDetail, indexFromDetail: index, iconRoute: iconRoute,)));
//                    });
                      },
                    )
                    );
                    if(insRouteStream.data.length != null){
                      if (counter < insRouteStream.data.length) {
                        children.add(Container(color: Colors.black38, height: 0.5));
                      }
                    }
                    return Column(children: children);
                  }).toList()),
            ],
          ),
        );
      },
    );
  }

  Widget _buttonPreview() {
    return RaisedButton(
        child:
        Text(preview, style: TextStyle(fontSize: 14)),
        textColor: Colors.white,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(16.0)),
        color: Color.fromRGBO(0, 113, 188, 1),
        splashColor: Colors.grey,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  WeMapDirectionPreview(
                    originPlace: widget.originPlace,
                    destinationPlace: widget.destinationPlace,
                    listIns: insRouteStream.data,
                    route: routeStream.data,
                    rootReview: routePreviewStream.data,
                    indexOfTab: indexStream.data,
                  )));
        });
  }

  Widget _buttonNavigation () {
    return RaisedButton(
        child:
        Text(start, style: TextStyle(fontSize: 14)),
        textColor: Colors.white,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(16.0)),
        color: Color.fromRGBO(0, 113, 188, 1),
        splashColor: Colors.grey,
        onPressed: () async {
          await WeMapNavigation().startNavigation(
            origin: Location(name: originPlaceStream.data.description, latitude: originPlaceStream.data.location.latitude, longitude: originPlaceStream.data.location.longitude),
            destination: Location(name: destinationPlaceStream.data.description, latitude: destinationPlaceStream.data.location.latitude, longitude: destinationPlaceStream.data.location.longitude),
            mode: WeMapNavigationMode.drivingWithTraffic,
            simulateRoute: false, language: "vi",);
        });
  }

  Widget _buttonShare (){
    return RaisedButton(
      child:
      Text(shareBtn, style: TextStyle(fontSize: 14)),
      textColor: Color.fromRGBO(0, 113, 188, 1),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(16.0)),
      color: Colors.white,
      splashColor: Colors.grey,
      onPressed: (){}
      );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color.fromRGBO(0, 113, 188, 1)),
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
      //],
    );
  }
}

