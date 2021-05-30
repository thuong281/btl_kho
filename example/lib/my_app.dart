import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wemapgl_example/map.dart';
import 'package:wemapgl_example/route.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double lat = 3;
  double long = 0;
  Future _future;
  Position position = new Position();

  @override
  void initState() {
    super.initState();
    _future = getCurrentLocation();
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
    return position;
  }

  circularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("bu Cac"),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return circularProgress();
            } else {
              position = snapshot.data;
              return Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      child: Text("push me"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullMap(
                              position: position,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      child: Text("push me 2 XD"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
