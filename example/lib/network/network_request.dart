import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wemapgl_example/model/room.dart';

class NetworkRequest {
  static const String url = 'https://thuong281.github.io/data/room.json';

  static List<Room> parseRooms(String reponseBody) {
    var list = json.decode(reponseBody) as List<dynamic>;
    List<Room> products = list.map((model) => Room.fromJson(model)).toList();
    return products;
  }

  static Future<List<Room>> fetchRooms() async {
    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      return parseRooms(response.body);
    }
  }
}
