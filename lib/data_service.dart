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
