import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/data/api/article_api.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({super.key});

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final contentController = TextEditingController();
  final imageUrlController = TextEditingController();
  final tagController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    contentController.dispose();
    imageUrlController.dispose();
    tagController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary700),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.primary700, width: 2),
      ),
    );
  }

  Future<void> submitArticle() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final content = contentController.text.trim();
    final imageUrl = imageUrlController.text.trim();
    final tag = tagController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề và nội dung')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final articleApi = ArticleApi();

      await articleApi.createArticle({
        "title": title,
        "description": description,
        "content": content,
        "imageUrl": imageUrl,
        "author": "Người dùng",
        "topic_id": 1,
        "tags": tag.isEmpty ? [] : [tag],
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thêm bài viết thành công")),
      );

      context.go(PageRoutes.articles);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi thêm bài viết: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF4F8FB),
        centerTitle: true,
        title: const Text(
          'Thêm bài viết',
          style: TextStyle(
            color: AppColors.primary800,
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0A6C86),
                    Color(0xFF8FD6E8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary700.withOpacity(0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.edit_note_rounded, color: Colors.white, size: 44),
                  SizedBox(height: 12),
                  Text(
                    'Chia sẻ bài viết tích cực',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lan tỏa kiến thức và câu chuyện giúp mọi người chăm sóc sức khỏe tinh thần tốt hơn.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: inputDecoration(
                      label: 'Tiêu đề bài viết',
                      icon: Icons.title_rounded,
                      hint: 'Ví dụ: Cách vượt qua căng thẳng mỗi ngày',
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration: inputDecoration(
                      label: 'Mô tả ngắn',
                      icon: Icons.short_text_rounded,
                      hint: 'Tóm tắt nội dung chính của bài viết',
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: contentController,
                    maxLines: 7,
                    decoration: inputDecoration(
                      label: 'Nội dung bài viết',
                      icon: Icons.article_outlined,
                      hint: 'Nhập nội dung chia sẻ của bạn...',
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: imageUrlController,
                    decoration: inputDecoration(
                      label: 'Link ảnh bài viết',
                      icon: Icons.image_outlined,
                      hint: 'Dán link ảnh .jpg, .png hoặc link ảnh trực tiếp',
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: tagController,
                    decoration: inputDecoration(
                      label: 'Chủ đề / tag',
                      icon: Icons.local_offer_outlined,
                      hint: 'Ví dụ: Trầm cảm, Lo âu, Kỹ năng sống',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : submitArticle,
                icon: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.cloud_upload_rounded, color: Colors.white),
                label: Text(
                  isLoading ? 'Đang đăng bài...' : 'Đăng bài viết',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary700,
                  disabledBackgroundColor: AppColors.primary700.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:frontend/core/themes/app_colors.dart';
// import 'package:frontend/data/api/article_api.dart';
// import 'package:frontend/routing/page_routes.dart';
// import 'package:go_router/go_router.dart';

// class AddArticleScreen extends StatefulWidget {
//   const AddArticleScreen({super.key});

//   @override
//   State<AddArticleScreen> createState() => _AddArticleScreenState();
// }

// class _AddArticleScreenState extends State<AddArticleScreen> {
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final contentController = TextEditingController();
//   final imageUrlController = TextEditingController();
//   final tagController = TextEditingController();

//   @override
//   void dispose() {
//     titleController.dispose();
//     descriptionController.dispose();
//     contentController.dispose();
//     imageUrlController.dispose();
//     tagController.dispose();
//     super.dispose();
//   }

//   Future<void> submitArticle() async {
//     final title = titleController.text.trim();
//     final description = descriptionController.text.trim();
//     final content = contentController.text.trim();
//     final imageUrl = imageUrlController.text.trim();
//     final tag = tagController.text.trim();

//     if (title.isEmpty || content.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Vui lòng nhập tiêu đề và nội dung'),
//         ),
//       );
//       return;
//     }

//     try {
//       final articleApi = ArticleApi();

//       final response = await articleApi.createArticle({
//         "title": title,
//         "description": description,
//         "content": content,
//         "imageUrl": imageUrl,
//         "author": "Người dùng",
//         "topic_id": 1,
//         "tags": tag.isEmpty ? [] : [tag],
//       });

//       print("CREATE ARTICLE RESPONSE: $response");

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Thêm bài viết thành công"),
//         ),
//       );

//       context.go(PageRoutes.articles);
//     } catch (e) {
//       print("CREATE ARTICLE ERROR: $e");

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Lỗi thêm bài viết: $e"),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Thêm bài viết'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(
//                 labelText: 'Tiêu đề bài viết',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             TextField(
//               controller: descriptionController,
//               maxLines: 2,
//               decoration: const InputDecoration(
//                 labelText: 'Mô tả ngắn',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             TextField(
//               controller: contentController,
//               maxLines: 6,
//               decoration: const InputDecoration(
//                 labelText: 'Nội dung bài viết',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             TextField(
//               controller: imageUrlController,
//               decoration: const InputDecoration(
//                 labelText: 'Link ảnh bài viết',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             TextField(
//               controller: tagController,
//               decoration: const InputDecoration(
//                 labelText: 'Chủ đề / tag',
//                 hintText: 'Ví dụ: Trầm cảm, Lo âu',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 24),

//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 onPressed: submitArticle,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary700,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child: const Text(
//                   'Đăng bài viết',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

