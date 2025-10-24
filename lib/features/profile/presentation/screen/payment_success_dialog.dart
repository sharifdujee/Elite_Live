import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../main_view/presentation/screen/main_view_screen.dart';
import '../../controller/logout_controller.dart';


void paymentSuccessBottomSheet(BuildContext context) {
  Get.bottomSheet(
    SuccessBottomSheet(),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(44.r)),
    ),
    isDismissible: true,
  );
}

class SuccessBottomSheet extends StatelessWidget {
  final LogoutController controller = Get.put(LogoutController());
  SuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
Padding(
  padding: const EdgeInsets.all(8.0),
  child: Center(child: Image.asset("assets/icons/Success.png",height: 100, width: 100,)),
),
          SizedBox(height: 15.h),
          Text("Payment Successful",
            style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D2D2D),
            ),
          ),
          SizedBox(height: 8.h),
          Text("Your payment has been done\nsuccessfully.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xFF2D2D2D),
            ),
          ),
          SizedBox(height: 50.h),
         CustomElevatedButton(ontap: (){Get.to(()=> MainViewScreen());}, text: "Done"),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
