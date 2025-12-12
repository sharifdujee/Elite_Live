import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/socket_service.dart';

import '../presentation/widget/contributor_request_dialog.dart';

class GlobalWebSocketHandler extends GetxService {
  final WebSocketClientService webSocketService = WebSocketClientService.to;

  @override
  void onInit() {
    super.onInit();
    _setupGlobalListener();
  }

  void _setupGlobalListener() {
    webSocketService.setOnContributionRequest((data) {
      log("🌍 Global handler received contribution request");
      _handleContributionRequest(data);
    });
  }

  void _handleContributionRequest(Map<String, dynamic> data) {
    try {
      final from = data['from'] as Map<String, dynamic>;
      final String fromUserId = from['id'] ?? '';
      final String firstName = from['firstName'] ?? '';
      final String lastName = from['lastName'] ?? '';
      final String fromUserName = '$firstName $lastName';
      final String? fromUserImage = from['profileImage'];
      final String? fromUserProfession = from['profession'];
      final String coHostLink = data['link'] ?? '';
      final String streamId = data['streamId'] ?? '';

      log("👤 Global: Invitation from: $fromUserName");
      log("🔗 Global: Co-Host Link: $coHostLink");
      log("📺 Global: Stream ID: $streamId");

      // Get current context
      final BuildContext? context = Get.context;
      if (context == null) {
        log("❌ No context available to show dialog");
        return;
      }

      // Show the contribution request dialog
      ContributorRequestDialog.show(
        onAccepted: (){
          log("🎉 User accepted co-host invitation from global handler");

        },
        context,
        fromUserId: fromUserId,
        fromUserName: fromUserName,
        fromUserImage: fromUserImage,
        fromUserProfession: fromUserProfession,
        coHostLink: coHostLink,
        streamId: streamId,
        webSocketService: webSocketService,
      );
    } catch (e) {
      log("❌ Error in global handler: $e");
    }
  }
}