import 'package:elites_live/core/global/custom_text_view.dart';
import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LiveScreenController extends GetxController {
  var isCameraOn = true.obs;
  var isMicOn = true.obs;
  var isScreenSharing = false.obs;
  var showMenu = false.obs;
  var viewerCount = 234.obs;

  void toggleCamera() {
    isCameraOn.value = !isCameraOn.value;
  }

  void toggleMic() {
    isMicOn.value = !isMicOn.value;
  }

  void toggleScreenShare() {
    isScreenSharing.value = !isScreenSharing.value;
    showMenu.value = false;
  }

  void toggleMenu() {
    showMenu.value = !showMenu.value;
  }


  void closeMenu() {
    showMenu.value = false;
  }

  void addContributor() {
    showMenu.value = false;
    Get.snackbar(
      'Add Contributor',
      'Opening contributor selection...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void openComments() {
    showMenu.value = false;
    Get.snackbar(
      'Comments',
      'Opening comments section...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void openPolls() {
    showMenu.value = false;
    Get.snackbar(
      'Polls',
      'Opening polls...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void endCall(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomTextView("End Session", fontSize: 18.sp,fontWeight: FontWeight.w600,color: AppColors.textHeader,textAlign: TextAlign.center,),
          content: CustomTextView("Are you sure you want to end this live session?", fontWeight: FontWeight.w400,fontSize: 14.sp,color: AppColors.textBody,textAlign: TextAlign.center,),

          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: CustomElevatedButton(ontap: (){
                  Get.back();
                }, text: "Cancel")),
                SizedBox(width: 8.w,),
                Expanded(child: CustomElevatedButton(ontap: (){
                  Navigator.of(context).pop(); // Closes the dialog
                  Navigator.of(context).pop();
                }, text: "End"))

              ],
            ),


          ],
        );
      },
    );
  }

  void goBack(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomTextView("Leave Live Session", fontSize: 18.sp,fontWeight: FontWeight.w600,color: AppColors.textHeader,textAlign: TextAlign.center,),
          ///Text(''),
          content: CustomTextView("Are you sure you want to leave this live session?", fontWeight: FontWeight.w400,fontSize: 14.sp,color: AppColors.textBody,textAlign: TextAlign.center,),
          ///Text(''),
          actions: <Widget>[
            Row(
              children: [
                Expanded(child: CustomElevatedButton(ontap: (){
                  Get.back();
                }, text: "Cancel")),
                SizedBox(width: 8.w,),
                Expanded(child: CustomElevatedButton(ontap: (){
                  Get.back();
                  Get.back();

                }, text: "Leave"))

              ],
            ),


          ],
        );
      },
    );
  }
}