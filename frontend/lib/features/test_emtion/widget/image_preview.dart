import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:image_field/image_field.dart';

Widget buildImagePreview(ImageAndCaptionModel img, VoidCallback? actionClose) {
  final file = img.file;

  Widget imageWidget;

  if (file is File) {
    imageWidget = Image.file(
      file,
      width: 101,
      height: 101,
      fit: BoxFit.cover,
    );
  } else if (file is XFile) {
    imageWidget = Image.file(
      File(file.path),
      width: 101,
      height: 101,
      fit: BoxFit.cover,
    );
  } else if (file is Uint8List) {
    imageWidget = Image.memory(
      file,
      width: 101,
      height: 101,
      fit: BoxFit.cover,
    );
  } else {
    return const SizedBox();
  }

  return SizedBox(
    width: 101,
    height: 101,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 101,
            height: 101,
            child: imageWidget,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: actionClose,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}