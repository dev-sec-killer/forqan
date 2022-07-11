import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quran/quran.dart' as quran;

import '../../../../core/enum.dart';
import '../../../../data/models/surah.dart';

part 'display_page_event.dart';
part 'display_page_state.dart';

class DisplayPageBloc extends Bloc<DisplayPageEvent, DisplayPageState> {
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
    emit(DisplayPageLoaded(
        page: page,
        pageDatas: pageDatas,
        count: count,
        sourates: event.sourates));
  }
}
