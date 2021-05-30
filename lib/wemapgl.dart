// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library wemapgl;

import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'dart:math' show cos, sqrt, asin;
import 'dart:io';
import 'dart:convert' as JSON;
import 'dart:typed_data';
import 'package:location/location.dart' as GPSService;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/cupertino.dart';
import 'package:rubber/rubber.dart';
import 'package:snaplist/snaplist.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wemapgl_platform_interface/wemapgl_platform_interface.dart';
export 'package:wemapgl_platform_interface/wemapgl_platform_interface.dart'
    show
        LatLng,
        LatLngBounds,
        LatLngQuad,
        CameraPosition,
        CameraUpdate,
        ArgumentCallbacks,
        Symbol,
        SymbolOptions,
        CameraTargetBounds,
        MinMaxZoomPreference,
        WeMapStyles,
        MyLocationTrackingMode,
        MyLocationRenderMode,
        CompassViewPosition,
        Circle,
        CircleOptions,
        Line,
        LineOptions,
        Fill,
        FillOptions,
        GeoJSON,
        GeoJSONOptions,
        WeMapGlPlatform,
        Configuration;


import 'src/place/query_api.dart';

import 'src/search/query_db.dart';
import 'src/search/search_history.dart';
import 'src/search/search_plugin.dart';

import 'utils/plugin.dart';
import 'utils/base64_items.dart';
import 'utils/language_vi.dart';


part 'src/controller.dart';
part 'src/wemap_map.dart';
part 'src/wemap_navigation.dart';
part 'src/global.dart';
part 'utils/custom_appbar.dart';

part 'src/place/place_card.dart';
part 'src/place/place_description.dart';
part 'src/place/place.dart';
part 'src/routing/location_ui.dart';
part 'src/routing/route_details.dart';
part 'src/routing/route_preview.dart';
part 'src/routing/choose_on_map.dart';
part 'src/routing/routing.dart';
part 'src/search/search_bar.dart';
part 'src/search/stream.dart';
part 'src/search/search.dart';
part 'src/search/query_api.dart';