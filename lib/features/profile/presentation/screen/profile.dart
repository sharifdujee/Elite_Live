
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utility/icon_path.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../routes/app_routing.dart';
import '../../controller/profile_controller.dart';

import '../widget/userNameProfessionSection.dart';
import '../widget/user_profile_section.dart';

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
            /// Top header + profile image
            Stack(
              children: [
                /// Yellow background with curved white container
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
                          child: Image.asset(IconPath.setting,height: 24.h, width: 24.w,)),
                    ],
                  ),
                ),
                /// White section with rounded corners
                UserNameProfessionSection(),

                ///
                /// 
                /// Profile Image + edit image
                UserProfilePictureSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }







}







