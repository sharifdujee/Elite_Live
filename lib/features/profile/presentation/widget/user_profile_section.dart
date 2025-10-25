
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utility/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';

class UserProfilePictureSection extends StatelessWidget {
  const UserProfilePictureSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100.h,
      left: 0,
      right: 0,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundImage: AssetImage(ImagePath.user),
            ),
            Positioned(
              bottom: -3,
              right: 3,
              child: Image.asset(
                IconPath.edit,
                width: 27.w,
                height: 27.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}