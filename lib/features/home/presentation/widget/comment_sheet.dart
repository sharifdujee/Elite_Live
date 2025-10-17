

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../data/comment_data_model.dart';
  // assuming you use _buildCommentTile as a separate widget

class CommentSheet extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final TextEditingController commentController = TextEditingController();
  final RxString replyingToId = ''.obs;
  final RxString replyingToName = ''.obs;

  CommentSheet({super.key});

  void show(BuildContext context) {
    Get.bottomSheet(
      this,
      isScrollControlled: true,
    );
  }

  Widget _buildCommentTile(Comment comment) {
    return GestureDetector(
      onTap: () {
        replyingToId.value = comment.id;
        replyingToName.value = comment.userName;
      },
      child: ListTile(
        title: Text(comment.userName),
        subtitle: Text(comment.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => replyingToId.value.isNotEmpty
                    ? Text(
                  "Replying to ${replyingToName.value}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                )
                    : const SizedBox.shrink()),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Comments List
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.comments.length,
              itemBuilder: (context, index) {
                final comment = controller.comments[index];
                return _buildCommentTile(comment);
              },
            )),
          ),

          // Comment Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Type a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {
                    // TODO: Add emoji picker and append emoji to commentController.text
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () {
                    // TODO: Open image picker and send comment with image
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (commentController.text.trim().isNotEmpty) {
                      controller.submitComment(
                        commentController.text.trim(),
                        replyToId: replyingToId.value.isNotEmpty ? replyingToId.value : null,
                      );
                      commentController.clear();
                      replyingToId.value = '';
                      replyingToName.value = '';
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
