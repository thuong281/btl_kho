part of wemapgl_platform_interface;

class GeoJSON {
  @visibleForTesting
  GeoJSON(this._id, this.options, [this._data]);

  /// A unique identifier for this geojson.
  ///
  /// The identifier is an arbitrary unique string.
  final String _id;
  String get id => _id;

  final Map _data;
  Map get data => _data;

  /// The geojson configuration options most recently applied programmatically
  /// via the map controller.
  ///
  /// The returned value does not reflect any changes made to the geojson through
  /// touch events. Add listeners to the owning map controller to track those.
  GeoJSONOptions options;
}

/// Configuration options for [GeoJSON] instances.
///
/// When used to change configuration, null values will be interpreted as
/// "do not change this configuration option".
class GeoJSONOptions {
  /// Creates a set of geojson configuration options.
  ///
  /// By default, every non-specified field is null, meaning no desire to change
  /// geojson defaults or current configuration.
  const GeoJSONOptions({
    this.fillOpacity,
    this.fillColor,
    this.fillOutlineColor,
    this.fillPattern,
    this.circleRadius,
    this.circleColor,
    this.circleBlur,
    this.circleOpacity,
    this.circleStrokeWidth,
    this.circleStrokeColor,
    this.circleStrokeOpacity,
    this.lineJoin,
    this.lineOpacity,
    this.lineColor,
    this.lineWidth,
    this.lineGapWidth,
    this.lineOffset,
    this.lineBlur,
    this.linePattern,
    this.geojson,
    this.type,
    this.draggable
  });

  static const String POINT = "Circle";
  static const String POLYLINE = "Line";
  static const String POLYGOL = "Fill";

  final double fillOpacity;
  final String fillColor;
  final String fillOutlineColor;
  final String fillPattern;

  final double circleRadius;
  final String circleColor;
  final double circleBlur;
  final double circleOpacity;
  final double circleStrokeWidth;
  final String circleStrokeColor;
  final double circleStrokeOpacity;
  
  final String lineJoin;
  final double lineOpacity;
  final String lineColor;
  final double lineWidth;
  final double lineGapWidth;
  final double lineOffset;
  final double lineBlur;
  final String linePattern;

  final String type;
  final String geojson;
  final bool draggable;

  static const GeoJSONOptions defaultOptions = GeoJSONOptions();

  GeoJSONOptions copyWith(GeoJSONOptions changes) {
    if (changes == null) {
      return this;
    }
    return GeoJSONOptions(
      fillOpacity: changes.fillOpacity ?? fillOpacity,
      fillColor: changes.fillColor ?? fillColor,
      fillOutlineColor: changes.fillOutlineColor ?? fillOutlineColor,
      fillPattern: changes.fillPattern ?? fillPattern,
      circleRadius: changes.circleRadius ?? circleRadius,
      circleColor: changes.circleColor ?? circleColor,
      circleBlur: changes.circleBlur ?? circleBlur,
      circleOpacity: changes.circleOpacity ?? circleOpacity,
      circleStrokeWidth: changes.circleStrokeWidth ?? circleStrokeWidth,
      circleStrokeColor: changes.circleStrokeColor ?? circleStrokeColor,
      circleStrokeOpacity: changes.circleStrokeOpacity ?? circleStrokeOpacity,
      lineJoin: changes.lineJoin ?? lineJoin,
      lineOpacity: changes.lineOpacity ?? lineOpacity,
      lineColor: changes.lineColor ?? lineColor,
      lineWidth: changes.lineWidth ?? lineWidth,
      lineGapWidth: changes.lineGapWidth ?? lineGapWidth,
      lineOffset: changes.lineOffset ?? lineOffset,
      lineBlur: changes.lineBlur ?? lineBlur,
      linePattern: changes.linePattern ?? linePattern,
      geojson: changes.geojson ?? geojson,
      type: changes.type ?? type,
      draggable: changes.draggable ?? draggable,
    );
  }

  Future<List<dynamic>> addToMap(dynamic controller) async {
    List<dynamic> result = [];
    if(controller != null )
      switch (this.type) {
        case POINT:
          var points = await getCircles();
          for(int i=0; i<points.length; i++){
            result.add(controller.addCircle(points[i]));
          }
          break;
        case POLYLINE:
          var lines = await getLines();
          for(int i=0; i<lines.length; i++){
            result.add(controller.addLine(lines[i]));
          }
          break;
        case POLYGOL:
          var fills = await getFills();
          for(int i=0; i<fills.length; i++){
            result.add(controller.addFill(fills[i]));
          }
          break;
        default:
      }
    return result;
  }

