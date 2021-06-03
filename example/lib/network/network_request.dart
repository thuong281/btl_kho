import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wemapgl_example/model/room.dart';

class NetworkRequest {
  static List<Room> fetchData() {
    List<Room> result = [];
    List<String> img = [];
    img.add(
        "https://cdn.chotot.com/0tAwaAEfZuRdKqtCKyKLo4OPfcJM-yG80XbKd8FGx0w/preset:view/plain/c006d231790534c5a6bb134437c057a8-2720519385059246815.jpg");
    img.add(
        "https://cdn.chotot.com/WJg9MGOYEFgM83Jw7iL7gQYNmB_qwmcNrDH5q7AgPsA/preset:view/plain/72847e55818f967d88f5de2cdbf1d15d-2720519384864670671.jpg");
    result.add(new Room(
        name: "Phòng trọ đẹp giá rẻ Quận Cầu Giấy 36m² cho thuê",
        image: img,
        price: "1.299.999",
        lat: 21.0461161,
        long: 105.7790328,
        area: "50",
        description:
            """"Tòa chung cư mini 6 tầng (có thang máy) ngay ngã ba Lương Thế Vinh - Trung Văn.
                Căn chung cư mini diện tích 25 - 30m2, khép kín.
                Phòng có đầy đủ tiện nghi như:
                - Có sẵn điều hòa, nóng lạnh.
                - Đầy đủ giường nằm, tủ quần áo, bàn bếp, bàn ăn.
                - Căn hộ có cửa sổ thoáng mát,
                - Chỗ để xe rộng rãi tầng 1.
                - Wifi tốc độ cao, hệ thống camera an ninh.
                - Giờ giấc tự do, không chung chủ.
                - Cửa từ, khoá vân tay.
                - Giá cho thuê từ 2.8 tr - 3 tr - 3.2 tr/tháng.
                Anh chủ nhà vui tính, nhiệt tình giúp đỡ mọi người trong nhà.""",
        address:
            "Cho thuê chung cư mini ngay cách bến xe Mỹ Đình 400m2, điều hòa mát rượi, vệ sinh sạch sẽ,\nĐịa chỉ: Số nhà 16 đường Đồng Bát.\nVị trí: Cách bến xe Mỹ Đình 400m2, cách Đại Học Thương Mại 1.5km.\nDiện tích: 30m2, tòa nhà gồm 14P.\nThang máy tốc độ cao từ tầng 1 tầng 9,\nCamera giám sát an ninh 24/7,\nÔ tô đỗ cửa,\nVệ sinh sạch sẽ,\nKhông chung chủ,\nXe để tại tầng 1 của tòa nhà.\nNội thất được thiết kế full nội thất.\nLiên hệ thuê trực tiếp chính chủ.",
        phone: "0828602525"));

    return result;
  }

  static const String url = 'https://thuong281.github.io/data/room.json';

  static List<Room> parseRooms(String reponseBody) {
    var list = json.decode(reponseBody) as List<dynamic>;
    List<Room> products = list.map((model) => Room.fromJson(model)).toList();
    return products;
  }

  static Future<List<Room>> fetchRoomss() async {
    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      return parseRooms(response.body);
    }
  }
}
