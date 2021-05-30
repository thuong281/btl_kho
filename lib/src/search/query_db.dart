import 'package:async/async.dart';
import 'package:wemapgl/wemapgl.dart';

import 'database.dart';

PlaceHistoryHelper _searchDB = PlaceHistoryHelper.instance;
AsyncMemoizer<List<WeMapPlace>> _cacheDb = AsyncMemoizer<List<WeMapPlace>>();
WeMapStream<List<WeMapPlace>> streamPlace = WeMapStream<List<WeMapPlace>>();

void savePlace(WeMapPlace place) async {
  if (await _searchDB.existPlace(place.placeId)) {
    // Case 1: Update operation
    placeUpdate(place);
  } else {
    // Case 2: Insert Operation
    placeInsert(place);
  }
  // print(result);
}

Future<List<WeMapPlace>> getAllPlace() async {
  return _cacheDb.runOnce(() async {
    // print("Query place in db");
    return await _searchDB.getPlaceList();
  });
}

void placeInsert(WeMapPlace place) async {
  // print("insert place with id = ${place.placeId}");
  List<WeMapPlace> newList = streamPlace.data;
  if (newList != null) {
    newList.add(place);
    streamPlace.increment(newList);
  }
  await _searchDB.insertPlace(place);
  _cacheDb = AsyncMemoizer<List<WeMapPlace>>();
}

void placeUpdate(WeMapPlace place) async {
  // print("update place with id = ${place.placeId}");
  List<WeMapPlace> newList = streamPlace.data;
  if (newList != null) {
    for (WeMapPlace oldPlace in streamPlace.data) {
      if (oldPlace.placeId == place.placeId) {
        newList.remove(oldPlace);
        newList.add(place);
        break;
      }
    }
    streamPlace.increment(newList);
  }

  await _searchDB.updatePlace(place);
  _cacheDb = AsyncMemoizer<List<WeMapPlace>>();
}

void deletePlaceInHistory(WeMapPlace place) async {
  // print("delete place with id = ${place.placeId}");
  List<WeMapPlace> newList = streamPlace.data;
  if (newList != null) {
    for (WeMapPlace oldPlace in streamPlace.data) {
      if (oldPlace.placeId == place.placeId) {
        newList.remove(oldPlace);
        break;
      }
    }
    streamPlace.increment(newList);
  }

  await _searchDB.deletePlace(place);
  _cacheDb = AsyncMemoizer<List<WeMapPlace>>();
}

void deleteAllInHistory() async {
  streamPlace.increment([]);

  await _searchDB.deleteAll();
  _cacheDb = AsyncMemoizer<List<WeMapPlace>>();
}

List<WeMapPlace> getPlaceHistory(DateQuery date, List<WeMapPlace> allPlace, {int limit}) {
  List<WeMapPlace> places = [];
  int len = 0;
  if (allPlace == null)
    return places;
  else if (limit == null)
    len = allPlace.length;
  else if (allPlace.length < limit)
    len = allPlace.length;
  else
    len = limit;
  switch (date) {
    case DateQuery.YESTERDAY:
      for (int i = 0; i < len; i++) {
        WeMapPlace place = allPlace[i];
        final now = DateTime.now();
        if (DateTime(
              place.lastUpdated.year,
              place.lastUpdated.month,
              place.lastUpdated.day,
            ) ==
            DateTime(
              now.year,
              now.month,
              now.day - 1,
            )) places.add(place);
      }
      break;
    case DateQuery.BEFOREYESTERDAY:
      for (int i = 0; i < len; i++) {
        WeMapPlace place = allPlace[i];
        final now = DateTime.now();
        if (DateTime(
              place.lastUpdated.year,
              place.lastUpdated.month,
              place.lastUpdated.day,
            ) ==
            DateTime(
              now.year,
              now.month,
              now.day - 2,
            )) places.add(place);
      }
      break;
    case DateQuery.PREVIOUSSEARCHES:
      for (int i = 0; i < len; i++) {
        WeMapPlace place = allPlace[i];
        final now = DateTime.now();
        if (place.lastUpdated.isBefore(DateTime(
          now.year,
          now.month,
          now.day - 2,
        ))) places.add(place);
      }
      break;
    default:
      for (int i = 0; i < len; i++) {
        WeMapPlace place = allPlace[i];
        final now = DateTime.now();
        if (DateTime(
              place.lastUpdated.year,
              place.lastUpdated.month,
              place.lastUpdated.day,
            ) ==
            DateTime(
              now.year,
              now.month,
              now.day,
            )) places.add(place);
      }
  }

  return places;
}

enum DateQuery { TODAY, YESTERDAY, BEFOREYESTERDAY, PREVIOUSSEARCHES }
