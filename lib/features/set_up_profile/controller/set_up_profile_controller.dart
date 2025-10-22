import 'dart:io';

import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/global_widget/controller/custom_date_time_dialogue.dart';
import '../../../core/global_widget/custom_text_view.dart';
import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/route/app_route.dart';
import '../../../core/utility/icon_path.dart';
import '../../../routes/app_routing.dart';

class SetUpProfileController extends GetxController {
  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();
  RxBool isLoading = false.obs;
  var selectedGender = RxnString();

  void setSelectedGender(String? value) {
    selectedGender.value = value;
  }

  var selectedProfession = RxnString();

  void setSelectedProfession(String? value) {
    selectedProfession.value = value;
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  CustomDateTimeController dateTimeController = Get.find();
  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  Future<void> onInit() async {
    await preferencesHelper.init();
    super.onInit();
  }

  Future<void> pickFromStorage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      selectedImage.value = File(result.files.single.path!);
    }
  }

  void showSuccessDialogue() {
    Get.dialog(
      Dialog(
        child: Container(
          padding: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                IconPath.success,
                fit: BoxFit.cover,
                width: 100.w,
                height: 150.h,
              ),
              SizedBox(height: 20.h),
              CustomTextView(
                ' Profile Created Successfully',
                fontSize: 24,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              SizedBox(height: 8.h),
              CustomTextView(
                'Welcome, Shamim Islam! Your profile is now ready. Start exploring and make the most out of your experience.',
                textAlign: TextAlign.center,
                fontSize: 14,
                color: Color(0xff636F85),
              ),
              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  ontap: () {
                    Get.back();
                    Get.offAllNamed(AppRoute.mainView);
                  },
                  text: "Next",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
