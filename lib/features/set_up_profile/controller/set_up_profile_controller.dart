import 'dart:developer';
import 'dart:io';

import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/global_widget/controller/custom_date_time_dialogue.dart';
import '../../../core/global_widget/custom_text_view.dart';
import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/utility/app_urls.dart';
import '../../../core/utility/icon_path.dart';
import '../../../routes/app_routing.dart';

import 'package:http/http.dart' as http;

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

  Future<void> setupProfile() async {
    // Validate required fields
    if (firstNameController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "First name is required",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (lastNameController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Last name is required",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (selectedGender.value == null || selectedGender.value!.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select gender",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Get FCM token
      String fcmToken = preferencesHelper.getString("fcmToken") ?? "";

      // Get user token for authorization
      String? userToken = preferencesHelper.getString("userToken");
      log("The user token is $userToken");

      if (userToken == null || userToken.isEmpty) {
        Get.snackbar(
          "Error",
          "User token not found. Please login again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        isLoading.value = false;
        return;
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(AppUrls.setUpProfile),
      );

      // Add headers
      request.headers.addAll({'Authorization': userToken});

      // Add form fields
      request.fields['firstName'] = firstNameController.text.trim();
      request.fields['lastName'] = lastNameController.text.trim();
      request.fields['fcmToken'] = fcmToken;

      if (selectedProfession.value != null &&
          selectedProfession.value!.isNotEmpty) {
        request.fields['profession'] = selectedProfession.value!;
      }

      if (bioController.text.isNotEmpty) {
        request.fields['bio'] = bioController.text.trim();
      }

      if (phoneController.text.isNotEmpty) {
        request.fields['phoneNumber'] = phoneController.text.trim();
      }

      if (selectedGender.value != null) {
        request.fields['gender'] = selectedGender.value!;
      }

      if (dateController.text.isNotEmpty) {
        // Convert date to ISO 8601 format with time
        try {
          DateTime parsedDate = DateTime.parse(dateController.text);
          // Add time component and convert to ISO 8601 format
          DateTime dobWithTime = DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            0,
            0,
            0,
            0, // Set time to midnight
          );
          request.fields['dob'] = dobWithTime.toUtc().toIso8601String();
        } catch (e) {
          log("Error parsing date: $e");
          // If parsing fails, send the original format
          request.fields['dob'] = dateController.text;
        }
      }

      if (addressController.text.isNotEmpty) {
        request.fields['address'] = addressController.text.trim();
      }

      // Add profile image if selected
      if (selectedImage.value != null) {
        var file = await http.MultipartFile.fromPath(
          'profileImage',
          selectedImage.value!.path,
        );
        request.files.add(file);
      }

      log("Sending request to: ${AppUrls.setUpProfile}");
      log("Request fields: ${request.fields}");

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      // FIXED: Only show success dialogue if API call is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update setup status in preferences
        await preferencesHelper.setBool("isSetup", true);

        // Show success snackbar
        Get.snackbar(
          "Success",
          "Profile setup completed successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Show success dialogue ONLY on successful API response
        showSuccessDialogue();
      } else {
        // Show error if status code is not 200/201
        Get.snackbar(
          "Error",
          "Failed to setup profile. Status: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // FIXED: Don't show success dialogue on error
      log("Error in setupProfile: $e");
      Get.snackbar(
        "Error",
        "Something went wrong: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showSuccessDialogue() {
    Get.dialog(
      barrierDismissible: false,
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
                'Profile Created Successfully',
                fontSize: 24,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              SizedBox(height: 8.h),
              CustomTextView(
                'Welcome, ${firstNameController.text} ${lastNameController.text}! Your profile is now ready. Start exploring and make the most out of your experience.',
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

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    bioController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
