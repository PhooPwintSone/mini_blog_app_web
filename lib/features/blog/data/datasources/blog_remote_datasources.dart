import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:image_picker/image_picker.dart';

abstract interface class BlogRemoteDatasources {
  //upload whole blog
  Future<BlogModel> uploadBlog(BlogModel blog);

  //upload Image
  Future<String> uploadBlogImage({
    required XFile image,
    required BlogModel blog,
  });
  //Calling all of the blogs
  Future<List<BlogModel>> getAllBlogs({int? page});

  //delete feature
  Future<void> deleteBlog({required String blogId, required String imageUrl});
  //edit feature
  Future<BlogModel> editBlog(BlogModel blog);

  //for edit
  Future<String> uploadEditBlogImage({
    required XFile image,
    required String blogId,
  });
}
