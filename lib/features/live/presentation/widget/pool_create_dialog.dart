import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/create_pool_controller.dart';

import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/create_pool_controller.dart';

class CreatePollDialog {
  static void show(BuildContext context, String streamId) {
    final controller = Get.put(CreatePollController());
    Future.microtask(() => controller.getPool(streamId));

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Obx(
              () => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(20),
            backgroundColor: Colors.white,
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Create Polls",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            Get.delete<CreatePollController>();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black54,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Existing Polls
                    if (controller.poolList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Existing Polls",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          ...controller.poolList.map((poll) {
                            // Track checked options
                            RxList<bool> checkedOptions =
                                List.generate(poll.options.length, (_) => false).obs;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[50],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    poll.question,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black87),
                                  ),
                                  const SizedBox(height: 8),
                                  Obx(
                                        () => Column(
                                      children: poll.options
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int idx = entry.key;
                                        String option = entry.value;
                                        return CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(option),
                                          value: checkedOptions[idx],
                                          onChanged: (val) {
                                            checkedOptions[idx] = val ?? false;
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // controller.prepareUpdatePoll(poll);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            "Update",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          // controller.deletePoll(poll.id, streamId);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 20),
                        ],
                      ),

                    // New Poll Question
                    const Text(
                      "Question",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.questionController,
                      decoration: InputDecoration(
                        hintText: "What's your poll about?",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          const BorderSide(color: Colors.purple, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // New Poll Options
                    const Text(
                      "Options",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                          () => Column(
                        children: controller.options
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          String option = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      controller.removeOption(index),
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Add Option Button
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        _showAddOptionField(context, controller);
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.purple, width: 2),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Add option",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.purple,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.createPool(streamId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) => Get.delete<CreatePollController>());
  }

  static void _showAddOptionField(
      BuildContext context, CreatePollController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: CustomTextView(
            text: "Add Option",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          content: TextField(
            controller: controller.newOptionController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter option",
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.purple, width: 2),
              ),
            ),
            onSubmitted: (value) {
              controller.addOption(value);
              Get.back();
            },
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () {
                      Get.back();
                    },
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 8.h),
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () {
                      controller.addOption(
                          controller.newOptionController.text.trim());
                      Get.back();
                    },
                    text: "Add",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

