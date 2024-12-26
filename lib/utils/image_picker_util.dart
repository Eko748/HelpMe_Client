import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../configs/app_colors.dart';

class ImagePickerUtil {
  final ImagePicker picker = ImagePicker();

  Future<XFile?> cameraCapture() async {
    try {
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.camera);
      if (pickedImage == null) {
        return null;
      }
      final CroppedFile? croppedImage = await cropImage(pickedImage);
      if (croppedImage == null) {
        return null;
      }
      final compressedImage = await compressImage(croppedImage);
      if (compressedImage == null) {
        return null;
      }
      return XFile(compressedImage.path, name: compressedImage.name);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<XFile?> imageFromGallery() async {
    try {
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        return null;
      }
      final CroppedFile? croppedImage = await cropImage(pickedImage);
      if (croppedImage == null) {
        return null;
      }
      final compressedImage = await compressImage(croppedImage);
      if (compressedImage == null) {
        return null;
      }
      return XFile(compressedImage.path, name: compressedImage.name);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<CroppedFile?> cropImage(XFile image) async {
    return await ImageCropper.platform.cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: image.name,
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: AppColors.lightTextColor,
          initAspectRatio: CropAspectRatioPreset.original,
          showCropGrid: true,
          backgroundColor: AppColors.surface,
          cropGridColor: AppColors.gray,
        ),
      ],
    );
  }

  Future<XFile?> compressImage(CroppedFile image) async {
    final tempDirectory = await getApplicationCacheDirectory();
    final targetPath = path.join(
      tempDirectory.path,
      '${path.basenameWithoutExtension(image.path)}_compress.jpg',
    );
    return await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      quality: 80,
    );
  }
}
