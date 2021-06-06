import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart' as WEMAP;
import 'package:wemapgl_example/screen/options.dart';
import 'package:wemapgl_example/screen/room_list.dart';

void main() {
  WEMAP.Configuration.setWeMapKey('GqfwrZUEfxbwbnQUhtBMFivEysYIxelQ');
  runApp(
    MaterialApp(
      home: Options(),
    ),
  );
}
