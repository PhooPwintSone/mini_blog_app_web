import 'package:blog_app/features/blog/data/datasources/blog_local_datasource.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:hive_ce/hive.dart';

class BlogLocalDatasourceImpl implements BlogLocalDatasource {
  final Box box;

  BlogLocalDatasourceImpl({required this.box});

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];

    // In Hive CE, reads are direct and synchronous - no need for box.read()
    for (int i = 0; i < box.length; i++) {
      final blogData = box.get(i.toString());
      if (blogData != null) {
        blogs.add(BlogModel.fromJson(Map<String, dynamic>.from(blogData)));
      }
    }

    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    // Clear old data
    box.clear();

    // In Hive CE, you can put items directly without a box.write() wrapper.
    // Using a Map and putAll() is faster because it saves all items in a single transaction.
    final Map<String, dynamic> blogMap = {};
    for (int i = 0; i < blogs.length; i++) {
      blogMap[i.toString()] = blogs[i].toJson();
    }

    box.putAll(blogMap);
  }
}
