import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class ImagePickerController extends GetxController {
  RxList<File> selectedImages = <File>[].obs;

  Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickFromStorage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      selectedImage.value = File(result.files.single.path!);
    }
  }


  void clearImages() {
    selectedImage.value = null;
    selectedImages.clear();
  }
}
