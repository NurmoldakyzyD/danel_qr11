import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_danelya9/api.dart';
import 'package:flutter_danelya9/bloc/bloc_state.dart';
import 'package:flutter_danelya9/userpage.dart';

class PostCubit extends Cubit<PostState> {
  final ApiProvider apiProvider = ApiProvider();

  PostCubit() : super(PostInitial());

  void fetchPosts() async {
    emit(PostLoading());
    try {
      List<Post> posts = await apiProvider.fetchPostsFromApi();
      emit(PostLoaded(posts));
    } catch (error) {
      emit(PostError("Ошибка загрузки постов"));
    }
  }
}
