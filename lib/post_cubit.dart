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

