import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/global/custom_appbar.dart';
import '../../../../../core/global/custom_date_time_dialog.dart';
import '../../../../../core/global/custom_date_time_field.dart';
import '../../../../../core/global/custom_dropdown.dart';
import '../../../../../core/global/custom_elevated_button.dart';
import '../../../../../core/global/custom_text_field.dart';
import '../../../../../core/global/custom_text_view.dart';
import '../../../../../core/validation/email_validation.dart';
import '../../../../../core/validation/name_validation.dart';
import '../../../../../core/validation/phone_number_validation.dart';
import '../../../../set_up_profile/controller/set_up_profile_controller.dart';
import 'package:get/get.dart';

class SetUpProfileScreen extends StatelessWidget {
  SetUpProfileScreen({super.key});

  final SetUpProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Set Up Profile", lead: true, center: true),
      // Update your Save button in SetUpProfileScreen
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Obx(
              () => controller.isLoading.value
              ? Center(
            child: CircularProgressIndicator(),
          )
              : CustomElevatedButton(
            ontap: () {
              controller.setupProfile();
            },
            text: "Save",
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextView(
                  "First Name",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                hintText: "First Name",
                controller: controller.firstNameController,
                validator: validateName,
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextView(
                  "Last Name",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                hintText: "Last Name",
                controller: controller.lastNameController,
                validator: validateName,
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextView(
                  "Profession",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                    () => CustomDropDown(
                  hintText: "Select Profession",
                  items: ["Professional Model ", "Professional Model"],
                  selectedValue: controller.selectedProfession.value,
                  onChanged: (String? value) {
                    controller.setSelectedProfession(value);
                  },
                  textStyle: GoogleFonts.poppins(),
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextView(
                  "Bio",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                  hintText: "Enter bio",
                  controller: controller.bioController,
                  keyboardType: TextInputType.emailAddress
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextView(
                  "Email",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                hintText: "example@mail.com",
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextView(
                  "Phone",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                hintText: "+880 123456789",
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                validator: validatePhoneNumber,
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextView(
                  "Gender",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                    () => CustomDropDown(
                  hintText: "Select Gender",
                  items: ["MALE", "FEMALE"],
                  selectedValue: controller.selectedGender.value,
                  onChanged: (String? value) {
                    controller.setSelectedGender(value);
                  },
                  textStyle: GoogleFonts.poppins(),
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextView(
                  "Date of Birth",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              CustomDateOfBirthFiled(
                controller: controller.dateController,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CustomDatePicker(
                        selectedDateCallback: (DateTime selectedDate) {
                          controller.dateController.text = DateFormat(
                            'yyyy-MM-dd',
                          ).format(
                            controller.dateTimeController.selectedDate.value,
                          );
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextView(
                  "Address",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                hintText: "Type Your Address",
                controller: controller.addressController,
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}