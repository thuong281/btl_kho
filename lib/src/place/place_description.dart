part of wemapgl;

class WeMapPlaceDesc extends StatefulWidget {
  final WeMapPlace place;

  /// List buttons after direction button
  List<Widget> buttons;
  String destinationIcon;
  WeMapPlaceDesc({@required this.place, this.buttons, this.destinationIcon}) {
    if (this.buttons == null) this.buttons = [];
  }

  @override
  State<StatefulWidget> createState() => _WeMapPlaceDescState();
}

class _WeMapPlaceDescState extends State<WeMapPlaceDesc> {
  List tagsName = [];
  Location _des = Location(
    name: "hihi2",
    latitude: 21.033811834334458,
    longitude: 105.7840838429172,
  );
  Location _ori = Location(
    name: "hihi",
    latitude: 21.033811834334458,
    longitude: 105.7840838429172,
  );
  WeMapNavigation _directions;
  bool _arrived = false;
  double _distanceRemaining, _durationRemaining;

  @override
  void initState() {
    if (widget.place.extraTags != null) {
      tagsName = widget.place.extraTags.keys.toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _directions = WeMapNavigation(onRouteProgress: (arrived) async {
      _distanceRemaining = await _directions.distanceRemaining;
      _durationRemaining = await _directions.durationRemaining;

      setState(() {
        _arrived = arrived;
      });
      if (arrived) {
        await Future.delayed(Duration(seconds: 3));
        await _directions.finishNavigation();
      }
    });

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          upperFirstLetter(widget.place.placeName),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                          CustomButton(
                            icon: Icons.directions,
                            buttonName: directionBtn.toUpperCase(),
                            context: context,
                            onPressed: () {
                              WeMapPlace origin;
                              WeMapPlace destination;
                              print(widget.place.location);
                              if (widget.place != null) {
                                weRequestLocation();
                                final location = GPSService.Location();
                                location.getLocation().then((locationData) {
                                  _ori = Location(
                                    name: "hihi",
                                    latitude: locationData.latitude,
                                    longitude: locationData.longitude,
                                  );
                                  _des = Location(
                                    name: widget.place.placeName,
                                    latitude: widget.place.location.latitude,
                                    longitude: widget.place.location.longitude,
                                  );
                                  origin = new WeMapPlace(
                                    location:
                                        LatLng(_ori.latitude, _ori.longitude),
                                    description: wemap_yourLocation,
                                  );
                                  destination = new WeMapPlace(
                                    location:
                                        LatLng(_des.latitude, _des.longitude),
                                    description: widget.place.placeName,
                                  );
                                  print(destination.description);
                                  originPlaceStream.increment(origin);
                                  destinationPlaceStream.increment(destination);
                                  fromHomeStream.increment(true);
                                  isDrivingStream.increment(true);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => WeMapDirection(
                                        destinationIcon: widget.destinationIcon,
                                        originPlace: origin,
                                        destinationPlace: destination,
                                      ),
                                    ),
                                  );
                                });
                              }

                              /// write your action for Direction button here
                            },
                          ),
                          CustomButton(
                            icon: Icons.navigation,
                            buttonName: start.toUpperCase(),
                            context: context,
                            onPressed: () {
                              if (widget.place != null) {
                                weRequestLocation();
                                final location = GPSService.Location();
                                location.getLocation().then((locationData) {
                                  _ori = Location(
                                    name: "hihi",
                                    latitude: locationData.latitude,
                                    longitude: locationData.longitude,
                                  );
                                  _des = Location(
                                    name: widget.place.placeName,
                                    latitude: widget.place.location.latitude,
                                    longitude: widget.place.location.longitude,
                                  );
                                  _directions.startNavigation(
                                    destination: _des,
                                    origin: _ori,
                                    mode: WeMapNavigationMode.drivingWithTraffic,
                                    simulateRoute: false,
                                  );
                                });
                              }
                            },
                          )
                        ] +
                        widget.buttons,
                  ),
                ),
                ListTile(
                  title: Text(
                    upperFirstLetter(widget.place.placeName),
                  ),
                  leading: Icon(
                    Icons.home,
                    color: primaryColor,
                  ),
                  selected: false,
                  onTap: () {
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(widget.place.street != null
                      ? upperFirstLetter(
                          widget.place.street + ", " + widget.place.cityState)
                      : upperFirstLetter(widget.place.cityState)),
                  leading: Icon(
                    Icons.location_on,
                    color: primaryColor,
                  ),
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                // Container(
                //   height: 0.5,
                //   color: Colors.grey,
                // ),
                ListTile(
                  title: Text(
                      "${widget.place.location.latitude.toStringAsFixed(5)}, ${widget.place.location.longitude.toStringAsFixed(5)}"),
                  leading: Icon(
                    Icons.my_location,
                    color: primaryColor,
                  ),
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                // Container(
                //   height: 0.5,
                //   color: Colors.grey,
                // ),
              ] +
              tagsName.map((key) {
                switch (key) {
                  case "phone":
                    {
                      String _phone = "";
                      if (widget.place.extraTags != null) {
                        _phone = widget.place.extraTags[key].toString();
                      }
                      return CustomListTile(
                        form: "phone",
                        value: _phone,
                      );
                    }
                    break;
                  case "website":
                    {
                      String _web = "";
                      if (widget.place.extraTags != null) {
                        _web = widget.place.extraTags[key].toString();
                      }
                      return CustomListTile(
                        form: "web",
                        value: _web,
                      );
                    }
                    break;
                  case "fax":
                    {
                      String _fax = "";
                      if (widget.place.extraTags != null) {
                        _fax = widget.place.extraTags[key].toString();
                      }
                      return CustomListTile(
                        icon: Icons.print,
                        title: "Số fax",
                        value: _fax,
                      );
                    }
                    break;
                  case "opening_hours":
                    {
                      String _time = "";
                      if (widget.place.extraTags != null) {
                        _time = widget.place.extraTags[key].toString();
                      }
                      return CustomListTile(
                        icon: Icons.access_time,
                        title: openingHours,
                        value: _time,
                      );
                    }
                    break;
                  case "service_times":
                    {
                      String _time = "";
                      if (widget.place.extraTags != null) {
                        _time = widget.place.extraTags[key].toString();
                      }
                      return CustomListTile(
                        icon: Icons.access_time,
                        title: openingHours,
                        value: _time,
                      );
                    }
                    break;
                  case "level":
                    {
                      String _level = "";
                      if (widget.place.extraTags != null) {
                        _level = widget.place.extraTags[key].toString();
                      }
                      return CustomListTile(
                        icon: Icons.add,
                        title: levelText,
                        value: _level,
                      );
                    }
                    break;
                  case "smoking":
                    {
                      String _smoke = "";
                      if (widget.place.extraTags != null) {
                        if (widget.place.extraTags[key].toString() == "yes") {
                          _smoke = "Có";
                        } else if (widget.place.extraTags[key].toString() ==
                            "outside") {
                          _smoke = "Bên ngoài";
                        } else
                          _smoke = "Không";
                      }
                      return CustomListTile(
                        icon: Icons.smoking_rooms,
                        title: smokingText,
                        value: _smoke,
                      );
                    }
                    break;
                  case "internet_access":
                    {
                      String _internet = "";
                      if (widget.place.extraTags != null) {
                        if (widget.place.extraTags[key].toString() == "yes") {
                          _internet = "Có";
                        } else
                          _internet = "Không";
                      }
                      return CustomListTile(
                        icon: Icons.wifi,
                        title: internetText,
                        value: _internet,
                      );
                    }
                    break;
                  case "stars":
                    {
                      String _star = "";
                      if (widget.place.extraTags != null) {
                        _star = widget.place.extraTags[key].toString();
                      }
                      return CustomListTile(
                        icon: Icons.star,
                        title: starsText,
                        value: _star,
                      );
                    }
                    break;
                  case "lanes":
                    {
                      String _lanes = "";
                      if (widget.place.extraTags != null) {
                        _lanes = widget.place.extraTags[key].toString();
                      }
                      return CustomListTile(
                        icon: Icons.label_important,
                        title: lanesText,
                        value: _lanes,
                      );
                    }
                    break;
                  case "oneway":
                    {
                      String _oneway = "";
                      if (widget.place.extraTags != null) {
                        _oneway = widget.place.extraTags[key].toString();
                      }
                      return CustomListTile(
                        icon: Icons.label_important,
                        title: _oneway == "yes" ? oneWayText : twoWaysText,
                        value: "yes",
                      );
                    }
                    break;
                  case "maxspeed":
                    {
                      String _maxspeed = "";
                      if (widget.place.extraTags != null) {
                        _maxspeed = widget.place.extraTags[key].toString();
                      }
                      return CustomListTile(
                        icon: Icons.local_shipping,
                        title: maxSpeed,
                        value: _maxspeed,
                      );
                    }
                    break;
                  default:
                    return Container();
                    break;
                }
              }).toList() +
              [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 12.0,
                  ),
                  child: OutlineButton(
                    onPressed: () {
                      Fluttertoast.showToast(msg: developing);
                    },
                    child: Text(
                      describeExpInfo,
                      style: TextStyle(color: Color.fromRGBO(0, 113, 188, 1)),
                    ),
                    highlightedBorderColor: primaryColor,
                    shape: StadiumBorder(),
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
        ),
      ),
    );
  }
}

