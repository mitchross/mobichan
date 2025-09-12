library image_gallery_saver;

import 'dart:typed_data';
import 'package:flutter/services.dart';

class ImageGallerySaver {
  static const MethodChannel _channel = MethodChannel('image_gallery_saver');

  static Future<dynamic> saveImage(Uint8List bytes, {String? name}) async {
    return await _channel.invokeMethod('saveImageToGallery', {
      'imageBytes': bytes,
      'name': name,
    });
  }
}