  Future<List<CircleOptions>> getCircles() async {
    List<CircleOptions> result = [];
    var points = await getGeometries(POINT);
    for (int i = 0; i < points.length; i++) {
      result.add(new CircleOptions(
        circleRadius: this.circleRadius,
        circleColor: this.circleColor,
        circleBlur: this.circleBlur,
        circleOpacity: this.circleOpacity,
        circleStrokeWidth: this.circleStrokeWidth,
        circleStrokeColor: this.circleStrokeColor,
        circleStrokeOpacity: this.circleStrokeOpacity,
        geometry: points[i],
        draggable: this.draggable
      ));
    }
    return result;
  }

  Future<List<LineOptions>> getLines() async {
    List<LineOptions> result = [];
    var lines = await getGeometries(POLYLINE);
    for (int i = 0; i < lines.length; i++) {
      result.add(new LineOptions(
        lineJoin: this.lineJoin,
        lineOpacity: this.lineOpacity,
        lineColor: this.lineColor,
        lineWidth: this.lineWidth,
        lineGapWidth: this.lineGapWidth,
        lineOffset: this.lineOffset,
        lineBlur: this.lineBlur,
        linePattern: this.linePattern,
        geometry: lines[i],
        draggable: this.draggable
      ));
    }
    return result;
  }

  Future<List<FillOptions>> getFills() async {
    List<FillOptions> result = [];
    var fills = await getGeometries(POLYGOL);
    for (int i = 0; i < fills.length; i++) {
      result.add(new FillOptions(
        fillOpacity: this.fillOpacity,
        fillColor: this.fillColor,
        fillOutlineColor: this.fillOutlineColor,
        fillPattern: this.fillPattern,
        geometry: fills[i],
        draggable: this.draggable
      ));
    }
    return result;
  }

