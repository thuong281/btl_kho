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
        id: 1,
        title: "Phòng trọ đẹp giá rẻ Quận Cầu Giấy 36m² cho thuê",
        imageUrl: img,
        price: "1.299.999",
        lat: 21.0461161,
        long: 105.7790328,
        area: 50,
        location:
            "Ngõ 164 Lê Trọng Tấn, Phường Khương Mai, Quận Thanh Xuân, Hà Nội",
        description:
            """Chính chủ cho thuê phòng 22m2 tại ngõ 322/95 đường Mỹ Đình - ở được luôn.
( Lối đi nhanh: Vào Ngõ 322/95 Mỹ Đình rẽ vào 322/17 đi thẳng đến số nhà 46 là tới ).

+ Diện tích phòng 22m2:( Như ảnh chụp)
* Trong phòng có:

+ Bình nước nóng.
+ Giường 1.6*2m
+ Bàn bếp nấu
+ Giá để bát đĩa

* Đặc điểm: Phòng ở tầng 1 trong nhà 4 tầng nên mát mẻ vào mùa hè

* Vị trí: Cách Trường Cao Đẳng công nghệ Bách khoa 500m, cách chợ Nhân Mỹ 200m, gần khu đô thị The Marno, Big C Gaden, SVĐ Mỹ Đình, KeangNam....
- Khu cư dân an ninh tốt, Yên tĩnh.
- Chỗ để xe máy free tại tầng 1.
- Camera an ninh
- Wifi tốc độ cao.

* Giá thuê: 2.5 triệu/th (Cọc 1 thanh toán tháng 1 lần).
* Liên hệ trực tiếp chủ nhà:""",
        furniture: "khong",
        phone: "0828602525"));

    return result;
  }
}
