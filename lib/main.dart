import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feature/quran/data/repositories/sourate_list_repo.dart';
import 'feature/quran/presentation/bussiness_logic/cubit/list_sourate_cubit.dart';
import 'feature/quran/presentation/screens/sourate_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forqan',
      theme: ThemeData(
        primaryColor: Colors.cyanAccent,
      ),
      home: RepositoryProvider(
        create: (context) => SourateListRepo(),
        child: BlocProvider(
          create: (context) =>
              ListSourateCubit(sourateListRepo: context.read<SourateListRepo>())
                ..getSourateList(isReverse: false),
          child: SourateList(),
        ),
      ),
    );
  }
}
