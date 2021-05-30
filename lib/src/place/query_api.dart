import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:http/http.dart' as http;
import 'package:wemapgl/utils/plugin.dart';

Future<WeMapPlace> getPlace(LatLng latLng) async {
  Map json;
  WeMapPlace _place;
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.none) {
    try {
      final response = await http.get(apiReverse(latLng));
      final jsondecode = jsonDecode(response.body);
      json = jsondecode;
      // print(json);
    } catch (e) {
      print('Loi goi info from http');
    }
    Map features;
    if (json["features"] == null) {
      _place = WeMapPlace(
        description:
            '${latLng.latitude.toStringAsFixed(5)}, ${latLng.longitude.toStringAsFixed(5)}',
        cityState: '',
        location: latLng,
        placeId: -1,
        placeName: 'Địa điểm chưa biết',
        state: '',
        street: '',
      );
    } else if (json["features"].length > 0) {
      features = json["features"][0];
    }
    if (features != null)
      _place = WeMapPlace.fromPelias(features);
    else
      _place = WeMapPlace(
        description:
            '${latLng.latitude.toStringAsFixed(5)}, ${latLng.longitude.toStringAsFixed(5)}',
        cityState: '',
        location: latLng,
        placeId: -1,
        placeName: 'Địa điểm chưa biết',
        state: '',
        street: '',
      );
  }
  return _place;
}

Future<Map> getExtraTag(int osmID) async {
  Map extraTags = {};
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.none) {
    try {
      final responseLookup = await http.get(apiLookup(osmID));
      final jsondecodeLookup = jsonDecode(responseLookup.body);
      extraTags = jsondecodeLookup["extratags"];
    } catch (e) {
      print('lookup error');
    }
  }
  return extraTags;
}
