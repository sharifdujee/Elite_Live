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
              () =>
              AlertDialog(
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
                              ...controller.poolList
                                  .asMap()
                                  .entries
                                  .map((pollEntry) {
                                final pollIndex = pollEntry.key;
                                final poll = pollEntry.value;

                                // Initialize checked options for this poll if not exists
                                controller.initializeCheckedOptions(
                                    pollIndex, poll.options.length);

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[50],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        poll.question,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.black87),
                                      ),
                                      const SizedBox(height: 8),
                                      // Remove inner Obx - parent Obx will rebuild this
                                      Column(
                                        children: poll.options
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int optionIdx = entry.key;
                                          String option = entry.value;

                                          return CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(option),
                                            value: controller.getCheckedValue(
                                                pollIndex, optionIdx),
                                            onChanged: (val) {
                                              controller.setCheckedValue(
                                                  pollIndex, optionIdx,
                                                  val ?? false);
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller.updatePool(
                                                  poll.id, streamId);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius
                                                    .circular(6),
                                              ),
                                              child: const Text(
                                                "Update",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight
                                                        .w500),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              controller.deletePool(
                                                  poll.id, streamId);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius
                                                    .circular(6),
                                              ),
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight
                                                        .w500),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
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
                        // Options list already wrapped in parent Obx
                        Column(
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
                                    onTap: () => controller.removeOption(index),
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
                                  border: Border.all(
                                      color: Colors.purple, width: 2),
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
                        const SizedBox(height: 12),

                        // See Result Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Close current dialog and show results
                              Get.back();
                              ///PollResultsDialog.show(context, streamId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.bar_chart, color: Colors.white,
                                    size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "See Results",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
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

  static void _showAddOptionField(BuildContext context,
      CreatePollController controller) {
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



/*class PollResultsDialog {
  static void show(BuildContext context, String streamId) {
    final controller = Get.find<CreatePollController>();

    // Fetch all poll results
    for (var poll in controller.poolList) {
      controller.getPoolVoteResult(poll.id);
    }

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
                          "Poll Results",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black54,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Display results for each poll
                    if (controller.poolList.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.poll_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No polls available",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...controller.poolList.map((poll) {
                        final voteResult = controller.getVoteResultForPoll(poll.id);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade50,
                                Colors.blue.shade50,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.purple.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question
                              Text(
                                voteResult?.question ?? poll.question,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Total votes
                              if (voteResult != null)
                                Text(
                                  "Total Votes: ${_calculateTotalVotes(voteResult)}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              const SizedBox(height: 16),

                              // Options with vote counts and percentages
                              if (voteResult == null)
                              // Loading or no data
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.purple,
                                    ),
                                  ),
                                )
                              else
                                ...voteResult.options.map((option) {
                                  final totalVotes = _calculateTotalVotes(voteResult);
                                  final percentage = totalVotes > 0
                                      ? (option.votes / totalVotes * 100)
                                      : 0.0;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Option text and vote count
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                option.text,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${option.votes} votes",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.purple.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),

                                        // Progress bar
                                        Stack(
                                          children: [
                                            // Background
                                            Container(
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                            ),
                                            // Foreground (progress)
                                            FractionallySizedBox(
                                              widthFactor: percentage / 100,
                                              child: Container(
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.purple.shade400,
                                                      Colors.blue.shade400,
                                                    ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                              ),
                                            ),
                                            // Percentage text
                                            Container(
                                              height: 28,
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text(
                                                "${percentage.toStringAsFixed(1)}%",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: percentage > 50
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Calculate total votes for a poll
  static int _calculateTotalVotes(PoolVoteResult voteResult) {
    return voteResult.options.fold(0, (sum, option) => sum + option.votes);
  }
}*/
