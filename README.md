# flutter_d14_bloc_and_cubit

- data_service.dart
```dart
import 'dart:convert';
import 'package:flutter_d14_bloc_and_cubit/post.dart';
import 'package:http/http.dart' as http;

class DataService {
  final _baseUrl = 'jsonplaceholder.typicode.com';

  Future<List<Post>> getPosts() async {
    try {
      final uri = Uri.https(_baseUrl, '/posts');
      // final uri = Uri.https(_baseUrl, '/postz'); //error sengaja
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;
      final posts = json.map((postJson) => Post.fromJson(postJson)).toList();
      return posts;
    } on Error catch (e) {
      throw e;
    }
  }
}
```
- main.dart
```dart
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
```
- post.dart
```dart
class Post {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body']);
}
```
- post_cubit.dart
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_d14_bloc_and_cubit/data_service.dart';
import 'package:flutter_d14_bloc_and_cubit/post.dart';

//type 1
class PostCubit extends Cubit<List<Post>> {
  final _dataService = DataService();

  PostCubit() : super([]);

  void getPost() async {
    return emit(await _dataService.getPosts());
  }
}


//type 2
//event
abstract class PostEvent{}

class LoadPostEvent extends PostEvent{}

class PullToRefreshEvent extends PostEvent{}

//state
abstract class PostState{}

class LoadingPostState extends PostState{}

class LoadedPostState extends PostState{
  final List<Post> list;

  LoadedPostState(this.list);
}

class FailedToLoadPostState extends PostState{
  final Error exception;

  FailedToLoadPostState(this.exception);
}

//bloc
class PostBloc extends Bloc<PostEvent, PostState>{
  final _dataService = DataService();

  PostBloc() : super(LoadingPostState());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if(event is LoadPostEvent || event is PullToRefreshEvent){
      yield LoadingPostState();
      try{
        final res = await _dataService.getPosts();
        yield LoadedPostState(res);
      } on Error catch(e){
        yield FailedToLoadPostState(e);
      }
    }
  }
}

```
- post_view.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_d14_bloc_and_cubit/post.dart';
import 'package:flutter_d14_bloc_and_cubit/post_cubit.dart';

class PostView extends StatelessWidget {
  const PostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //type 2
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
        if (state is LoadingPostState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadedPostState) {
          return RefreshIndicator(
            onRefresh: () async {
              return BlocProvider.of<PostBloc>(context).add(PullToRefreshEvent());
            },
            child: ListView.builder(
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(state.list[index].title.toString()),
                    ),
                  );
                }),
          );
        } else if (state is FailedToLoadPostState) {
          return Center(
            child: Text('Error occured: ${state.exception.toString()}'),
          );
        } else {
          return Container();
        }
      }),
    );
    //type 1
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: BlocBuilder<PostCubit, List<Post>>(builder: (context, res) {
        if (res.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
            itemCount: res.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(res[index].title.toString()),
                ),
              );
            });
      }),
    );
  }
}
```

---

```
Copyright 2022 M. Fadli Zein
```