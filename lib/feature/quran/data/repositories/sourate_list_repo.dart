import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/surah.dart';

class SourateListRepo {
  late List<Surah> surahList = [];
  Map<int, Surah> surahMap = {};
  Future<List<Surah>> readSourateListJson() async {
    final String response = await rootBundle.loadString('assets/surah.json');
    final data = await json.decode(response);
    for (var item in data["chapters"]) {
      surahList.add(Surah.fromJson(item));
    }
    debugPrint(surahList.length.toString());
    return surahList;
  }
}
