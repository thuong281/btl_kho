part of wemapgl;

/// Turn-By-Turn Navigation Provider
class WeMapNavigation {
  factory WeMapNavigation({ValueSetter<bool> onRouteProgress}) {
    if (_instance == null) {
      final MethodChannel methodChannel =
          const MethodChannel('wemapgl');
      final EventChannel eventChannel =
          const EventChannel('wemapgl/arrival');
      _instance = WeMapNavigation.private(
          methodChannel, eventChannel, onRouteProgress);
    }
    return _instance;
  }

  @visibleForTesting
  WeMapNavigation.private(this._methodChannel, this._routeProgressEventchannel,
      this._routeProgressNotifier);

  static WeMapNavigation _instance;

  final MethodChannel _methodChannel;
  final EventChannel _routeProgressEventchannel;
  final ValueSetter<bool> _routeProgressNotifier;

  Stream<bool> _onRouteProgress;
  StreamSubscription<bool> _routeProgressSubscription;

  ///Current Device OS Version
  Future<String> get platformVersion => _methodChannel
      .invokeMethod('getPlatformVersion')
      .then<String>((dynamic result) => result);

  ///Total distance remaining in meters along route.
  Future<double> get distanceRemaining => _methodChannel
      .invokeMethod<double>('getDistanceRemaining')
      .then<double>((dynamic result) => result);

  ///Total seconds remaining on all legs.
  Future<double> get durationRemaining => _methodChannel
      .invokeMethod<double>('getDurationRemaining')
      .then<double>((dynamic result) => result);

  Future startNavigation(
      {Location origin,
      Location destination,
      WeMapNavigationMode mode = WeMapNavigationMode.drivingWithTraffic,
      bool simulateRoute = false, String language}) async {
    assert(origin != null);
    assert(origin.name != null);
    assert(origin.latitude != null);
    assert(origin.longitude != null);
    assert(destination != null);
    assert(destination.name != null);
    assert(destination.latitude != null);
    assert(destination.longitude != null);
    final Map<String, Object> args = <String, dynamic>{
      "originName": origin.name,
      "originLatitude": origin.latitude,
      "originLongitude": origin.longitude,
      "destinationName": destination.name,
      "destinationLatitude": destination.latitude,
      "destinationLongitude": destination.longitude,
      "mode": mode.toString().split('.').last,
      "simulateRoute": simulateRoute,
      "language" : language
    };
    await _methodChannel.invokeMethod('startNavigation', args);
    _routeProgressSubscription = _streamRouteProgress.listen(_onProgressData);
  }

  ///Ends Navigation and Closes the Navigation View
  Future<bool> finishNavigation() async {
    var success = await _methodChannel.invokeMethod('finishNavigation', null);
    return success;
  }

  void _onProgressData(bool arrived) {
    if (_routeProgressNotifier != null) _routeProgressNotifier(arrived);

    if (arrived) _routeProgressSubscription.cancel();
  }

  Stream<bool> get _streamRouteProgress {
    if (_onRouteProgress == null) {
      _onRouteProgress = _routeProgressEventchannel
          .receiveBroadcastStream()
          .map((dynamic event) => _parseArrivalState(event));
    }
    return _onRouteProgress;
  }

  bool _parseArrivalState(bool state) {
    return state;
  }
}

class Location {
  final String name;
  final double latitude;
  final double longitude;

  Location(
      {@required this.name, @required this.latitude, @required this.longitude});
}

enum WeMapNavigationMode { walking, cycling, driving, drivingWithTraffic }

class NavigationView extends StatefulWidget {
  final Location origin;
  final Location destination;
  final bool simulateRoute;
  final String language;

  NavigationView(
      {@required this.origin, @required this.destination, this.simulateRoute, this.language});

  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  Map<String, Object> args;

  @override
  initState() {
    args = <String, dynamic>{
      "originName": widget.origin.name,
      "originLatitude": widget.origin.latitude,
      "originLongitude": widget.origin.longitude,
      "destinationName": widget.destination.name,
      "destinationLatitude": widget.destination.latitude,
      "destinationLongitude": widget.destination.longitude,
      "simulateRoute": widget.simulateRoute,
      "language" : widget.language
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 350,
      width: 350,
      child: AndroidView(
          viewType: "wemap_gl",
          creationParams: args,
          creationParamsCodec: StandardMessageCodec()),
    );
  }
}
