import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'feature/quran/data/repositories/sourate_list_repo.dart';
import 'feature/quran/presentation/bussiness_logic/bloc/bloc_display_page/display_page_bloc.dart';
import 'feature/quran/presentation/bussiness_logic/bloc/bloc_display_page/display_page_state.dart';
import 'feature/quran/presentation/bussiness_logic/cubit/list_sourate_cubit.dart';
import 'feature/quran/presentation/screens/sourate_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () => runApp(
      MyApp(),
    ),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SourateListRepo(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ListSourateCubit(
                sourateListRepo: context.read<SourateListRepo>())
              ..getSourateList(isReverse: false),
          ),
          BlocProvider(
            create: (context) => DisplayPageBloc(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Forqan',
          theme: ThemeData(
            primaryColor: Colors.cyanAccent,
          ),
          home: BlocBuilder<DisplayPageBloc, DisplayPageState>(
            builder: (context, state) {
              print(state);
              if (state is DisplayPageLoaded) {
                log("Loaded");
              } else if (state is DisplayPageInitial) {
                log("Initial state triggered");
              }
              return SourateList();
            },
          ),
        ),
      ),
    );
  }
}
