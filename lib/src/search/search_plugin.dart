import 'package:flutter/material.dart';
import 'package:wemapgl/utils/language_vi.dart';
import 'package:wemapgl/wemapgl.dart';
import 'query_db.dart';

List<Widget> getHsIntoWidget(
    {List todayList,
    List yesterdayList,
    List beforeYesterdayList,
    List previousSearchesList,
    String todayText = wemap_today,
    String yesterdayText = wemap_yesterday,
    String beforeYesterdayText = wemap_beforeYesterday,
    String previousSearchesText = wemap_previousSearches,
    Function selected}) {
  return (<Widget>[
        Visibility(
          visible: todayList.length != 0,
          child: Column(
            children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                      child: Text(
                        todayText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      width: double.infinity),
                ] +
                todayList.map((place) {
                  return placeOption(
                    place,
                    selected,
                    prefixIcon: Icons.access_time,
                  );
                }).toList(),
          ),
        )
      ] +
      [
        Visibility(
          visible: yesterdayList.length != 0,
          child: Column(
            children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                      child: Text(
                        yesterdayText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      width: double.infinity),
                ] +
                yesterdayList.map((place) {
                  return placeOption(place, selected,
                      prefixIcon: Icons.access_time);
                }).toList(),
          ),
        )
      ] +
      [
        Visibility(
          visible: beforeYesterdayList.length != 0,
          child: Column(
            children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                      child: Text(
                        beforeYesterdayText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      width: double.infinity),
                ] +
                beforeYesterdayList.map((place) {
                  return placeOption(place, selected,
                      prefixIcon: Icons.access_time);
                }).toList(),
          ),
        )
      ] +
      [
        Visibility(
            visible: previousSearchesList.length != 0,
            child: Column(
              children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                        child: Text(
                          previousSearchesText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        width: double.infinity),
                  ] +
                  previousSearchesList.map((place) {
                    return placeOption(place, selected,
                        prefixIcon: Icons.access_time);
                  }).toList(),
            ))
      ]);
}

Widget placeOption(
  WeMapPlace place,
  Function selected, {
  bool isSearching = false,
  IconData prefixIcon,
  Color prefixBackgroundColorColor,
  Color prefixForegroundColor,
}) {
  if (place.distance == null) place.distance = -1;
  List subtitle = [];

  // if (place.street != null && place.street != "") subtitle.add(place.street);
  if (place.cityState != null && place.cityState != "")
    subtitle.add(place.cityState);

  return GestureDetector(
    child: MaterialButton(
      onLongPress: isSearching ? null : () => deletePlaceInHistory(place),
      onPressed: () => selected(place),
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: CircleAvatar(
                  child: Icon(
                    prefixIcon ?? Icons.location_on,
                    size: 18,
                  ),
                  backgroundColor: Color(0xff91a5b0),
                  foregroundColor: Colors.white,
                  radius: 15,
                )),
            SizedBox(height: 1.5),
            Visibility(
              visible: place.distance != -1 && place.distance < 1000,
              child: Text(
                place.distance < 1
                    ? "${(place.distance * 1000).toStringAsFixed(0)} m"
                    : "${place.distance.toStringAsFixed(1)} km",
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xff91a5b0),
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              place.placeName ?? "",
              style: TextStyle(fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              subtitle.join(", "),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black.withOpacity(0.6),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    ),
  );
}
