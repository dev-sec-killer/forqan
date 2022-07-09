import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/surah.dart';

class SourateListRepo {
  Future<List<Surah>> readSourateListJson() async {
    late List<Surah> surahList = [];
    final String response = await rootBundle.loadString('assets/surah.json');
    final data = await json.decode(response);
    for (var item in data["chapters"]) {
      surahList.add(Surah.fromMap(item));
    }
    debugPrint(surahList.length.toString());
    return surahList;
  }
}
