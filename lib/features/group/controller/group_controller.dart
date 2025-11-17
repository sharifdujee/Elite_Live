import 'dart:developer';

import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:elites_live/features/group/data/discoverGroup_data_model.dart';
import 'package:get/get.dart';

class GroupController extends GetxController{
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  RxList<DiscoverGroupResult> discoverGroupList = <DiscoverGroupResult>[].obs;


  var isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    discoverGroup();
  }

  Future<void> discoverGroup() async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("the token during discover group $token");

    try {
      var response = await networkCaller.getRequest(AppUrls.discoverGroup, token: token);

      if (response.isSuccess) {
        log("the api response is ${response.responseData}");

        final data = response.responseData;

        // Handle both possible response types: Map or List
        if (data is Map<String, dynamic>) {
          // If wrapped inside an object with "result"
          if (data.containsKey("result") && data["result"] is List) {
            final List<dynamic> resultList = data["result"];
            discoverGroupList.assignAll(
              resultList.map((x) => DiscoverGroupResult.fromJson(x)).toList(),
            );
          } else {
            log("Unexpected Map format in API response: $data");
          }
        } else if (data is List) {
          // If API directly returns a list of groups
          discoverGroupList.assignAll(
            data.map((x) => DiscoverGroupResult.fromJson(x)).toList(),
          );
        } else {
          log("Unexpected data type in API response: ${data.runtimeType}");
        }
      } else {
        log("API call failed with message: ${response.errorMessage}");
      }
    } catch (e) {
      log("the exception is ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  List<String> groupName = ["Gaming", "Dancing Club", "Study Group 2", "Study Group 2", "Study Group 2"];
  List<String> memberList = ["50", "24", "10", "20", "12"];
  List<String> groupPicture = [ImagePath.gaming, ImagePath.dance, ImagePath.study, ImagePath.study, ImagePath.study];
  List<String> userPicture = [ImagePath.user, ImagePath.one, ImagePath.three, ImagePath.two, ImagePath.one];
  List<String> userName = ["Jane Cooper", "Theresa Webb", "Annette Black", "Robert Fox", "Albert Flores"];
  List<String> userDescription = ["Restaurant Owner", "Actress", "Student", "Singer", "Biker"];
}