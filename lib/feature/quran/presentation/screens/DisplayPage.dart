import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forqan/feature/quran/core/enum.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../../data/models/surah.dart';
import '../bussiness_logic/bloc/bloc_display_page/display_page_bloc.dart';

class DisplayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DisplayPageBloc, DisplayPageState>(
      listener: (context, state) {
        if (state is DisplayPageFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              state.error,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ));
        }
      },
      child: BlocBuilder<DisplayPageBloc, DisplayPageState>(
        builder: (context, state) {
          if (state is DisplayPageLoaded) {
            return SimpleGestureDetector(
              onHorizontalSwipe: (direction) {
                if (direction == SwipeDirection.left) {
                  context.read<DisplayPageBloc>().add(DisplayPageSwipe(
                      page: state.page,
                      sourates: state.sourates,
                      swipeDirection: SwipeDirectionEnum.left));
                  print('Swiped left!');
                } else {
                  context.read<DisplayPageBloc>().add(DisplayPageSwipe(
                      page: state.page,
                      sourates: state.sourates,
                      swipeDirection: SwipeDirectionEnum.right));
                  print('Swiped right!');
                }
              },
              swipeConfig: SimpleSwipeConfig(
                verticalThreshold: 40.0,
                horizontalThreshold: 40.0,
                swipeDetectionBehavior:
                    SwipeDetectionBehavior.continuousDistinct,
              ),
              child: quranPage(
                  pageDatas: state.pageDatas,
                  count: state.count,
                  sourates: state.sourates),
            );
          }
          if (state is DisplayPageLoading) {
            return CircularProgressIndicator();
          }
          return Center(
            child: Text(
              "Erreur lors de la chargement de la page .",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
        },
      ),
    );
  }

  Directionality quranPage(
      {required int count,
      required List pageDatas,
      required List<Surah> sourates}) {
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
                              child: header(
                                  sourateId: pageData['surah'],
                                  sourates: sourates),
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
                                      // textDirection: TextDirection.rtl,
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
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget header({required int sourateId, required List<Surah> sourates}) {
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
