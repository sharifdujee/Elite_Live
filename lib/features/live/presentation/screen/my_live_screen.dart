import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/socket_service.dart';
import 'package:elites_live/features/live/presentation/widget/contributor_dialog.dart';
import 'package:elites_live/features/live/presentation/widget/pool_create_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import '../../controller/live_screen_controller.dart';
import '../../../../core/utils/constants/app_colors.dart';

class MyLiveScreen extends StatefulWidget {
  const MyLiveScreen({super.key});

  @override
  State<MyLiveScreen> createState() => _MyLiveScreenState();
}

class _MyLiveScreenState extends State<MyLiveScreen> {
  final LiveScreenController controller = Get.put(LiveScreenController());
  final WebSocketClientService webSocketService = WebSocketClientService.to;
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  String? liveId;
  String? roomId;
  String? zegoRoomId; // NEW: Extracted from link
  String? coHostLink;
  bool isWebSocketInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
  }

  // NEW: Extract roomID from URL
  String? _extractRoomIdFromUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    try {
      final uri = Uri.parse(url);
      final roomID = uri.queryParameters['roomID'];
      log("📌 Extracted roomID from URL: $roomID");
      return roomID;
    } catch (e) {
      log("❌ Error extracting roomID from URL: $e");
      return null;
    }
  }

  Future<void> _initializeWebSocket() async {
    try {
      log("🚀 Initializing WebSocket for live stream...");

      final authToken = await _getAuthToken();

      if (authToken == null || authToken.isEmpty) {
        log("❌ No auth token available");
        return;
      }

      final socketUrl = "ws://10.0.20.169:5020";
      await webSocketService.connect(socketUrl, authToken);

      int attempts = 0;
      const maxAttempts = 10;

      while (attempts < maxAttempts && !webSocketService.isConnected.value) {
        await Future.delayed(Duration(milliseconds: 500));
        attempts++;
      }

      if (webSocketService.isConnected.value) {
        log("✅ WebSocket connected successfully");
        isWebSocketInitialized = true;

        webSocketService.setOnMessageReceived((message) {
          _handleWebSocketMessage(message);
        });
      } else {
        log("❌ WebSocket connection timeout");
      }
    } catch (e) {
      log("❌ WebSocket initialization error: $e");
    }
  }

  Future<String?> _getAuthToken() async {
    try {
      final token = helper.getString('userToken');
      return token;
    } catch (e) {
      log("❌ Error getting auth token: $e");
      return null;
    }
  }

  void _handleWebSocketMessage(String message) {
    try {
      log("📨 Received WebSocket message: $message");
    } catch (e) {
      log("❌ Error handling message: $e");
    }
  }

  void _openAddContributorDialog() {
    log("🎯 Opening Add Contributor Dialog");
    log("🔍 WebSocket connected: ${webSocketService.isConnected.value}");
    log("🔍 Room ID: $roomId");
    log("🔍 Co-Host Link: $coHostLink");

    if (!webSocketService.isConnected.value) {
      Get.snackbar(
        "Connecting",
        "Please wait while we establish connection...",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      _initializeWebSocket().then((_) {
        if (webSocketService.isConnected.value) {
          _showContributorDialog();
        } else {
          Get.snackbar(
            "Connection Failed",
            "Unable to connect to server. Please try again.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      });
      return;
    }

    if (roomId == null || roomId!.isEmpty) {
      Get.snackbar(
        "Error",
        "Stream ID not available",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _showContributorDialog();
  }

  void _showContributorDialog() {
    AddContributorDialog.show(
      context,
      streamId: roomId!,
      coHostLink: coHostLink ?? "https://join.com",
      webSocketService: webSocketService,
    );
  }

  @override
  void dispose() {
    log("🔌 Disconnecting WebSocket...");
    webSocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data = Get.arguments as Map<String, dynamic>?;

    if (data == null) {
      log("❌ No data received in MyLiveScreen");
      return _buildErrorScreen("Error: No live session data");
    }

    // Extract data
    liveId = data["liveId"] ?? data["roomId"] ?? "";
    roomId = data["roomId"] ?? liveId;
    final String userName = data['userName'] ?? 'TestUser';
    final String hostId = data["hostId"] ?? "";
    final String hostLink = data["hostLink"] ?? "";
    final String audienceLink = data["audienceLink"] ?? "";
    coHostLink = data["coHostLink"] ?? "";
    final bool isHost = data["isHost"] ?? true;
    final bool isPaid = data["isPaid"] ?? false;
    final double cost = (data["cost"] ?? 0.0).toDouble();

    // ✅ CRITICAL FIX: Extract Zego roomID from the appropriate link
    if (isHost) {
      zegoRoomId = _extractRoomIdFromUrl(hostLink);
    } else {
      zegoRoomId = _extractRoomIdFromUrl(audienceLink);
    }

    // Fallback to roomId if extraction fails
    if (zegoRoomId == null || zegoRoomId!.isEmpty) {
      zegoRoomId = roomId;
      log("⚠️ Using fallback roomId: $zegoRoomId");
    }

    log("=== MyLiveScreen Data ===");
    log("Live ID: $liveId");
    log("Room ID (DB): $roomId");
    log("Zego Room ID: $zegoRoomId"); // NEW
    log("Host ID: $hostId");
    log("Host Link: $hostLink");
    log("Audience Link: $audienceLink");
    log("Co-Host Link: $coHostLink");
    log("Is Host: $isHost");
    log("Is Paid: $isPaid");
    log("Cost: $cost");

    if (liveId?.isEmpty ?? true) {
      log("❌ Invalid live session data");
      return _buildErrorScreen("Invalid live session data");
    }

    // ✅ Generate unique user ID to prevent conflicts
    final String uniqueUserId = isHost
        ? "${hostId.substring(0, 8)}_host"
        : "${hostId.substring(0, 8)}_${DateTime.now().millisecondsSinceEpoch % 10000}";

    return Scaffold(
      body: Stack(
        children: [
          // ✅ FIXED: Use zegoRoomId instead of roomId
          ZegoUIKitPrebuiltLiveStreaming(
            appID: 1071350787,
            appSign: "657d70a56532ec960b9fc671ff05d44b498910b5668a1b3f1f1241bede47af71",
            userName: userName,
            userID: uniqueUserId, // ✅ FIXED: Use unique ID
            liveID: zegoRoomId!, // ✅ FIXED: Use extracted Zego room ID
            config: (isHost
                ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                : ZegoUIKitPrebuiltLiveStreamingConfig.audience())
              ..layout = ZegoLayout.gallery(
                  showScreenSharingFullscreenModeToggleButtonRules:
                  ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
                  showNewScreenSharingViewInFullscreenMode: true)
              ..audioVideoView = ZegoLiveStreamingAudioVideoViewConfig(
                showAvatarInAudioMode: true,
                showSoundWavesInAudioMode: true,
                useVideoViewAspectFill: true,
              )
              ..topMenuBar = ZegoLiveStreamingTopMenuBarConfig(
                buttons: [
                  ZegoLiveStreamingMenuBarButtonName.minimizingButton,
                ],
                backgroundColor: Colors.transparent,
                height: 80.h,
              )
              ..bottomMenuBar = ZegoLiveStreamingBottomMenuBarConfig(
                hostButtons: [
                  ZegoLiveStreamingMenuBarButtonName.toggleCameraButton,
                  ZegoLiveStreamingMenuBarButtonName.toggleMicrophoneButton,
                  ZegoLiveStreamingMenuBarButtonName.switchCameraButton,
                ],
                audienceButtons: [
                  ZegoLiveStreamingMenuBarButtonName.chatButton,
                ],
                backgroundColor: Colors.transparent,
                height: 80.h,
              )
              ..duration = ZegoLiveStreamingDurationConfig(
                isVisible: true,
              )
              ..memberList = ZegoLiveStreamingMemberListConfig(
                showFakeUser: false,
              )
              ..confirmDialogInfo = ZegoLiveStreamingDialogInfo(
                title: "Leave Live",
                message: "Are you sure you want to leave?",
                cancelButtonName: "Cancel",
                confirmButtonName: "Leave",
              ),
            events: ZegoUIKitPrebuiltLiveStreamingEvents(
              onEnded: (
                  ZegoLiveStreamingEndEvent event,
                  VoidCallback defaultAction,
                  ) {
                log("Live streaming ended: ${event.reason}");
                Get.back();
              },
              user: ZegoLiveStreamingUserEvents(
                onEnter: (ZegoUIKitUser user) {
                  log("✅ User entered: ${user.name} (${user.id})");
                  controller.viewerCount.value++;
                },
                onLeave: (ZegoUIKitUser user) {
                  log("❌ User left: ${user.name} (${user.id})");
                  if (controller.viewerCount.value > 0) {
                    controller.viewerCount.value--;
                  }
                },
              ),
            ),
          ),

          // Professional Overlay UI (rest of your UI code remains the same)
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.goBack(context, roomId!),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red, Colors.redAccent],
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6.w,
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "LIVE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Obx(() => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "${controller.viewerCount.value}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            SizedBox(width: 8.w),
                            Obx(() => webSocketService.isConnected.value
                                ? Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.wifi,
                                color: Colors.green,
                                size: 12.sp,
                              ),
                            )
                                : Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.wifi_off,
                                color: Colors.red,
                                size: 12.sp,
                              ),
                            )),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showMenuOptions(context, isHost),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() => controller.isRecording.value
                    ? Container(
                  margin: EdgeInsets.only(top: 8.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Recording...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
                    : SizedBox.shrink()),
                Spacer(),
                Container(
                  padding: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SizedBox(height: 80.h),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuOptions(BuildContext context, bool isHost) {
    final Map<String, dynamic>? data = Get.arguments;
    final String hostLink = data?["hostLink"] ?? "";
    final String audienceLink = data?["audienceLink"] ?? "";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Text(
                      "Live Options",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              if (isHost)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLinkBox(title: "Host Join Link", value: hostLink),
                      SizedBox(height: 10.h),
                      _buildLinkBox(title: "Co-Host Join Link", value: coHostLink ?? ""),
                      SizedBox(height: 10.h),
                      _buildLinkBox(title: "Audience Join Link", value: audienceLink),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              if (isHost) ...[
                _buildMenuOption(
                  icon: Icons.screen_share,
                  title: "Screen Share",
                  subtitle: controller.isScreenSharing.value
                      ? "Stop sharing screen"
                      : "Share your screen",
                  color: Colors.blue,
                  onTap: () {
                    Get.back();
                    controller.toggleScreenShare();
                  },
                ),
                _buildMenuOption(
                  icon: Icons.fiber_manual_record,
                  title: "Recording",
                  subtitle: controller.isRecording.value
                      ? "Stop recording session"
                      : "Record live session",
                  color: Colors.red,
                  onTap: () {
                    Get.back();
                    controller.toggleRecording();
                  },
                ),
                _buildMenuOption(
                  icon: Icons.person_add,
                  title: "Add Contributor",
                  subtitle: "Invite someone to join",
                  color: Colors.green,
                  onTap: () {
                    Get.back();
                    _openAddContributorDialog();
                  },
                ),
              ],
              _buildMenuOption(
                icon: Icons.poll,
                title: "Create Poll",
                subtitle: "Engage with audience",
                color: Colors.orange,
                onTap: () {
                  log("the button is pressed");
                  Get.back();
                  CreatePollDialog.show(context, roomId!);
                },
              ),
              if (isHost)
                _buildMenuOption(
                  icon: Icons.call_end,
                  title: "End Live",
                  subtitle: "Stop live streaming",
                  color: Colors.red[700]!,
                  onTap: () {
                    Get.back();
                    controller.endCall(context, roomId!);
                  },
                  isDanger: true,
                ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLinkBox({required String title, required String value}) {
    String displayValue = value;
    if (title == "Audience Join Link" && liveId != null && liveId!.isNotEmpty) {
      displayValue = "$liveId|$value";
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  displayValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: displayValue));
                  Get.snackbar(
                    "Copied",
                    "$title copied to clipboard",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: Duration(seconds: 2),
                  );
                },
                child: Icon(Icons.copy, color: Colors.blue, size: 20.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDanger ? Colors.red[700] : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Oops!",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Go Back",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}