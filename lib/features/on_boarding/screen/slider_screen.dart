import 'package:carousel_slider/carousel_slider.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utility/app_colors.dart';
import '../../../../core/utility/image_path.dart';
import '../controller/slider_controller.dart';

class SliderScreen extends StatelessWidget {
  SliderScreen({super.key});

  final SliderController controller = Get.find();
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<Map<String, String>> carouselData = [
    {
      "image": ImagePath.slider1,
      "text": "Go Live Instantly",
      "subText":
          "Start your live stream in seconds and connect with your audience in real time — simple and seamless.",
    },
    {
      "image": ImagePath.slider2,
      "text": "Engage & Interact",
      "subText":
          "Chat, send reactions, and build your community while streaming. Make every moment interactive and fun.",
    },
    {
      "image": ImagePath.slider3,
      "text": "Share Your World",
      "subText":
          "Stream anytime, anywhere — showcase your talents, stories, or passions to viewers across the globe.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                controller.completeOnBoarding();
              },
              child: CustomTextView("Skip",color: const Color(0xFF191919),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400),
            ),
            FloatingActionButton(
              onPressed: () async {
                if (controller.currentIndex.value < carouselData.length - 1) {
                  _carouselController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else {
                  controller.completeOnBoarding();
                }
              },
              backgroundColor: AppColors.primaryColor,
              shape: CircleBorder(),
              child: Icon(
                Icons.arrow_right_alt_outlined,
                color: Colors.white,
                size: 30.r,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: carouselData.length,
                options: CarouselOptions(
                  height: screenHeight, // Increased height to fit content
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    controller.updatePage(index);
                  },
                ),
                itemBuilder: (context, index, realIdx) {
                  final data = carouselData[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 80.h),
                        Image.asset(
                          data['image'] ?? 'assets/placeholder.png',
                          height: screenHeight * 0.4,
                          fit: BoxFit.contain,
                          // Changed to contain to avoid distortion
                          errorBuilder:
                              (context, error, stackTrace) => Icon(Icons.error),
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.3,
                          padding: EdgeInsets.all(20.r),
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          // Added margin for better spacing
                          decoration: BoxDecoration(
                            color: Colors.white, // White background
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // Let content dictate size
                            children: [
                              SizedBox(height: 20.h),
                              Text(
                                data['text'] ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 24.sp,
                                  color: Color(0xff2D2D2D),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                data['subText'] ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  color: Color(0xff636F85),
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                              SizedBox(height: 10.h),
                              Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(carouselData.length, (
                                    i,
                                  ) {
                                    final isActive =
                                        controller.currentIndex.value == i;
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                      ),
                                      height: 8.h,
                                      // Slightly larger for visibility
                                      width: isActive ? 24.w : 8.w,
                                      decoration: BoxDecoration(
                                        color:
                                            isActive
                                                ? AppColors.primaryColor
                                                : AppColors.primaryLightColor,
                                        borderRadius: BorderRadius.circular(
                                          5.r,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
