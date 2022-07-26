// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../data/models/surah.dart';

abstract class DisplayPageState extends Equatable {
  const DisplayPageState();

  @override
  List<Object> get props => [];
}

class DisplayPageInitial extends DisplayPageState {}

class DisplayPageLoading extends DisplayPageState {}

class DisplayPageLoaded extends DisplayPageState {
  final int page;
  final List<dynamic> pageDatas;
  final int count;
  final List<Surah> sourates;

  DisplayPageLoaded(
      {required this.page,
      required this.pageDatas,
      required this.count,
      required this.sourates});
}

class DisplayPageFailed extends DisplayPageState {
  final String error;
  DisplayPageFailed({required this.error});
}
