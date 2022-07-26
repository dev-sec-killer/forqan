import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:quran/quran.dart' as quran;

import '../../../../core/enum.dart';
import '../../../../data/models/surah.dart';
import 'display_page_event.dart';
import 'display_page_state.dart';

class DisplayPageBloc extends HydratedBloc<DisplayPageEvent, DisplayPageState> {
  DisplayPageBloc() : super(DisplayPageInitial()) {
    on<DisplayPageEventLoad>(
        (event, emit) => _displayPageEventLoad(event, emit));
    on<DisplayPageSwipe>((event, emit) => _displayPageSwipe(event, emit));
  }

  _displayPageEventLoad(DisplayPageEventLoad event, emit) {
    emit(DisplayPageLoading());

    int page = quran.getSurahPages(event.surah.id).first;
    List<dynamic> pageDatas = quran.getPageData(page);
    int count = pageDatas.length;
    var data = {
      "page": page,
      "pageDatas": pageDatas,
      "count": count,
      "sourates": event.sourates.map((e) => e.toJson()).toList()
    };
    log(jsonEncode(data));
    emit(DisplayPageLoaded(
        page: page,
        pageDatas: pageDatas,
        count: count,
        sourates: event.sourates));
  }

  _displayPageSwipe(DisplayPageSwipe event, emit) {
    emit(DisplayPageLoading());

    int page = event.swipeDirection == SwipeDirectionEnum.left
        ? event.page - 1
        : event.page + 1;
    if (page == 605) {
      emit(DisplayPageFailed(error: "Vous avez atteint la dernière page"));
      page--;
    } else if (page == 0) {
      emit(DisplayPageFailed(
          error:
              "Vous etes à la première page vous ne pouvez plus continuer."));
      page++;
    }
    List<dynamic> pageDatas = quran.getPageData(page);
    int count = pageDatas.length;
    //log(pageDatas);
    emit(DisplayPageLoaded(
        page: page,
        pageDatas: pageDatas,
        count: count,
        sourates: event.sourates));
  }

  @override
  DisplayPageState? fromJson(Map<String, dynamic> json) {
    try {
      return DisplayPageLoaded(
          count: json["count"] as int,
          pageDatas: json["pageDatas"] as List<dynamic>,
          sourates: json["sourates"]
              .map((sourate) => Surah.fromJson(sourate))
              .toList(),
          page: json["page"] as int);
    } catch (err) {
      print(err);
      rethrow;
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(DisplayPageState state) {
    if (state is DisplayPageLoaded) {
      var data = <String, dynamic>{
        "page": state.page,
        "pageDatas": state.pageDatas,
        "count": state.count,
        "sourates": state.sourates.map((e) => e.toJson()).toList()
      };
      return data;
    } else {
      return null;
    }
  }
}
