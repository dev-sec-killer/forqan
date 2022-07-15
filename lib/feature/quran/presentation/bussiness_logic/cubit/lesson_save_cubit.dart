import 'package:flutter_bloc/flutter_bloc.dart';

class LessonSaveCubit extends Cubit<LessonSaveCubitState> {
  LessonSaveCubit() : super(LessonSaveCubitStateInitial());
  List<Map<String, int>> lessonLimit = [];

  markLesson({required int numAyat, required int numSourate}) {
    emit(LessonSaveCubitStateLoading());
    if (lessonLimit.isEmpty) {
      lessonLimit.add({'numAyat': numAyat, 'numSourate': numSourate});
    } else if (lessonLimit.length == 1) {
      lessonLimit.add({'numAyat': numAyat, 'numSourate': numSourate});
      emit(LessonSaveCubitStateSaved(lessonLimit: lessonLimit));
    } else {
      lessonLimit.clear();
    }
  }
}

abstract class LessonSaveCubitState {}

class LessonSaveCubitStateSaved extends LessonSaveCubitState {
  final List<Map<String, int>> lessonLimit;
  LessonSaveCubitStateSaved({required this.lessonLimit});
}

class LessonSaveCubitStateInitial extends LessonSaveCubitState {}

class LessonSaveCubitStateLoading extends LessonSaveCubitState {}

class LessonSaveCubitStateFailed extends LessonSaveCubitState {
  final String error;
  LessonSaveCubitStateFailed({required this.error});
}
