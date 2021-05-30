

part of wemapgl;

// ignore: must_be_immutable
class WeMapSearch extends StatefulWidget {
  WeMapSearch({
    Key key,
    @required this.location,
    this.geocoder = WeMapGeocoder.Pelias,
    this.topWiget,
    this.botWiget,
    @required this.onSelected,
    this.showYourLocation = false,
    this.yourLocationText = wemap_yourLocation,
    this.yourLocationWidget,
    this.onTapYourLocation,
    this.showChooseOnMap = false,
    this.chooseOnMapText = wemap_chooseOnMap,
    this.chooseOnMapWidget,
    this.onTapChooseOnMap,
    this.hintText = wemap_searchHere,
    this.searchValue,
  }) {
    if (topWiget == null) topWiget = <Widget>[];
    if (botWiget == null) botWiget = <Widget>[];
  }

  ///Type of geocoder: Geocoder.Pelias || Geocoder.Photon || Geocoder.Nominatim
  WeMapGeocoder geocoder;

  WeMapSearchAPI searchAPI = WeMapSearchAPI();

  ///Widget in top in page
  List<Widget> topWiget;

  ///Widget in bot in page
  List<Widget> botWiget;

  ///Need or not show my location in list of origin
  bool showYourLocation;

  ///Ex: "Vị trí của bạn"
  String yourLocationText;

  ///Icon yourlocatin
  String yourLocationWidget;

  ///Need or not show my home in list of origin
  bool showChooseOnMap;

  ///Ex: "Chọn trên bản đồ"
  String chooseOnMapText;

  ///Icon chooseOnMap
  String chooseOnMapWidget;

  ///hint text in TextField
  String hintText;

  ///The text will search when init
  String searchValue;

  /// The callback that is called when one Place is selected by the user.
  final void Function(WeMapPlace place) onSelected;

  /// The callback that is called when the user taps on my location type 2.
  final void Function() onTapYourLocation;

  /// The callback that is called when the user taps on choose on map type 2.
  final void Function() onTapChooseOnMap;

  /// The point around which you wish to retrieve place information.
  ///
  /// If this value is provided, `radius` must be provided aswell.
  final LatLng location;

  @override
  _WeMapSearchState createState() => _WeMapSearchState();
}

class _WeMapSearchState extends State<WeMapSearch> with SingleTickerProviderStateMixin {
  //Text field controller
  TextEditingController _textEditingController;

  //Scroll controller of listview
  ScrollController _scrollController;

  // Initialise outside the build method
  FocusNode searchNode = FocusNode();
  //Place when get data of API
  List _placesFromApi = [];

  //Widget search bar when show shadow
  bool _showShadow = false;

  //Clear textfield button
  bool _showClearButton = false;

  //loading status
  bool _connectivity = true;

  Timer _debounce; //Debounce time to query API

  AnimationController _controller; //Controller of animated your search box
  Animation _animation;

