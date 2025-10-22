
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/live_controller.dart';


class PollBottomSheet extends StatelessWidget {
  final LiveController controller;

  const PollBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.closePollSheet(),
      child: Container(
        color: Colors.black54,
        child: GestureDetector(
          onTap: () {},
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Center(child: CustomTextView("Pools", fontWeight: FontWeight.w600,fontSize: 16.sp,color: AppColors.textHeader,)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                          decoration: BoxDecoration(

                            color: Color(0xFF94A3B8),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: GestureDetector(
                            onTap: () => controller.closePollSheet(),
                            child: Icon(
                              Icons.close,

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),



                   Container(
                     margin: EdgeInsets.symmetric(horizontal: 20.w),
                       child: Divider(height: 1)),
                  SizedBox(height: 24.h,),





                  /// Poll Content
                  Obx(() {
                    final poll = controller.currentPoll.value;
                    if (poll == null) return const SizedBox.shrink();

                    final totalVotes = controller.totalPollVotes;
                    final hasVoted = poll.hasVoted;

                    return Container(
                      margin:  EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: CustomTextView(poll.question, fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.textHeader,textAlign: TextAlign.center,)),
                          SizedBox(height: 10.h),
                          Divider(height: 1),

                           SizedBox(height: 20.h),
                          CustomTextView("Options", fontWeight: FontWeight.w500,fontSize: 14.sp,color: AppColors.textHeader,),

                          const SizedBox(height: 12),

                          // Poll Options
                          ...List.generate(
                            poll.options.length,
                                (index) => Obx(() => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: hasVoted
                                    ? null
                                    : () => controller.selectPollOption(index),
                                child: Stack(
                                  children: [
                                    // Background progress bar (only show if voted)
                                    if (hasVoted)
                                      FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: poll.options[index]
                                            .getPercentage(totalVotes) /
                                            100.w,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                            color: poll.selectedOptionIndex == index
                                                ? Colors.purple.withValues(alpha: 0.3)
                                                : Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                    // Option content
                                    Row(
                                      children: [
                                        // Radio button or checkmark
                                        Container(
                                          width: 20.w,
                                          height: 20.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: hasVoted &&
                                                poll.selectedOptionIndex == index
                                                ? Colors.purple
                                                : !hasVoted &&
                                                controller.selectedPollOption
                                                    .value ==
                                                    index
                                                ? AppColors.primaryColor
                                                : Colors.white,
                                            border: Border.all(
                                              color: hasVoted &&
                                                  poll.selectedOptionIndex == index
                                                  ? AppColors.primaryColor
                                                  : !hasVoted &&
                                                  controller.selectedPollOption
                                                      .value ==
                                                      index
                                                  ? Colors.purple
                                                  : Colors.grey.shade400,
                                              width: 2,
                                            ),
                                          ),
                                          child: (hasVoted &&
                                              poll.selectedOptionIndex == index) ||
                                              (!hasVoted &&
                                                  controller.selectedPollOption
                                                      .value ==
                                                      index)
                                              ? const Icon(
                                            Icons.circle,
                                            size: 10,
                                            color: Colors.white,
                                          )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: CustomTextView(poll.options[index].text, fontWeight: controller
                                              .selectedPollOption
                                              .value ==
                                              index ||
                                              poll.selectedOptionIndex == index
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          fontSize: 14.sp,),


                                        ),
                                        // Show percentage if voted
                                        if (hasVoted) ...[
                                          const SizedBox(width: 8),
                                          Text(
                                            '${poll.options[index].getPercentage(totalVotes).toStringAsFixed(0)}%',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: poll.selectedOptionIndex == index
                                                  ? Colors.purple
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ),

                          // Total votes display
                          if (hasVoted) ...[
                            const SizedBox(height: 8),
                            Text(
                              '$totalVotes total votes',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          // Submit Button (only show if not voted)
                          if (!hasVoted)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: controller.selectedPollOption.value != null
                                    ? () => controller.submitVote()
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  disabledBackgroundColor: Colors.grey.shade300,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}