part of wemapgl_platform_interface;

class Configuration {
  static String _openWeatherKey;
  static String _weMapKey;

  static String get weMapKey => _weMapKey;
  static String get openWeatherKey => _openWeatherKey;

  static void setWeMapKey(String weMapKey) {
    _weMapKey = weMapKey;
  }

  static void setOpenWeatherKey(String openWeatherKey) {
    _openWeatherKey = openWeatherKey;
  }

  static void validateWeMapKey() async {
    if (_weMapKey == null) {
      print('''
      Vui lòng đặt giá trị cho wemap key trước khi runApp()

      Configuration.setWeMapKey('YOUR_KEY_HERE');
      Configuration.setOpenWeatherKey('YOUR_KEY_HERE');
      runApp(MyApp());
      
      ''');
      print('Key được lấy từ: ');
    } else {
      // try {
      //   final response = await http.get(apiReverse(LatLng(21.3, 105.8)));
      //   final jsondecode = jsonDecode(response.body);
      //   print(jsondecode['Message']);
      // } catch (e) {}
    }
  }

  static void validateOpenWeatherKey() async {
    if (_openWeatherKey == null) {
      print('''
      Vui lòng đặt giá trị cho wemap key trong hàm main()
      
      Configuration.setWeMapKey('YOUR_KEY_HERE');
      Configuration.setOpenWeatherKey('YOUR_KEY_HERE');
      runApp(MyApp());
      ''');
      print('Key được lấy từ: ');
    } else {
      // try {
      //   final response = await http.get(apiReverse(LatLng(21.3, 105.8)));
      //   final jsondecode = jsonDecode(response.body);
      //   print(jsondecode['message']);
      // } catch (e) {}
    }
  }
  
}

