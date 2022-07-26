// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Surah {
  int id;
  String revelationPlace;
  int revelationOrder;
  String name;
  String arabicName;
  int versesCount;
  Surah({
    required this.arabicName,
    required this.id,
    required this.name,
    required this.revelationOrder,
    required this.revelationPlace,
    required this.versesCount,
  });
  Surah.fromJson(Map<String, dynamic> json)
      : arabicName = json["name_arabic"],
        id = json["id"],
        name = json["name_simple"],
        revelationOrder = json["revelation_order"],
        revelationPlace = json["revelation_place"],
        versesCount = json["verses_count"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'revelation_place': revelationPlace,
        'revelation_order': revelationOrder,
        'name': name,
        'arabic_name': arabicName,
        'verses_count': versesCount,
      };
}
