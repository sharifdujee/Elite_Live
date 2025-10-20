import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:get/get.dart';

class GroupController extends GetxController{
  var isLoading = false.obs;
  List<String> groupName = ["Gaming", "Dancing Club", "Study Group 2", "Study Group 2", "Study Group 2"];
  List<String> memberList = ["50", "24", "10", "20", "12"];
  List<String> groupPicture = [ImagePath.gaming, ImagePath.dance, ImagePath.study, ImagePath.study, ImagePath.study];
  List<String> userPicture = [ImagePath.user, ImagePath.one, ImagePath.three, ImagePath.two, ImagePath.one];
  List<String> userName = ["Jane Cooper", "Theresa Webb", "Annette Black", "Robert Fox", "Albert Flores"];
  List<String> userDescription = ["Restaurant Owner", "Actress", "Student", "Singer", "Biker"];
}