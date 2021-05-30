

part of wemapgl;

enum WeMapGeocoder { Pelias, Photon, Nominatim, Explore }

class WeMapPlace {
  String description;
  int placeId;
  LatLng location;
  String types;
  String placeName;
  String street;
  String cityState;
  String value;
  String state;
  DateTime lastUpdated;
  //distance from focus.point to this point
  double distance;

  Map extraTags;
  void setExtraTags(Map _extraTags) {
    extraTags = _extraTags;
  }

  var fullJSON;

  WeMapPlace({
    this.description,
    this.placeId,
    this.types,
    this.cityState,
    this.location,
    this.placeName,
    this.state,
    this.street,
    this.value,
  });

  WeMapPlace.fromPhoton(place) {
    try {
      this.description = getDescription(place["properties"]);
      this.value = place["properties"]["osm_value"];
      this.placeName = getName(place["properties"]);
      this.street = getStreet(place["properties"]);
      this.cityState = getState(place["properties"]);
      this.state =
          place["properties"]["city"] ?? place["properties"]["state"] ?? "";
      this.placeId = place["properties"]["osm_id"];
      this.types = place["properties"]["osm_type"];
      this.location = new LatLng(place["geometry"]["coordinates"][1],
          place["geometry"]["coordinates"][0]);
      this.fullJSON = place;
    } catch (e) {
      print("Du lieu json photon khong hop le !");
    }
  }

  WeMapPlace.fromPelias(place) {
    RegExp regExp = new RegExp(
      r"[0-9]+$",
      caseSensitive: false,
      multiLine: false,
    );
    try {
      this.description = getDescriptionPelias(place["properties"]);
      this.value = place["properties"]["osm_value"];
      this.placeName = getName(place["properties"]);
      this.street = getStreet(place["properties"]);
      this.cityState = getState(place["properties"]);
      this.state =
          place["properties"]["county"] ?? place["properties"]["region"] ?? "";
      this.placeId = int.parse(
          regExp.stringMatch(place["properties"]["id"] ?? "").toString());
      this.types = place["properties"]["osm_type"];
      this.location = new LatLng(place["geometry"]["coordinates"][1],
          place["geometry"]["coordinates"][0]);
      this.distance = place["properties"]["distance"];
      this.fullJSON = place;
    } catch (e) {
      print("Du lieu json pelias khong hop le !");
    }
  }

  WeMapPlace.fromNominatim(place) {
    try {
      this.description = getDescriptionNominatim(place["properties"]);
      this.value = place["properties"]["type"];
      this.placeName = getNameNominatim(place["properties"]);
      this.street = getStreet(place["properties"]);
      this.cityState = getState(place["properties"]);
      this.state =
          place["properties"]["city"] ?? place["properties"]["state"] ?? "";
      this.placeId = place["properties"]["osm_id"];
      this.types = place["properties"]["category"];
      this.location = new LatLng(place["geometry"]["coordinates"][1],
          place["geometry"]["coordinates"][0]);
      this.fullJSON = place;
    } catch (e) {
      print("Du lieu json nominatim khong hop le !");
    }
  }

  WeMapPlace.fromExplore(place, String type) {
    try {
      this.description = getDescriptionExplore(place["address"], type);
      this.placeName = getNameExplore(place["address"], type);
      this.street = getStreetExplore(place["address"]);
      this.cityState = getStateExplore(place["address"]);
      this.state = place["address"]["city"] ?? place["address"]["state"];
      this.placeId = int.parse(place["osm_id"].toString());
      this.types = place["osm_type"];
      this.value = place["osm_value"];
      this.location =
          new LatLng(double.parse(place['lat']), double.parse(place['lon']));
      this.fullJSON = place;
    } catch (e) {
      print("Du lieu json explore khong hop le !" + e.toString());
    }
  }

  String getDescription(Map<String, dynamic> properties) {
    List<String> names = [];
    if (properties["name"] != null && properties["name"].trim().length != 0)
      names.add(properties["name"]);
    if (properties["housenumber"] != null && properties["street"] != null) {
      names.add('số ' + properties["housenumber"] + ' ' + properties["street"]);
    } else if (properties["street"] != null) {
      names.add(properties["street"]);
    }
    if (properties["city"] != null) names.add(properties["city"]);
    if (properties["state"] != null) names.add(properties["state"]);
    return names.join(', ');
  }

