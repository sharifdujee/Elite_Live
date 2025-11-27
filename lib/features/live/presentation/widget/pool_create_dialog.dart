import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/create_pool_controller.dart';
import '../../data/pool_data_model.dart';
import '../../data/pool_vote_data_model.dart';








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
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.clearCheckedStates();
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
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...controller.poolList.asMap().entries.map((pollEntry) {
                            final pollIndex = pollEntry.key;
                            final poll = pollEntry.value;

                            // Initialize checked options for this poll
                            controller.initializeCheckedOptions(
                              pollIndex,
                              poll.options.length,
                            );

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
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Options with checkboxes
                                  Column(
                                    children: poll.options
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int optionIdx = entry.key;
                                      String option = entry.value;

                                      return CheckboxListTile(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        title: Text(
                                          option,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        value: controller.getCheckedValue(
                                          pollIndex,
                                          optionIdx,
                                        ),
                                        onChanged: (val) {
                                          controller.setCheckedValue(
                                            pollIndex,
                                            optionIdx,
                                            val ?? false,
                                          );
                                        },
                                        activeColor: Colors.purple,
                                      );
                                    }).toList(),
                                  ),

                                  const SizedBox(height: 8),

                                  // Action buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Vote Button
                                      GestureDetector(
                                        onTap: () {
                                          final selectedOptions = controller.getSelectedOptions(
                                            pollIndex,
                                            poll.options,
                                          );

                                          if (selectedOptions.isEmpty) {
                                            Get.snackbar(
                                              "Info",
                                              "Please select at least one option to vote",
                                              snackPosition: SnackPosition.BOTTOM,
                                            );
                                            return;
                                          }

                                          controller.votePool(
                                            poll.id,
                                            streamId,
                                            selectedOptions,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            "Vote",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Edit Button
                                      GestureDetector(
                                        onTap: () {
                                          _showEditPollDialog(
                                            context,
                                            controller,
                                            poll,
                                            streamId,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            "Edit",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Delete Button
                                      GestureDetector(
                                        onTap: () {
                                          _showDeleteConfirmation(
                                            context,
                                            controller,
                                            poll.id,
                                            streamId,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
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
                        color: Colors.black87,
                      ),
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
                          borderSide: const BorderSide(
                            color: Colors.purple,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // New Poll Options
                    const Text(
                      "Options",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: controller.options.asMap().entries.map((entry) {
                        int index = entry.key;
                        String option = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
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
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.createPool(streamId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // See Result Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          PollResultsDialog.show(context, streamId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.bar_chart, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "See Results",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
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
    ).then((_) {
      controller.clearCheckedStates();
      Get.delete<CreatePollController>();
    });
  }

  // Show edit dialog for existing poll
  static void _showEditPollDialog(
      BuildContext context,
      CreatePollController controller,
      PoolResult poll,
      String streamId,
      ) {
    final editQuestionController = TextEditingController(text: poll.question);
    final RxList<String> editOptions = RxList<String>.from(poll.options);
    final editOptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Edit Poll",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Question", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: editQuestionController,
                  decoration: InputDecoration(
                    hintText: "Enter question",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Options", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Obx(
                      () => Column(
                    children: editOptions.asMap().entries.map((entry) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(entry.value)),
                            GestureDetector(
                              onTap: () => editOptions.removeAt(entry.key),
                              child: const Icon(Icons.close, size: 18),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: editOptionController,
                  decoration: InputDecoration(
                    hintText: "Add new option",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (editOptionController.text.trim().isNotEmpty) {
                          editOptions.add(editOptionController.text.trim());
                          editOptionController.clear();
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      editOptions.add(value.trim());
                      editOptionController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.updatePool(
                  poll.id,
                  streamId,
                  editQuestionController.text.trim(),
                  editOptions.toList(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // Show delete confirmation
  static void _showDeleteConfirmation(
      BuildContext context,
      CreatePollController controller,
      String pollId,
      String streamId,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Delete Poll"),
          content: const Text("Are you sure you want to delete this poll?"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                controller.deletePool(pollId, streamId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  static void _showAddOptionField(
      BuildContext context,
      CreatePollController controller,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Add Option",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
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
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.addOption(controller.newOptionController.text.trim());
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}



class PollResultsDialog {
  static void show(BuildContext context, String streamId) {
    final controller = Get.find<CreatePollController>();

    // Fetch poll results using stream ID
    controller.getPoolVoteResultByStream(streamId); // ✅ Pass streamId directly

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
                                      ? (option.voters.length / totalVotes * 100)
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
                                                option.option,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${option.count} vote${option.count != 1 ? 's' : ''}",
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
    return voteResult.options.fold(0, (sum, option) => sum + option.voters.length);
  }
}
