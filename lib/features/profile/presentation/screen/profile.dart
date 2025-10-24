import 'package:elites_live/features/profile/presentation/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global_widget/custombuttonwhite.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../routes/app_routing.dart';
import '../../controller/profile_controller.dart';
import '../widget/profile_tab_widget.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor, // Yellow background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header + profile image
            Stack(
              children: [
                //* Yellow background with curved white container
                Container(
                  height: 190.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  child: Row(

                    children: [
                      Text("Profile", style: GoogleFonts.inter(
                          fontWeight:FontWeight.w600,
                          fontSize: 20.sp
                      ),),
                        SizedBox(width: 240.w,),
                      InkWell(
                          onTap: (){
                          Get.toNamed(AppRoute.settings);
                          },
                          child: Image.asset("assets/icons/settings.png",height: 24.h, width: 24.w,)),
                    ],
                  ),
                ),
                // White section with rounded corners
                Container(
                  margin: EdgeInsets.only(top: 160.h),
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 60.h), // for profile image overlap
                      Text(
                        'Jolie Topley',
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      Text(
                        'Professional Model',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF636F85),
                        ),
                      ),
                      SizedBox(height: 24.h),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text("468k",style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Color(0xff191919),
                              ),),

                              Text("Followers",style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: AppColors.textColor,
                              ),)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0,right: 24),
                            child: Container(height: 46.h, width: 1.w, color: Color(0xFFF0F0F0)),
                          ),

                          Column(
                            children: [
                              Text("356",style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Color(0xff191919),
                              ),),

                              Text("Following",style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: AppColors.textColor,
                              ),)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0,right: 24),
                            child: Container(height: 46.h, width: 1.w, color: Color(0xFFF0F0F0)),
                          ),


                          Column(
                            children: [
                              Text("200",style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Color(0xff191919),
                              ),),

                              Text("Posts",style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: AppColors.textColor,
                              ),)
                            ],
                          ),

                        ],
                      ),
                      SizedBox(height: 24.h,),
                      CustomButtonWhite(
                        text:'Edit Profile',
                      onPressed: (){
                          Get.toNamed(AppRoute.edit_profile);
                      },
                      ),
                      SizedBox(height: 15.h),

                      ProfileTabsWidget(),

                     // SizedBox(height: 200.h),

                    ],
                  ),
                ),

                //* Profile Image + edit image
                Positioned(
                  top: 100.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundImage: AssetImage('assets/images/profile_image.jpg'),
                        ),
                        Positioned(
                          bottom: -3,
                          right: 3,
                          child: Image.asset(
                            'assets/icons/edit_profile.png',
                            width: 27.w,
                            height: 27.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget infoTile(String iconPath, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(iconPath, height: 24.h, width: 24.w),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF636F85)
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h,),
          Container(height: 1.5.h, width: 310, color: Color(0xFFF8F8FB),),
        ],
      ),
    );
  }


  Widget settingTile(
      String iconPath,
      String title, {
        Color color = AppColors.bgColor,
        Color textColor = Colors.black,
        VoidCallback? onTap,
        bool showArrow = false,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(iconPath, height: 20.h, width: 20.w, color: color),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ),
                if (showArrow)
                  Icon(Icons.arrow_forward_ios, size: 20.sp, color: Colors.grey),
              ],
            ),
            SizedBox(height: 15.h,),
            Container(height: 1.5.h, width: 310, color: Color(0xFFF8F8FB),),
          ],
        ),
      ),
    );
  }


}
