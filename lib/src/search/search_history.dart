import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wemapgl/utils/language_vi.dart';
import 'package:wemapgl/wemapgl.dart';
import 'query_db.dart';
import 'search_plugin.dart';

class SearchHistory extends StatefulWidget {
  final Function(WeMapPlace place) onSelected;
  final String title;
  final bool isUpperCase;

  final String todayText;
  final String yesterdayText;
  final String beforeYesterdayText;
  final String previousSearchesText;

  SearchHistory({
    this.onSelected,
    this.title = wemap_searchHistory,
    this.isUpperCase = true,
    this.todayText = wemap_today,
    this.yesterdayText = wemap_yesterday,
    this.beforeYesterdayText = wemap_beforeYesterday,
    this.previousSearchesText = wemap_previousSearches,
  });

  @override
  _SearchHistoryState createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  ScrollController _scrollController; //Controll of listview
  double _appbarElevation = 0.7; //evlevation of appbar

  @override
  void initState() {
    print("init");
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _appbarElevation = _scrollController.offset >= 0.2 ? 5.0 : 0.7;
      });
    });
    getDataDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: _appbarElevation,
        centerTitle: true,
        title: Text(
          widget.isUpperCase
              ? widget.title
              : toBeginningOfSentenceCase(widget.title.toLowerCase()),
          style: TextStyle(color: Colors.black),
        ),
        brightness: Brightness.light,
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder(
            stream: streamPlace.stream,
            builder: (context, snapdata) {
              List<WeMapPlace> allPlace = snapdata.data ?? [];
              return ListView(
                controller: _scrollController,
                children: getHsIntoWidget(
                  previousSearchesList:
                      getPlaceHistory(DateQuery.PREVIOUSSEARCHES, allPlace),
                  beforeYesterdayList:
                      getPlaceHistory(DateQuery.BEFOREYESTERDAY, allPlace),
                  yesterdayList: getPlaceHistory(DateQuery.YESTERDAY, allPlace),
                  todayList: getPlaceHistory(DateQuery.TODAY, allPlace),
                  todayText: widget.todayText,
                  yesterdayText: widget.yesterdayText,
                  beforeYesterdayText: widget.beforeYesterdayText,
                  previousSearchesText: widget.previousSearchesText,
                  selected: (WeMapPlace place) => _selectPlace(place),
                ),
              );
            }),
      ),
    );
  }

  void getDataDb() async {
    streamPlace.increment(await getAllPlace());
  }

  void _selectPlace(WeMapPlace place) {
    Navigator.pop(context);
    // Calls the `onSelected` callback
    widget.onSelected(place);
    //Save db
    savePlace(place);
  }
}
