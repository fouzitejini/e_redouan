// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:get_storage/get_storage.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

import "package:firebase/firebase.dart" as fb;

class AddObject {
  static Future<Uint8List?> pickImage() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

    return bytesFromPicker;
  }

  static Future<void> uploadImageToFirebase(Uint8List image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference =
        storage.ref().child('images/${DateTime.now().toString()}');

    UploadTask uploadTask = storageReference.putData(image);
    await uploadTask.whenComplete(() => print('Image uploaded successfully'));

    String downloadURL = await storageReference.getDownloadURL();
    print('Download URL: $downloadURL');
  }

  static Future<String> uploadImageToStorage() async {
    MediaInfo mediaInfo = await _imagePicker();
    String? imageName = mediaInfo.fileName;
    String? imageUrl;
    await _uploadFile(mediaInfo, 'ImagesFiles', imageName!.split(".").first)
        .then((value) => imageUrl = value.toString());

    return imageUrl!;
  }

  static Future<MediaInfo> _imagePicker() async {
    MediaInfo? mediaInfo = await ImagePickerWeb.getImageInfo;
    return mediaInfo!;
  }

  static Future<Uri?> _uploadFile(
      MediaInfo mediaInfo, String ref, String fileName) async {
    try {
      String? mimeType = mime(p.basename(mediaInfo.fileName!));
      final String? extension = extensionFromMime(mimeType!);
      var metadata = fb.UploadMetadata(
        contentType: mimeType,
      );

      fb.StorageReference storageReference =
          fb.storage().ref(ref).child("$fileName.$extension");

      var uploadTaskSnapshot =
          await storageReference.put(mediaInfo.data, metadata).future;
      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      return imageUri;
    } catch (e) {
      return null;
    }
  }

  static deleteFromStorage(String fileName) async {
    fb.StorageReference storage =
        fb.storage().ref("ImagesFiles").child(fileName);
    storage.delete();
  }
}









 final box = GetStorage();