import 'package:elites_live/core/global/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../controller/live_controller.dart';

class VoteDetailsBottomSheet extends StatelessWidget {
  final LiveController controller;

  const VoteDetailsBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.closeVoteSheet(),
      child: GestureDetector(
        onTap: () {}, // Prevent closing when tapping on the sheet
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header with question
                Container(
                  margin:  EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextView("How Would You Rate My Singing?", fontSize: 14.sp,fontWeight: FontWeight.w500,textAlign: TextAlign.center,),

                      GestureDetector(
                        onTap: () => controller.closeVoteSheet(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey.shade700,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: Colors.grey.shade200),

                // Poll options with progress bars
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Obx(() {
                    final poll = controller.currentPoll.value;
                    if (poll == null) return const SizedBox.shrink();

                    final totalVotes = controller.totalPollVotes;
                    return Column(
                        children: List.generate(poll.options.length, (index) {
                          final option = poll.options[index];
                          final voteCount = controller.voteDetails
                              .where((v) => v.selectedOptionIndex == index)
                              .length;
                          final percentage = totalVotes > 0
                              ? (voteCount / totalVotes) * 100
                              : 0;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () {
                                if (controller.currentPoll.value?.hasVoted != true) {
                                  controller.selectPollOption(index);
                                  controller.submitVote();
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          option.text,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          height: 10,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.grey.shade200,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: percentage.toInt(),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    gradient: LinearGradient(
                                                      colors: _getGradientColors(index),
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 100 - percentage.toInt(),
                                                child: Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${percentage.toStringAsFixed(0)}% ($voteCount ${voteCount == 1 ? 'vote' : 'votes'})',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }));
                  }),
                ),

                // Vote button
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed: controller.currentPoll.value?.hasVoted == true
                          ? null
                          : () {
                        if (controller.selectedPollOption.value != null) {
                          controller.submitVote();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: controller.currentPoll.value?.hasVoted == true
                            ? Colors.grey
                            : Colors.purple,
                      ),
                      child: Text(
                        controller.currentPoll.value?.hasVoted == true
                            ? 'Voted'
                            : 'Vote',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(int index) {
    final baseColors = [
      [AppColors.secondaryColor, AppColors.primaryColor],
      [AppColors.secondaryColor, AppColors.primaryColor],
      [AppColors.secondaryColor, AppColors.primaryColor],
    ];
    return baseColors[index % baseColors.length];
  }
}