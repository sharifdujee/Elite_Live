import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/global/custom_appbar.dart';
import '../../../../core/global/custom_date_time_dialog.dart';
import '../../../../core/global/custom_date_time_field.dart';
import '../../../../core/global/custom_dropdown.dart';
import '../../../../core/global/custom_elevated_button.dart';
import '../../../../core/global/custom_text_field.dart';
import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/validation/email_validation.dart';
import '../../../../core/validation/name_validation.dart';
import '../../../../core/validation/phone_number_validation.dart';
import '../../controller/set_up_profile_controller.dart';


import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
    );
  }
}

