import 'package:blog_app/features/blog/data/models/blog_model.dart';

abstract interface class BlogLocalDatasource {
  void uploadLocalBlogs({required List<BlogModel> blogs});

  List<BlogModel> loadBlogs();
}
