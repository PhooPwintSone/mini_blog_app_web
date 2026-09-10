// ignore_for_file: public_member_api_docs, sort_constructors_first
class Blog {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> categories;
  final DateTime updatedAt;
  final String userName;

  Blog({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.categories,
    required this.updatedAt,
    required this.userName,
  });
}
