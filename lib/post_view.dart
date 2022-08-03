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
