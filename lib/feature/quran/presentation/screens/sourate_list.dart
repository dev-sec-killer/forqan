import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forqan/feature/quran/presentation/screens/DisplayPage.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../data/models/surah.dart';
import '../bussiness_logic/cubit/list_sourate_cubit.dart';
import 'reading_page.dart';

class SourateList extends StatelessWidget {
  int selectedIndex = 0;
  bool isReverse = false;
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Transform.rotate(
          angle: isReverse ? pi : 2 * pi,
          child: IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                isReverse = !isReverse;
                context
                    .read<ListSourateCubit>()
                    .getSourateList(isReverse: isReverse);
              }),
        ),
        // actions: [
        //   IconButton(
        //       color: Colors.amber, onPressed: () {}, icon: Icon(Icons.pages))
        // ],
      ),
      body: BlocBuilder<ListSourateCubit, ListSourateCubitState>(
        builder: (context, state) {
          if (state is ListSourateCubitStateListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ListSourateCubitStateListFailed) {
            return ErrorScreen(
              error: state.error,
            );
          } else if (state is ListSourateCubitStateListLoaded) {
            return chaptersList(state.surahList);
          }
          return ErrorScreen(
            error: "Erreur lors de la chargement des données",
          );
        },
      ),
    );
  }

  Widget chaptersList(List<Surah> chapters) {
    return ListView.separated(
      controller: _controller,
      itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            child: Text(chapters[index].id.toString()),
          ),
          title: Text(chapters[index].name),
          subtitle: Text(chapters[index].versesCount.toString()),
          trailing: Text(
            chapters[index].arabicName,
            style: GoogleFonts.cairo(
              fontSize: 18,
            ),
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      DisplayPage(surah: chapters[index], sourates: chapters
                          //isReverse ? chapters : chapters.reversed.toList()
                          )))
          // Navigator.push(
          //   context,
          //   MaterialPageRoute<void>(
          //     builder: (BuildContext context) =>
          //         SurahPage(surah: chapters[index]),
          //   ),
          // ),
          ),
      separatorBuilder: (context, index) => Divider(height: 1),
      itemCount: chapters.length,
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