  @override
  void initState() {
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();

    if (widget.searchValue != null) {
      _textEditingController.text = widget.searchValue;
      _autocompletePlace(widget.searchValue);
    }

    _scrollController.addListener(() {
      if (_scrollController.offset >= 0.2 && !_showShadow) {
        setState(() => _showShadow = true);
      }
      if (_scrollController.offset < 0.2 && _showShadow) {
        setState(() => _showShadow = false);
      }
    });

    _textEditingController.addListener(() {
      if (_textEditingController.text.length == 0 && _showClearButton)
        setState(() {
          _showClearButton = false;
        });
      if (_textEditingController.text.length != 0 && !_showClearButton)
        setState(() {
          _showClearButton = true;
          _placesFromApi = [];
        });
    });

    //Controller init and config
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 70,
      ),
    );
    _animation = Tween(begin: 2.0, end: 0.0).animate(_controller);

    getDataDb();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: searchBar2(),
    );
  }

  Widget searchBar2() {
    _controller.forward();
    return Stack(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.zero,
          child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              transform: Matrix4.rotationX(_animation.value),
              margin:
                  EdgeInsets.only(top: 67 + MediaQuery.of(context).padding.top),
              child: StreamBuilder(
                  stream: streamPlace.stream,
                  builder: (context, snapdata) {
                    return ListView(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      children: !_showClearButton
                          ? _originList(snapdata.data ?? [])
                          : !_connectivity
                              ? <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      // Container(
                                      //   width: 20,
                                      //   height: 20,
                                      //   margin: EdgeInsets.all(10),
                                      //   child: CircularProgressIndicator(
                                      //     strokeWidth: 2,
                                      //   ),
                                      // )
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Icon(
                                        Icons.warning,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        wemap_notConnection,
                                        style: TextStyle(
                                          color: Colors.black38,
                                        ),
                                      )
                                    ],
                                  )
                                ]
                              : _placesFromApi.map((place) {
                                  return placeOption(
                                    place,
                                    _selectPlace,
                                    isSearching: true,
                                  );
                                }).toList(),
                    );
                  })),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: _showShadow
                ? [BoxShadow(color: Colors.black38, blurRadius: 5)]
                : null,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 47,
            decoration: containerDecorationBar2(),
            margin: EdgeInsets.only(
                top: 10 + MediaQuery.of(context).padding.top,
                left: MediaQuery.of(context).size.width * 0.025,
                right: MediaQuery.of(context).size.width * 0.025,
                bottom: 10),
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
            alignment: Alignment.center,
            child: searchInput(),
          ),
        ),
      ],
    );
  }

  Widget searchInput() {
    return Center(
      child: Row(
        children: <Widget>[
          GestureDetector(
              child: BackButtonIcon(),
              onTap: () {
                _controller.reverse();
                Navigator.pop(context);
              }),
          Expanded(
            child: TextField(
              decoration: _inputStyle(),
              controller: _textEditingController,
              autofocus: true,
              focusNode: searchNode,
              onChanged: (value) {
                if (value == '' && this.mounted)
                  setState(() {
                    _placesFromApi = [];
                  });
                else
                  _autocompletePlace(value);
              },
            ),
          ),
          Visibility(
            visible: _showClearButton,
            child: GestureDetector(
              child: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onTap: () {
                _placesFromApi = [];
                _textEditingController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _originList(List<WeMapPlace> allPlace) {
    return (<Widget>[] +
        widget.topWiget +
        [
          Visibility(
            visible: widget.showYourLocation,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
                widget.onTapYourLocation();
              },
              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: widget.yourLocationWidget ??
                      CircleAvatar(
                        child: Icon(
                          Icons.my_location,
                          size: 20,
                        ),
                        backgroundColor: Color(0xff91a5b0),
                        foregroundColor: Colors.white,
                        radius: 16,
                      ),
                ),
                title: Text(
                  widget.yourLocationText,
                ),
              ),
            ),
          ),
          Visibility(
              visible: widget.showYourLocation,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                  widget.onTapChooseOnMap();
                },
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: widget.chooseOnMapWidget ??
                        CircleAvatar(
                          child: Icon(
                            Icons.map,
                            size: 20,
                          ),
                          backgroundColor: Color(0xff91a5b0),
                          foregroundColor: Colors.white,
                          radius: 16,
                        ),
                  ),
                  title: Text(
                    widget.chooseOnMapText,
                  ),
                ),
              )),
          Visibility(
            visible: widget.showYourLocation || widget.showChooseOnMap,
            child: Container(
              height: 5,
              color: Colors.black12,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 24, top: 16, bottom: 0, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Text(wemap_searchHistory),
                    ),
                    Visibility(
                      visible: allPlace.length != 0,
                      child: Flexible(
                          flex: 1,
                          child: CupertinoButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () => deleteAllInHistory(),
                            child: Text(
                              wemap_deleteAll,
                              style: TextStyle(
                                color: Color.fromRGBO(0, 113, 188, 1),
                                fontSize: 16,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
                Visibility(
                  visible: allPlace.length == 0,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          wemap_searchRecommend,
                          textAlign: TextAlign.center,
                        ),
                        MaterialButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(searchNode);
                          },
                          child: Text(
                            wemap_searchNow,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 113, 188, 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ] +
        getHsIntoWidget(
            previousSearchesList:
                getPlaceHistory(DateQuery.PREVIOUSSEARCHES, allPlace, limit: 7),
            beforeYesterdayList:
                getPlaceHistory(DateQuery.BEFOREYESTERDAY, allPlace, limit: 7),
            yesterdayList:
                getPlaceHistory(DateQuery.YESTERDAY, allPlace, limit: 7),
            todayList: getPlaceHistory(DateQuery.TODAY, allPlace, limit: 7),
            selected: (WeMapPlace place) => _selectPlace(place)) +
        [
          Visibility(
            visible: allPlace.length > 7,
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchHistory(
                          onSelected: (place) {
                            _selectPlace(place);
                          },
                        )));
              },
              child: Center(
                child: Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      wemap_moreHistory,
                      style: TextStyle(color: Color.fromRGBO(0, 113, 188, 1)),
                      overflow: TextOverflow.ellipsis,
                    )),
              ),
            ),
          )
        ] +
        widget.botWiget);
  }

  void _selectPlace(WeMapPlace place) {
    Navigator.pop(context);
    // Calls the `onSelected` callback
    widget.onSelected(place);
    //Save db
    savePlace(place);
  }

  void getDataDb() async {
    streamPlace.increment(await getAllPlace());
  }

  void _autocompletePlace(String input) async {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    if (input.length > 0) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          _connectivity = false;
        });
      } else {
        _debounce = Timer(Duration(milliseconds: 300), () async {
          final predictions =
              await widget.searchAPI.getSearchResult(input, widget.location, widget.geocoder);
          if (this.mounted)
            setState(() {
              _connectivity = true;
              _placesFromApi = predictions ?? [];
            });
        });
      }
    }
  }

  InputDecoration _inputStyle() {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: TextStyle(
        fontSize: 16,
        color: Colors.black.withOpacity(0.35),
      ),
      border: InputBorder.none,
      contentPadding: EdgeInsets.only(
        left: 20,
        right: 16,
        bottom: 4,
      ),
    );
  }
}

BoxDecoration containerDecorationBar1() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    boxShadow: [
      BoxShadow(
        color: Colors.black38,
        offset: Offset(0, 1),
        blurRadius: 0.9,
      ),
    ],
  );
}

BoxDecoration containerDecorationBar2() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    border: Border.all(
      color: Colors.black.withOpacity(0.1),
      style: BorderStyle.solid,
      width: 0.8,
    ),
  );
}

class MaterialPageRouteWithoutAnimation<T> extends MaterialPageRoute<T> {
  MaterialPageRouteWithoutAnimation({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
