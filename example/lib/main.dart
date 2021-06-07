import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart' as WEMAP;
import 'package:wemapgl_example/screen/tab_bar.dart';

void main() {
  WEMAP.Configuration.setWeMapKey('GqfwrZUEfxbwbnQUhtBMFivEysYIxelQ');
  runApp(
    MaterialApp(
      home: Options(),
    ),
  );
}
