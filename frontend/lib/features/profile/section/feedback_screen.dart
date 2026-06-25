import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/uitls/format.dart';
import 'package:frontend/features/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProfileController>(context);

    return Scaffold(
      backgroundColor: AppColors.greyscale0,
      appBar: AppBar(
        backgroundColor: AppColors.greyscale0,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Gửi phản hồi',
          style: TextStyle(
            color: AppColors.greyscale800,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.greyscale800,
            size: 22,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chúng tôi muốn nghe ý kiến từ bạn!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Hãy cho chúng tôi biết chúng tôi có thể làm'
                ' gì để cải thiện trải nghiệm của bạn.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  controller: controller.feedbackController,
                  validator:
                      (value) => validateText(
                        context,
                        value,
                        'Vui lòng nhập ý kiến của bạn',
                      ),
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText: 'Nhập ý kiến phản hồi của bạn tại đây...',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyscale400,
                      fontSize: 18,
                    ),
                    contentPadding: EdgeInsets.all(16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => controller.sendFeedbackEmail(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      controller.isSending
                          ? const CircularProgressIndicator(
                            color: AppColors.greyscale0,
                          )
                          : const Text(
                            'GỬI',
                            style: TextStyle(
                              color: AppColors.greyscale0,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
