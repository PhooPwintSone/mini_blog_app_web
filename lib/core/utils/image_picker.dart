import 'package:blog_app/core/error/exception.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickerImage() async {
  try {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1080,
    );

    if (imageFile != null) {
      return XFile(imageFile.path);
    }

    return null;
  } catch (e) {
    throw ServerException(message: e.toString());
  }
}
