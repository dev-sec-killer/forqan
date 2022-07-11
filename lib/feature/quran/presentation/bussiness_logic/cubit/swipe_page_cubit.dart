import 'package:flutter_bloc/flutter_bloc.dart';

class SwipePageCubit extends Cubit<int> {
  SwipePageCubit() : super(0);

  swipeLeft({required int page}) {
    emit(page + 1);
  }

  swipeRight({required int page}) {
    emit(page - 1);
  }
}