class CustomButton extends Container {
  BuildContext context;
  final VoidCallback onPressed;
  IconData icon;
  String buttonName;
  double width;

  CustomButton(
      {@required this.onPressed, this.buttonName, this.icon, this.context})
      : super(
          width: MediaQuery.of(context).size.width / 4,
          child: Center(
            child: Column(
              children: <Widget>[
                OutlineButton(
                  child: Icon(
                    icon,
                    color: primaryColor,
                  ),
                  onPressed: onPressed,
                  shape: CircleBorder(),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                Text(
                  buttonName,
                  style: TextStyle(color: primaryColor, fontSize: 12),
                )
              ],
            ),
          ),
        );
}

class CustomListTile extends StatefulWidget {
  String value;
  String form;
  String title;
  IconData icon;

  CustomListTile({this.value, this.form, this.title, this.icon});
  @override
  State<StatefulWidget> createState() {
    return _CustomListTileState();
  }
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    switch (widget.form) {
      case "phone":
        return phoneListTile(value: widget.value);
        break;
      case "web":
        return webListTile(value: widget.value);
        break;
      default:
        return defaultListTile(
            icon: widget.icon, value: widget.value, title: widget.title);
        break;
    }
  }

  Widget defaultListTile({IconData icon, String value, String title}) {
    return ListTile(
      isThreeLine: false,
      leading: Icon(
        icon,
        color: primaryColor,
      ),
      selected: false,
      title: Text(
        title + ": " + value,
      ),
    );
  }

  Widget phoneListTile({String value}) {
    return ListTile(
      isThreeLine: false,
      leading: Icon(
        Icons.phone,
        color: primaryColor,
      ),
      selected: false,
      title: Text(
        value,
      ),
      onTap: () {
        launch("tel:$value");
      },
    );
  }

  Widget webListTile({String value}) {
    return ListTile(
      isThreeLine: false,
      leading: Icon(
        Icons.public,
        color: primaryColor,
      ),
      selected: false,
      title: Text(
        value,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
      onTap: () {
        launch("$value");
      },
    );
  }
}
