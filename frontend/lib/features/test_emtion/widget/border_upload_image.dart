import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/features/test_emtion/controller/test_emotion_controller.dart';
import 'package:frontend/features/test_emtion/widget/dotted_border.dart';
import 'package:frontend/features/test_emtion/widget/image_preview.dart';
import 'package:image_field/image_field.dart';
import 'package:provider/provider.dart';

class BorderUploadImage extends StatefulWidget {
  const BorderUploadImage({super.key});

  @override
  State<BorderUploadImage> createState() => _BorderUploadImageState();
}

class _BorderUploadImageState extends State<BorderUploadImage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TestEmotionController>(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DottedBorderContainer(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Icon(Icons.image_outlined, size: 40),
                      const SizedBox(height: 16),
                      const Text(
                        'Tải hình ảnh',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Vui lòng tải lên ít nhất 5 ảnh (${controller.remoteFiles.length}/5)',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.primary800,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned.fill(
                  child: Opacity(
                    opacity: 0,
                    child: SizedBox(
                      width: double.infinity,
                      child: Transform.scale(
                        scale: 5,
                        alignment: Alignment.topCenter,
                        child: ImageField(
                          onUpload:
                              (
                                pickedFile,
                                controllerLinearProgressIndicator,
                              ) async {},
                          onSave: controller.loadImage,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (controller.remoteFiles.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  controller.remoteFiles
                      .map<Widget>(
                        (img) => buildImagePreview(
                          img,
                          () => controller.deleteImage(img),
                        ),
                      )
                      .toList(),
            ),
        ],
      ),
    );
  }
}
