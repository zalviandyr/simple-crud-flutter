import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:simple_crud/blocs/blocs.dart';
import 'package:simple_crud/screens/screens.dart';
import 'package:simple_crud/services/services.dart';

void main() {
  // init api
  API.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SiswaBloc()),
      ],
      child: GetMaterialApp(
        title: 'Simple Crud',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
