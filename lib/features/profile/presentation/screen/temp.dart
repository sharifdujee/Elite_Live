//
// import 'package:google_fonts/google_fonts.dart';

// import '../../controller/edit_profile_controller.dart';
//
// class EditProfilePage extends StatelessWidget {
//   const EditProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(EditProfileController());
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   height: 190.h,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     gradient: AppColors.primaryGradient,
//                   ),
//                 ),
//                 Positioned(
//                   top: 50.h,
//                   left: 20.w,
//                   child:     Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () => Get.back(),
//                         child: const Icon(Icons.arrow_back,color: Colors.white,),
//                       ),
//                       SizedBox(width: 20.w),
//                       Text('Edit Profile',
//                         style: GoogleFonts.inter(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 160.h),
//                   padding: EdgeInsets.symmetric(horizontal: 25.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(24.r),
//                       topRight: Radius.circular(24.r),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       //write code here
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//
//
// }
