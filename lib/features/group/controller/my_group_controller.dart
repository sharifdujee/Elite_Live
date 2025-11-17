import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/services/network_caller/repository/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../data/joined_group_data_model.dart';

class MyGroupController extends GetxController {
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  RxList<JoinedGroupResultResult> joinedGroupList =
      <JoinedGroupResultResult>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    joinedGroup();
    super.onInit();
  }

  Future<void> joinedGroup() async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("the token during fetch my joined group $token");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.joinedGroup,
        token: token,
      );

      if (response.isSuccess) {
        log("the api response is ${response.responseData}");

        if (response.responseData is List) {
          joinedGroupList.assignAll(
            (response.responseData as List)
                .map(
                  (item) => JoinedGroupResultResult.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList(),
          );

          log("Successfully loaded ${joinedGroupList.length} groups");
        } else if (response.responseData is Map<String, dynamic>) {
          final myGroup = JoinedGroupDataModel.fromJson(response.responseData);
          joinedGroupList.assignAll(myGroup.result);

          log("Successfully loaded ${joinedGroupList.length} groups");
        } else {
          log("Unexpected response type: ${response.responseData.runtimeType}");
        }
      }
    } catch (e, stackTrace) {
      log("the exception is ${e.toString()}");
      log("Stack trace: $stackTrace");
    } finally {
      isLoading.value = false;
    }
  }
}
