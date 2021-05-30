

part of wemapgl;

// ignore: must_be_immutable
class WeMapSearchBar extends StatefulWidget {
  WeMapSearchBar({
    Key key,
    @required this.location,
    this.geocoder = WeMapGeocoder.Pelias,
    @required this.onSelected,
    @required this.onClearInput,
    this.showYourLocation = false,
    this.yourLocationText = wemap_yourLocation,
    this.yourLocationWidget,
    this.onTapYourLocation,
    this.showChooseOnMap = false,
    this.chooseOnMapText = wemap_chooseOnMap,
    this.chooseOnMapWidget,
    this.onTapChooseOnMap,
    this.hintText = wemap_searchHere,
    this.prefix,
    this.suffix,
    this.changeBackground = false,
    this.showShadow = false,
    this.isLoading = false,
    this.searchValue,
  }) {
    if (prefix == null) prefix = <Widget>[];
    if (suffix == null) suffix = <Widget>[];
  }

  ///Type of geocoder: Geocoder.Pelias || Geocoder.Photon || Geocoder.Nominatim
  WeMapGeocoder geocoder;

  ///Set widget and function for prefix
  List<Widget> prefix;

  ///Set widget and function for suffix
  List<Widget> suffix;

  ///Value = true if your want background = white, else background = transparent
  bool changeBackground;

  ///Value = true if your want have boxshadow
  bool showShadow;

  ///Show CircularProgressIndicator in suffix
  bool isLoading;

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
  ///Please setState searchValue when onSelected if set value for it
  String searchValue;

  /// The callback that is called when one Place is selected by the user.
  final void Function(WeMapPlace place) onSelected;

  /// The callback that is called when delete this name.
  final void Function() onClearInput;

  /// The callback that is called when the user taps on my location type 2.
  final void Function() onTapYourLocation;

  /// The callback that is called when the user taps on choose on map type 2.
  final void Function() onTapChooseOnMap;

  /// The point around which you wish to retrieve place information.
  ///
  /// If this value is provided, `radius` must be provided aswell.
  final LatLng location;
  @override
  _WeMapSearchBarState createState() => _WeMapSearchBarState();
}

class _WeMapSearchBarState extends State<WeMapSearchBar> {
  String searchValue;
  @override
  Widget build(BuildContext context) {
    if (widget.searchValue != null) {
      searchValue = widget.searchValue;
    }
    return Container(
      decoration: BoxDecoration(
        color: widget.changeBackground ? Colors.white : Colors.transparent,
        boxShadow: widget.showShadow
            ? [BoxShadow(color: Colors.black38, blurRadius: 5)]
            : null,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 47,
        decoration: widget.changeBackground
            ? containerDecorationBar2()
            : containerDecorationBar1(),
        margin: EdgeInsets.only(
            top: 10 + MediaQuery.of(context).padding.top,
            left: MediaQuery.of(context).size.width * 0.025,
            right: MediaQuery.of(context).size.width * 0.025,
            bottom: 10),
        padding: EdgeInsets.only(left: 16, right: 16),
        alignment: Alignment.center,
        child: searchInfo(),
      ),
    );
  }

  Widget searchInfo() {
    return Center(
      child: Row(
        children: <Widget>[] +
            widget.prefix +
            [
              Expanded(
                  child: GestureDetector(
                child: Padding(
                    padding: EdgeInsets.only(
                      left: 21,
                      right: 16,
                    ),
                    child: Text(
                      searchValue ?? widget.hintText,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            searchValue == null ? Colors.black54 : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )),
                onTap: () {
                  if (this.mounted)
                    Navigator.push(
                      context,
                      MaterialPageRouteWithoutAnimation(
                        builder: (context) => WeMapSearch(
                          location: widget.location,
                          geocoder: widget.geocoder,
                          onSelected: (place) {
                            if (widget.searchValue == null) {
                              setState(() {
                                searchValue = place.placeName;
                              });
                            }
                            widget.onSelected(place);
                          },
                          showYourLocation: widget.showYourLocation,
                          yourLocationText: widget.yourLocationText,
                          yourLocationWidget: widget.yourLocationWidget,
                          onTapYourLocation: () => widget.onTapYourLocation(),
                          showChooseOnMap: widget.showChooseOnMap,
                          chooseOnMapText: widget.chooseOnMapText,
                          chooseOnMapWidget: widget.chooseOnMapWidget,
                          onTapChooseOnMap: () => widget.onTapChooseOnMap(),
                          hintText: widget.hintText,
                          searchValue: searchValue,
                        ),
                      ),
                    );
                },
              )),
              Visibility(
                visible: widget.isLoading,
                child: Container(
                    height: 23,
                    width: 23,
                    margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                    )),
              ),
              Visibility(
                visible: searchValue != null,
                child: GestureDetector(
                  child: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                  onTap: () {
                    setState(() {
                      searchValue = null;
                      widget.onClearInput();
                    });
                  },
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(right: 16),
              // ),
              // GestureDetector(
              //   child: Icon(Icons.keyboard_voice, color: Colors.black87),
              //   onTap: () {
              //     setState(() {
              //       widget.widgetType = 2;
              //       widget.onOpen();
              //     });
              //   },
              // )
            ] +
            widget.suffix,
      ),
    );
  }
}
