import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class QrImageStorage {
  static const int _maxDimension = 1024;
  static const int _jpegQuality = 88;

  Future<String> saveCompressedImage(XFile source) async {
    final originalBytes = await source.readAsBytes();
    final compressedBytes = await compute(_compressImage, originalBytes);

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final qrDirectory = Directory(p.join(documentsDirectory.path, 'qr_codes'));
    await qrDirectory.create(recursive: true);

    final filePath = p.join(
      qrDirectory.path,
      'qr_${DateTime.now().microsecondsSinceEpoch}.jpg',
    );
    await File(filePath).writeAsBytes(compressedBytes, flush: true);
    return filePath;
  }

  Future<void> deleteImage(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) await file.delete();
  }

  static Uint8List _compressImage(Uint8List bytes) {
    final decodedImage = image.decodeImage(bytes);
    if (decodedImage == null) {
      throw const FormatException('Selected file is not a supported image.');
    }

    final largestDimension = math.max(decodedImage.width, decodedImage.height);
    final resizedImage = largestDimension > _maxDimension
        ? image.copyResize(
            decodedImage,
            width: decodedImage.width >= decodedImage.height
                ? _maxDimension
                : null,
            height: decodedImage.height > decodedImage.width
                ? _maxDimension
                : null,
          )
        : decodedImage;

    return Uint8List.fromList(
      image.encodeJpg(resizedImage, quality: _jpegQuality),
    );
  }
}
