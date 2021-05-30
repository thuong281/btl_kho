part of wemapgl;

class ChooseLocation extends StatefulWidget {
  final void Function() onSelected;
  void Function(bool from) isFrom;
  void Function(int isActivity) isActivity;
  final bool isController;
  final bool isHome;
  WeMapPlace placeOnHome;
  List<int> fromDriving;
  LatLng searchLocation;
  WeMapPlace originPlace;
  WeMapPlace destinationPlace;
  String originIcon;
  String destinationIcon;
  ChooseLocation(
      {this.onSelected,
      Key key,
      this.isFrom,
      this.isController,
      this.isHome,
      this.placeOnHome,
      this.fromDriving,
      this.isActivity,
      this.searchLocation,
      this.originPlace,
      this.destinationPlace,
      this.originIcon,
      this.destinationIcon})
      : super(
          key: key,
        );

  @override
  ChooseLocationState createState() => ChooseLocationState();
}

class ChooseLocationState extends State<ChooseLocation>
    with SingleTickerProviderStateMixin {
  WeMapPlace fromAddress;
  WeMapPlace toAddress;

  int isActivity = 1;

  String location1 = originHint;
  String location2 = destinationHint;
  LatLng ori;
  LatLng des;

  void updateTextTo(String text) {
    setState(() {
      location2 = text;
    });
  }

  void updateTextFrom(String text) {
    setState(() {
      location1 = text;
    });
  }

  String searchTextFrom() {
    if (fromHomeStream.data == true) {
      setState(() {
        fromAddress = widget.originPlace;
        location1 = fromAddress == null ? location1 : fromAddress.description;
        ori = fromAddress == null ? ori : fromAddress.location;
        fromAddress = null;
      });
    } else {
      setState(() {
        location1 = fromAddress == null ? location1 : fromAddress.description;
        ori = fromAddress == null ? ori : fromAddress.location;
        fromAddress = null;
      });
    }
    widget.onSelected();
    return location1;
  }

  String searchTextTo() {
    if (fromHomeStream.data == true) {
      setState(() {
        toAddress = widget.destinationPlace;
        location2 = toAddress == null ? location2 : toAddress.description;
        des = toAddress == null ? des : toAddress.location;
        toAddress = null;
      });
    } else {
      setState(() {
        location2 = toAddress == null ? location2 : toAddress.description;
        des = toAddress == null ? des : toAddress.location;
        toAddress = null;
      });
    }
    widget.onSelected();
    return location2;
  }

  void locationSwap(WeMapPlace origin, WeMapPlace destination) {
    String temp = '';
    LatLng latLng;
    WeMapPlace place;
    temp = location1;
    latLng = ori;
    place = origin;
    setState(() {
      location1 = location2;
      ori = des;
      origin = destination;
    });
    setState(() {
      location2 = temp;
      des = latLng;
      destination = place;
    });
  }

  void originChooseMap(WeMapPlace place) {
    fromAddress = place;
  }

  void destinationChooseMap(WeMapPlace place) {
    toAddress = place;
  }

  @override
  void initState() {
    super.initState();
    location1 = originHint;
    location2 = destinationHint;
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color(0xFFBDBDBD)),
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10, top: 10),
            child: Container(
              width: double.infinity,
              height: 45,
              decoration: _containerDecoration(),
              padding: EdgeInsets.only(bottom: 0),
              child: FlatButton(
                onPressed: () async {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRouteWithoutAnimation(
                          builder: (context) => WeMapSearch(
                            location: widget.searchLocation != null
                                ? widget.searchLocation
                                : LatLng(21.03, 105.787),
                            showYourLocation: true,
                            showChooseOnMap: true,
                            hintText: originHintText,
                            onSelected: (place) {
                              setState(() {
                                fromAddress = place;
                              });
                            },
                            onTapYourLocation: () {
                              fromAddress = new WeMapPlace(
                                  location: widget.searchLocation,
                                  description: wemap_yourLocation);
                              isDrivingStream.increment(true);
                            },
                            onTapChooseOnMap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChooseOnMap(
                                        searchLocation:
                                            widget.searchLocation != null
                                                ? widget.searchLocation
                                                : LatLng(21.03, 105.787),
                                        iconImage: widget.destinationIcon,
                                        onChooseMap: originChooseMap,
                                      )));
                            },
                          ),
                        ));
                    if (widget != null) {
                      widget.isFrom(true);
                      if (widget.fromDriving[0] == 1) {
                        isActivity = 0;
                        widget.isActivity(0);
                      }
                      widget.fromDriving.clear();
                      widget.fromDriving.add(0);
                    }
                  });
                },
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                        height: 50,
                        child: Center(
                          child: Icon(
                            Icons.place,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 40,
                          right: 50,
                        ),
                        child: Text(
                          searchTextFrom(),
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff323643)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 0),
            height: 45,
            decoration: _containerDecoration(),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRouteWithoutAnimation(
                        builder: (context) => WeMapSearch(
                          location: widget.searchLocation != null
                              ? widget.searchLocation
                              : LatLng(21.03, 105.787),
                          showYourLocation: true,
                          showChooseOnMap: true,
                          hintText: destinationHintText,
                          onSelected: (place) {
                            setState(() {
                              toAddress = place;
                            });
                          },
                          onTapYourLocation: () {
                            toAddress = new WeMapPlace(
                                location: widget.searchLocation,
                                description: wemap_yourLocation);
                            isDrivingStream.increment(true);
                          },
                          onTapChooseOnMap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChooseOnMap(
                                      searchLocation:
                                          widget.searchLocation != null
                                              ? widget.searchLocation
                                              : LatLng(21.03, 105.787),
                                      iconImage: widget.destinationIcon,
                                      onChooseMap: destinationChooseMap,
                                    )));
                          },
                        ),
                      ));
                  if (widget != null) {
                    if (widget.fromDriving[0] == 1) {
                      isActivity = 0;
                      widget.isActivity(0);
                    }
                    widget.fromDriving.clear();
                    widget.fromDriving.add(0);
                    widget.isFrom(false);
                  }
                });
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                      height: 50,
                      child: Center(
                        child: Icon(
                          Icons.near_me,
                          color: Color.fromRGBO(0, 113, 188, 1),
                          size: 20,
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 40, right: 50),
                        child: Text(
                          searchTextTo(),
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff323643)),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
