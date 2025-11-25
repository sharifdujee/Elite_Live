import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/services/socket_service.dart';
import 'package:get/get.dart';

class AddContributorController extends GetxController{
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  final WebSocketClientService webSocketClientService = WebSocketClientService();
}