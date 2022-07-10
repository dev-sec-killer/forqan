import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;

import '../../data/models/surah.dart';

class DisplayPage extends StatelessWidget {
  final Surah surah;
  final List<Surah> sourates;
  late final int page;

  DisplayPage({required this.surah, required this.sourates}) {
    page = quran.getSurahPages(this.surah.id).first;
  }
  List<dynamic> pageDatas = [];
  int count = 0;
  @override
  Widget build(BuildContext context) {
    pageDatas = quran.getPageData(page);
    count = pageDatas.length;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          minimum: EdgeInsets.all(15),
          child: ListView(children: [
            Column(
              children: [
                ...pageDatas.map((pageData) {
                  return Column(
                    children: [
                      pageData['start'] == 1
                          ? Padding(
                              padding: EdgeInsets.all(5),
                              child: header(sourateId: pageData['surah']),
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: [
                            for (var i = pageData['start'];
                                i <= pageData['end'];
                                i++) ...{
                              TextSpan(
                                text: ' ' +
                                    quran.getVerse(pageData['surah'], i,
                                        verseEndSymbol: true) +
                                    ' ',
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 25,
                                  color: Colors.black87,
                                ),
                              ),
                              WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: CircleAvatar(
                                    child: Text(
                                      '$i',
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      textScaleFactor:
                                          i.toString().length <= 2 ? 1 : .8,
                                    ),
                                    radius: 14,
                                  ))
                            }
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                Text(
                  quran.getVerse(18, 3, verseEndSymbol: true),
                  style: TextStyle(
                    fontFamily: 'Lateef',
                    fontSize: 25,
                    color: Colors.black87,
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget header({required int sourateId}) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text(
        //   // "Name sourate",
        //   surah.arabicName,
        //   style: TextStyle(
        //     //fontFamily: 'Aldhabi',
        //     fontFamily: 'Kitab',
        //     fontSize: 36,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        SourateCard(
            sourate: sourates
                .firstWhere((element) => element.id == sourateId)
                .arabicName),
        Text(
          ' ' + quran.basmala + ' ',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            //fontFamily: 'NotoNastaliqUrdu',
            fontFamily: 'Kitab',
            fontSize: 24,
          ),
        ),
      ],
    ));
  }
}

class SourateCard extends StatelessWidget {
  const SourateCard({Key? key, required this.sourate}) : super(key: key);

  final String sourate;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipPath(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border(
              right:
                  BorderSide(color: Theme.of(context).primaryColor, width: 5),
            ),
          ),
          child: Text(
            sourate,
            textAlign: TextAlign.center,
            style: TextStyle(
              //fontFamily: 'Aldhabi',
              fontFamily: 'Kitab',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        clipper: ShapeBorderClipper(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
      ),
    );
  }
}
