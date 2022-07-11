part of 'display_page_bloc.dart';

abstract class DisplayPageEvent extends Equatable {
  const DisplayPageEvent();

  @override
  List<Object> get props => [];
}

class DisplayPageEventLoad extends DisplayPageEvent {
  final Surah surah;
  final List<Surah> sourates;
  DisplayPageEventLoad({required this.sourates, required this.surah});
}

class DisplayPageSwipe extends DisplayPageEvent {
  final int page;
  final List<Surah> sourates;
  final SwipeDirectionEnum swipeDirection;
  DisplayPageSwipe(
      {required this.sourates,
      required this.page,
      required this.swipeDirection});
}