  Future<dynamic> getGeoJSON() async {
    dynamic json; 
    if(this.geojson.contains("http")){
      try{
        final response = await http.get(this.geojson);
        json = JSON.jsonDecode(response.body);
      } catch(err) {
        print(err.toString());
      }
    } else if (this.geojson.contains("assets")){
      try{
        final response = await rootBundle.loadString(this.geojson);
        json = JSON.jsonDecode(response);
      } catch(err) {
        print(err.toString());
      }
    } else {
      try{
        json = JSON.jsonDecode(this.geojson);
      } catch(err) {
        print(err.toString());
      }
    }
    return json;
  }

  
  Future<dynamic> getGeometries(String type) async {
    dynamic json = await getGeoJSON();
    if(json != []){
      List<dynamic> geometries = [];
      List<dynamic> result = [];
      if(json["type"] == "GeometryCollection"){
        if(json["geometries"] != null && json["geometries"].length > 0){
          geometries = json["geometries"];
        }
      } else if(json["type"] == "FeatureCollection"){
        if(json["features"] != null && json["features"].length > 0){
          for(int i=0; i< json["features"].length; i++){
            geometries.add(json["features"][i]["geometry"]);
          }
        }
      }
      if(geometries.length == 0){
        return [];
      } else {
        switch (type) {
          case POINT:
            for(int i=0; i< geometries.length; i++){
              if(geometries[i]["type"] == "Point"){
                result.add(LatLng(geometries[i]["coordinates"][1].toDouble(), geometries[i]["coordinates"][0].toDouble()));
              } else if(geometries[i]["type"] == "MultiPoint"){
                for(int j = 0; j < geometries[i]["coordinates"].length; j++){
                  result.add(LatLng(geometries[i]["coordinates"][j][1].toDouble(), geometries[i]["coordinates"][j][0].toDouble()));
                }
              }
            }
            break;
          case POLYLINE:
            for(int i=0; i< geometries.length; i++){
              if(geometries[i]["type"] == "LineString"){
                List<LatLng> line = [];
                for(int j=0; j < geometries[i]["coordinates"].length; j++){
                  line.add(LatLng(geometries[i]["coordinates"][j][1].toDouble(), geometries[i]["coordinates"][j][0].toDouble()));
                }
                result.add(line);
              } else if(geometries[i]["type"] == "MultiLineString"){
                for(int j=0; j < geometries[i]["coordinates"].length; j++){
                  List<LatLng> line = [];
                  for(int k=0; k < geometries[i]["coordinates"][j].length; k++){
                    line.add(LatLng(geometries[i]["coordinates"][j][k][1].toDouble(), geometries[i]["coordinates"][j][k][0].toDouble()));
                  }
                  result.add(line);
                }
              } else if(geometries[i]["type"] == "Polygon"){
                for(int j=0; j < geometries[i]["coordinates"].length; j++){
                  List<List<LatLng>> lines = [];
                  for(int k=0; k < geometries[i]["coordinates"][j].length; k++){
                    List<LatLng> line = [];
                    for(int l=0; l < geometries[i]["coordinates"][j][k].length; l++){
                      line.add(LatLng(geometries[i]["coordinates"][j][k][l][1].toDouble(), geometries[i]["coordinates"][j][k][l][0].toDouble()));
                    }
                    lines.add(line);
                  }
                  result.addAll(lines);
                }
              } else if(geometries[i]["type"] == "MultiPolygon"){
                for(int j = 0; j < geometries[i]["coordinates"].length; j++){
                  for(int k = 0; k < geometries[i]["coordinates"][j].length; k++){
                      List<LatLng> line = [];
                    for(int l = 0; l < geometries[i]["coordinates"][j][k].length; l++){
                      line.add(LatLng(geometries[i]["coordinates"][j][k][l][1].toDouble(), geometries[i]["coordinates"][j][k][l][0].toDouble()));
                    }
                    result.add(line);
                  }
                }
              }
            }
            break;
          case POLYGOL:
            for(int i=0; i< geometries.length; i++){
              if(geometries[i]["type"] == "Polygon"){
                List<List<LatLng>> fill = [];
                for(int j=0; j < geometries[i]["coordinates"].length; j++){
                  List<LatLng> line = [];
                  for(int k=0; k < geometries[i]["coordinates"][j].length; k++){
                    line.add(LatLng(geometries[i]["coordinates"][j][k][1].toDouble(), geometries[i]["coordinates"][j][k][0].toDouble()));
                  }
                  fill.add(line);
                }
                result.add(fill);
              } else if(geometries[i]["type"] == "MultiPolygon"){
                for(int j=0; j < geometries[i]["coordinates"].length; j++){
                  List<List<LatLng>> fill = [];
                  for(int k=0; k < geometries[i]["coordinates"][j].length; k++){
                    List<LatLng> line = [];
                    for(int l=0; l < geometries[i]["coordinates"][j][k].length; l++){
                        line.add(LatLng(geometries[i]["coordinates"][j][k][l][1].toDouble(), geometries[i]["coordinates"][j][k][l][0].toDouble()));
                    }
                    fill.add(line);
                  }
                  result.add(fill);
                }
              }
            }
            break;
          default:
        }
        return result;
      }
    } else {
      return null;
    }
  }

  dynamic toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('circleRadius', circleRadius);
    addIfPresent('circleColor', circleColor);
    addIfPresent('circleBlur', circleBlur);
    addIfPresent('circleOpacity', circleOpacity);
    addIfPresent('circleStrokeWidth', circleStrokeWidth);
    addIfPresent('circleStrokeColor', circleStrokeColor);
    addIfPresent('circleStrokeOpacity', circleStrokeOpacity);
    addIfPresent('lineJoin', lineJoin);
    addIfPresent('lineOpacity', lineOpacity);
    addIfPresent('lineColor', lineColor);
    addIfPresent('lineWidth', lineWidth);
    addIfPresent('lineGapWidth', lineGapWidth);
    addIfPresent('lineOffset', lineOffset);
    addIfPresent('lineBlur', lineBlur);
    addIfPresent('linePattern', linePattern);
    addIfPresent('fillOpacity', fillOpacity);
    addIfPresent('fillColor', fillColor);
    addIfPresent('fillOutlineColor', fillOutlineColor);
    addIfPresent('fillPattern', fillPattern);
    addIfPresent('geojson', geojson);
    addIfPresent('draggable', draggable);
    return json;
  }
}