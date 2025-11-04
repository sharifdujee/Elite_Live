import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/home_controller.dart';


class CommentInputBox extends StatelessWidget {
  final HomeController controller = Get.find();
  final RxString replyingToId = ''.obs;
  final RxString replyingToName = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final image = controller.commentImage.value;
          return image != null
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(image, height: 120),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => controller.commentImage.value = null,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 12,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
              : const SizedBox.shrink();
        }),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.commentController,
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
                onPressed: () => controller.toggleEmojiKeyboard(),
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(16),
                      height: 150.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.back();
                              controller.pickImage(ImageSource.camera);
                            },
                            icon: Icon(Icons.camera_alt),
                            label: CustomTextView("Camera", fontSize: 10.sp,fontWeight: FontWeight.w400,color: AppColors.textBody,),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.back();
                              controller.pickImage(ImageSource.gallery);
                            },
                            icon: Icon(Icons.photo_library),
                            label: CustomTextView("Gallery", fontSize: 10.sp,fontWeight: FontWeight.w400,color: AppColors.textBody,),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon:  Icon(Icons.send, color: AppColors.primaryColor),
                onPressed: () {
                  final text = controller.commentController.text.trim();
                  controller.submitComment(
                    text,
                    replyToId: replyingToId.value.isNotEmpty ? replyingToId.value : null,
                  );
                  replyingToId.value = '';
                  replyingToName.value = '';
                },
              ),
            ],
          ),
        ),

        // Emoji Picker
        Obx(() {
          if (!controller.isEmojiVisible.value) return const SizedBox.shrink();
          return SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  controller.commentController.text += emoji.emoji;
                },
                config: const Config(

                ),
              )

          );
        }),
      ],
    );
  }
}