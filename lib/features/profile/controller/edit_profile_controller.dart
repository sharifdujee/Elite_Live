import 'dart:convert';
import 'dart:developer';

import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/profile/controller/profile_controller.dart';
import 'package:elites_live/features/profile/presentation/screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/global/custom_elevated_button.dart';
import '../../../core/global/custom_text_view.dart';
import '../../../core/global_widget/controller/custom_date_time_dialogue.dart';
import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/utility/app_urls.dart';
import '../../../core/utility/icon_path.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:http_parser/http_parser.dart';

class EditProfileController extends GetxController {
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime(2004, 2, 12));
  final TextEditingController professionController = TextEditingController();
  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();
  final ProfileController controller = Get.find();
  RxBool isLoading = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  var selectedGender = RxnString();
  final ImagePicker _picker = ImagePicker();

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

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
        preferredCameraDevice: CameraDevice.front,
      );

      if (image != null) {
        // Validate file extension
        String extension = image.path.split('.').last.toLowerCase();
        if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
          Get.snackbar(
            "Error",
            "Unsupported image format. Please use JPG, PNG, or WEBP",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          return;
        }

        selectedImage.value = File(image.path);
        log("Image selected from camera: ${image.path}");
        log("Image size: ${await File(image.path).length()} bytes");

        // Automatically upload after selection
        await updateProfilePicture();
      }
    } catch (e) {
      log("Error picking image from camera: $e");
      Get.snackbar(
        "Error",
        "Failed to capture image from camera",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        // Validate file extension
        String extension = image.path.split('.').last.toLowerCase();
        if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
          Get.snackbar(
            "Error",
            "Unsupported image format. Please use JPG, PNG, or WEBP",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          return;
        }

        selectedImage.value = File(image.path);
        log("Image selected from gallery: ${image.path}");
        log("Image size: ${await File(image.path).length()} bytes");

        // Automatically upload after selection
        await updateProfilePicture();
      }
    } catch (e) {
      log("Error picking image from gallery: $e");
      Get.snackbar(
        "Error",
        "Failed to select image from gallery",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime(2004, 2, 12),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  void updateProfile() {
    Get.snackbar('Success', 'Profile Updated');
  }

  /// update profile
  Future<void> editProfile() async {
    if (addressController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Address is required",
        backgroundColor: AppColors.redColor,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    try {
      isLoading.value = true;
      String? userToken = preferencesHelper.getString('userToken');
      log("the user token is $userToken");

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
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(AppUrls.setUpProfile),
      );
      request.headers.addAll({'Authorization': userToken});

      if (selectedProfession.value != null &&
          selectedProfession.value!.isNotEmpty) {
        request.fields['profession'] = selectedProfession.value!;
      }

      if (bioController.text.isNotEmpty) {
        request.fields['bio'] = bioController.text.trim();
      }

      if (selectedGender.value != null) {
        request.fields['gender'] = selectedGender.value!.capitalizeFirst!;
      }

      if (dateController.text.isNotEmpty) {
        try {
          DateTime parsedDate = DateTime.parse(dateController.text);
          DateTime dobWithTime = DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            0,
            0,
            0,
            0,
          );
          request.fields['dob'] = dobWithTime.toUtc().toIso8601String();
        } catch (e) {
          log("Error parsing date: $e");
          request.fields['dob'] = dateController.text;
        }
      }

      if (addressController.text.isNotEmpty) {
        request.fields['address'] = addressController.text.trim();
      }

      log("Sending request to: ${AppUrls.setUpProfile}");
      log("Request fields: ${request.fields}");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);

        Get.snackbar(
          "Success",
          responseData['message'] ?? "Profile setup completed successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        showSuccessDialogue();
      } else {
        var errorMessage =
            "Failed to setup profile. Status: ${response.statusCode}";
        try {
          var errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (e) {
          log("Error parsing error response: $e");
        }

        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      log("The exception is ${e.toString()}");
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
                'Profile Updated Successfully',
                fontSize: 24,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  ontap: () {
                    controller.getMyProfile();
                    Get.back();
                    Get.to(() => ProfilePage());
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

  /// update profile picture
  Future<void> updateProfilePicture() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        "Error",
        "Please select an image first",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;
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

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(AppUrls.setUpProfile),
      );

      request.headers.addAll({'Authorization': userToken});

      if (selectedImage.value != null) {
        // Get file extension
        String filePath = selectedImage.value!.path;
        String extension = filePath.split('.').last.toLowerCase();

        // Determine content type based on extension
        String contentType;
        switch (extension) {
          case 'jpg':
          case 'jpeg':
            contentType = 'image/jpeg';
            break;
          case 'png':
            contentType = 'image/png';
            break;
          case 'gif':
            contentType = 'image/gif';
            break;
          case 'webp':
            contentType = 'image/webp';
            break;
          default:
            contentType = 'image/jpeg'; // Default fallback
        }

        log("File path: $filePath");
        log("File extension: $extension");
        log("Content type: $contentType");

        // Create multipart file with explicit content type
        var file = await http.MultipartFile.fromPath(
          'profileImage',
          selectedImage.value!.path,
          contentType: MediaType(
            'image',
            extension == 'jpg' ? 'jpeg' : extension,
          ),
        );

        request.files.add(file);

        log("File name: ${file.filename}");
        log("File content type: ${file.contentType}");
      }

      log("Sending request to: ${AppUrls.setUpProfile}");
      log("Request files: ${request.files.length}");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);

        Get.snackbar(
          "Success",
          responseData['message'] ?? "Profile picture updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Refresh profile to show updated image
        await controller.getMyProfile();

        // Clear selected image after successful upload
        selectedImage.value = null;
      } else {
        var errorMessage =
            "Failed to update profile picture. Status: ${response.statusCode}";
        try {
          var errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (e) {
          log("Error parsing error response: $e");
        }

        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      log("Error in updateProfilePicture: $e");
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

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    professionController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    bioController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
