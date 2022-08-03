import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_d14_bloc_and_cubit/post_cubit.dart';
import 'package:flutter_d14_bloc_and_cubit/post_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //type 2
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>(create: (context) => PostBloc()..add(LoadPostEvent()))
        ],
        child: PostView(),
      ),
    );
    //type 1
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<PostCubit>(create: (context) => PostCubit()..getPost())
        ],
        child: PostView(),
      ),
    );
  }
}