  String getDescriptionPelias(Map<String, dynamic> properties) {
    List<String> names = [];
    if (properties["name"] != null && properties["name"].trim().length != 0)
      names.add(properties["name"]);
    if (properties["housenumber"] != null && properties["street"] != null) {
      names.add('số ' + properties["housenumber"] + ' ' + properties["street"]);
    } else if (properties["street"] != null) {
      names.add(properties["street"]);
    }
    if (properties["county"] != null) names.add(properties["county"]);
    if (properties["region"] != null) names.add(properties["region"]);
    return names.join(', ');
  }

  String getDescriptionNominatim(Map<String, dynamic> properties) {
    String description = "";
    if (properties["display_name"] != null)
      description = properties["display_name"];
    return description;
  }

  String getDescriptionExplore(Map<String, dynamic> address, String type) {
    List<String> names = [];
    if (address[type] != null && address[type].trim().length != 0)
      names.add(address[type]);
    if (address["house_number"] != null && address["road"] != null) {
      names.add('số ' + address["house_number"] + ' ' + address["road"]);
    } else if (address["road"] != null) {
      names.add(address["road"]);
    }
    if (address["city"] != null) names.add(address["city"]);
    if (address["county"] != null) names.add(address["county"]);
    if (address["state"] != null) names.add(address["state"]);
    if (address["country"] != null) names.add(address["country"]);
    return names.join(', ');
  }

  String getName(Map<String, dynamic> properties) {
    if (properties["osm_value"] != null &&
        properties["osm_value"] == "bus_stop") {
      return "Trạm xe buýt ${properties["name"]}";
    } else {
      if (properties["name"] != null && properties["name"].trim().length != 0)
        return properties["name"];
      return getStreet(properties);
    }
  }

  String getNameNominatim(Map<String, dynamic> properties) {
    if (properties["type"] == "bus_stop") {
      return "Trạm xe buýt ${properties["name"]}";
    } else {
      if (properties["name"] != null && properties["name"].trim().length != 0)
        return properties["name"];
      return getDescriptionNominatim(properties);
    }
  }

  String getNameExplore(Map<String, dynamic> address, String type) {
    if (type == "bus_station") {
      return "Trạm xe buýt";
    } else {
      if (address[type] != null && address[type].trim().length != 0)
        return address[type];
      return getStreet(address);
    }
  }

  String getStreet(Map<String, dynamic> properties) {
    String street = "";
    if (properties["housenumber"] != null && properties["street"] != null) {
      street = 'số ' + properties["housenumber"] + ' ' + properties["street"];
    } else if (properties["street"] != null) {
      street = properties["street"];
    } else if (properties["city"] != null)
      street = properties["city"];
    else if (properties["state"] != null)
      street = properties["state"];
    else if (properties["county"] != null)
      street = properties["county"];
    else if (properties["region"] != null) street = properties["region"];
    return street;
  }

  String getStreetExplore(Map<String, dynamic> address) {
    String street = "";
    if (address["house_number"] != null && address["road"] != null) {
      street = 'số ' + address["house_number"] + ' ' + address["road"];
    } else if (address["road"] != null) {
      street = address["road"];
    } else {
      if (address["city"] != null)
        street = address["city"];
      else if (address["county"] != null)
        street = address["county"];
      else if (address["state"] != null) street = address["state"];
    }
    return street;
  }

  String getState(Map<String, dynamic> properties) {
    List<String> state = [];
    if (properties["city"] != null) state.add(properties["city"]);
    if (properties["state"] != null) state.add(properties["state"]);
    if (properties["county"] != null) state.add(properties["county"]);
    if (properties["region"] != null) state.add(properties["region"]);
    return state.join(", ");
  }

  String getStateExplore(Map<String, dynamic> address) {
    List<String> state = [];
    if (address["city"] != null) state.add(address["city"]);
    if (address["county"] != null) state.add(address["county"]);
    if (address["state"] != null) state.add(address["state"]);
    return state.join(", ");
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.placeId,
      'name': this.placeName,
      'lat': this.location.latitude,
      'lon': this.location.longitude,
      'cityState': this.cityState,
      'street': this.street,
      'description': this.description,
      'last_updated': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
    };
  }

  // Extract a Note object from a Map object
  WeMapPlace.fromMapObject(Map<dynamic, dynamic> map) {
    this.placeId = map['id'];
    this.placeName = map['name'];
    this.location = new LatLng(map['lat'], map['lon']);
    this.cityState = map['cityState'];
    this.street = map['street'];
    this.description = map['description'];
    this.lastUpdated = DateTime.parse(map['last_updated']);
  }
}


void weRequestLocation() async {
  final location = GPSService.Location();
  final hasPermissions = await location.hasPermission();
  final serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled)
    await location.requestService();
  else if (hasPermissions != GPSService.PermissionStatus.GRANTED)
    await location.requestPermission();
}