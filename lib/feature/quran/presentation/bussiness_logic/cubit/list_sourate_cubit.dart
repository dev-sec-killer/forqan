import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forqan/feature/quran/data/repositories/sourate_list_repo.dart';

import '../../../data/models/surah.dart';

class ListSourateCubit extends Cubit<ListSourateCubitState> {
  ListSourateCubit({required this.sourateListRepo})
      : super(ListSourateCubitStateListInitial());
  final SourateListRepo sourateListRepo;

  getSourateList({required bool isReverse}) async {
    emit(ListSourateCubitStateListLoading());
    try {
      List<Surah> surahList = await sourateListRepo.readSourateListJson();
      if (isReverse)
        emit(ListSourateCubitStateListLoaded(surahList: surahList));
      else
        emit(ListSourateCubitStateListLoaded(
            surahList: surahList.reversed.toList()));
    } catch (e) {
      log(e.toString());
      emit(ListSourateCubitStateListFailed(
          error: "Erreur lors de la récupération des données."));
    }
  }
}

abstract class ListSourateCubitState {}

class ListSourateCubitStateListLoaded extends ListSourateCubitState {
  final List<Surah> surahList;
  ListSourateCubitStateListLoaded({required this.surahList});
}

class ListSourateCubitStateListInitial extends ListSourateCubitState {}

class ListSourateCubitStateListLoading extends ListSourateCubitState {}

class ListSourateCubitStateListFailed extends ListSourateCubitState {
  final String error;
  ListSourateCubitStateListFailed({required this.error});
}
