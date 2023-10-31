import 'package:flutter_danelya9/userpage.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'apifit.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class Apifit {
  factory Apifit(Dio dio, {String baseUrl}) = _Apifit;

  @GET("/posts")
  Future<List<Post>> fetchPostsFromApi();
}
