import 'package:elites_live/core/global_widget/custom_snackbar.dart';
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
import '../widget/live_comment_widget.dart';
import '../widget/live_error_screen.dart';
import 'package:elites_live/features/live/presentation/widget/contributor_request_dialog.dart';


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
  String? zegoRoomId;
  String? coHostLink;
  String? eventId;
  bool isFromEvent = false;
  bool isWebSocketInitialized = false;
  bool showComments = false;

  @override
  void initState() {
    super.initState();
    _extractArguments();
    _setupContributionRequestListener();
  }

  void _extractArguments() {
    final Map<String, dynamic>? data = Get.arguments as Map<String, dynamic>?;
    if (data != null) {
      eventId = data['eventId'];
      isFromEvent = eventId != null && eventId!.isNotEmpty;
      log("📌 Is from event: $isFromEvent, Event ID: $eventId");
    }
  }

  // NEW: Setup contribution request listener
  void _setupContributionRequestListener() {
    webSocketService.setOnContributionRequest((data) {
      log("🎯 Received contribution request in MyLiveScreen");
      _handleContributionRequest(data);
    });
  }

  // NEW: Handle incoming contribution requests
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

      log("👤 Invitation from: $fromUserName");
      log("🔗 Co-Host Link: $coHostLink");
      log("📺 Stream ID: $streamId");

      // Show the contribution request dialog
      ContributorRequestDialog.show(
        onAccepted: (){
          setState(() {

          });
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
      log("❌ Error handling contribution request: $e");
    }
  }

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

      const socketUrl = "wss://api.elites-livestream.com";
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

        // Setup contribution request listener after connection
        _setupContributionRequestListener();
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

    if (!webSocketService.isConnected.value) {
      CustomSnackBar.warning(
        title: "Connecting",
        message: "Please wait while we establish connection...",
      );
      _initializeWebSocket().then((_) {
        if (webSocketService.isConnected.value) {
          _showContributorDialog();
        } else {
          CustomSnackBar.error(
            title: "Connection Failed",
            message: "Unable to connect to server. Please try again.",
          );
        }
      });
      return;
    }

    if (roomId == null || roomId!.isEmpty) {
      CustomSnackBar.error(
        title: "Error",
        message: "Stream ID not available",
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
    log("🔌 Cleaning up...");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data = Get.arguments as Map<String, dynamic>?;

    if (data == null) {
      log("❌ No data received in MyLiveScreen");
      return LiveErrorScreen(message: "Error: No live session data");
    }

    liveId = data["liveId"] ?? data["roomId"] ?? "";
    roomId = data["roomId"] ?? liveId;
    eventId = data["eventId"];
    isFromEvent = eventId != null && eventId!.isNotEmpty;
    final String userName = data['userName'] ?? 'TestUser';
    final String hostId = data["hostId"] ?? "";
    final String hostLink = data["hostLink"] ?? "";
    final String audienceLink = data["audienceLink"] ?? "";
    coHostLink = data["coHostLink"] ?? "";
    final bool isHost = data["isHost"] ?? true;
    final bool isPaid = data["isPaid"] ?? false;
    final double cost = (data["cost"] ?? 0.0).toDouble();

    if (isHost) {
      zegoRoomId = _extractRoomIdFromUrl(hostLink);
    } else {
      zegoRoomId = _extractRoomIdFromUrl(audienceLink);
    }

    if (zegoRoomId == null || zegoRoomId!.isEmpty) {
      zegoRoomId = roomId;
      log("⚠️ Using fallback roomId: $zegoRoomId");
    }

    log("=== MyLiveScreen Data ===");
    log("Live ID: $liveId");
    log("Room ID (DB): $roomId");
    log("Event ID: $eventId");
    log("Is From Event: $isFromEvent");
    log("Zego Room ID: $zegoRoomId");
    log("Is Host: $isHost");

    if (liveId?.isEmpty ?? true) {
      log("❌ Invalid live session data");
      return LiveErrorScreen(message: "Invalid live session data");
    }

    final String uniqueUserId = isHost
        ? "${hostId.substring(0, 8)}_host"
        : "${hostId.substring(0, 8)}_${DateTime.now().millisecondsSinceEpoch % 10000}";

    return Scaffold(
      body: Stack(
        children: [
          ZegoUIKitPrebuiltLiveStreaming(
            appID: 1071350787,
            appSign: "657d70a56532ec960b9fc671ff05d44b498910b5668a1b3f1f1241bede47af71",
            userName: userName,
            userID: uniqueUserId,
            liveID: zegoRoomId!,
            config: (isHost
                ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                : ZegoUIKitPrebuiltLiveStreamingConfig.audience())
              ..layout = ZegoLayout.pictureInPicture(
                showScreenSharingFullscreenModeToggleButtonRules: ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
                showNewScreenSharingViewInFullscreenMode: true,
                isSmallViewDraggable: false,
                switchLargeOrSmallViewByClick: false,
              )
              ..inRoomMessage = ZegoLiveStreamingInRoomMessageConfig(visible: false)
              ..audioVideoView = ZegoLiveStreamingAudioVideoViewConfig(
                showAvatarInAudioMode: true,
                showSoundWavesInAudioMode: true,
                useVideoViewAspectFill: true,
              )
              ..topMenuBar = ZegoLiveStreamingTopMenuBarConfig(

              )
              ..bottomMenuBar = ZegoLiveStreamingBottomMenuBarConfig(
                hostButtons: [
                  ZegoLiveStreamingMenuBarButtonName.toggleCameraButton,
                  ZegoLiveStreamingMenuBarButtonName.toggleMicrophoneButton,
                  ZegoLiveStreamingMenuBarButtonName.switchCameraButton,
                ],
                audienceButtons: [],
                backgroundColor: Colors.transparent,
                height: 80.h,
              )
              ..duration = ZegoLiveStreamingDurationConfig(isVisible: true)
              ..memberList = ZegoLiveStreamingMemberListConfig(showFakeUser: false)
              ..confirmDialogInfo = ZegoLiveStreamingDialogInfo(
                title: "Leave Live",
                message: "Are you sure you want to leave?",
                cancelButtonName: "Cancel",
                confirmButtonName: "Leave",
              ),
            events: ZegoUIKitPrebuiltLiveStreamingEvents(
              onEnded: (event, defaultAction) {
                log("Live streaming ended: ${event.reason}");
                Get.back();
              },
              user: ZegoLiveStreamingUserEvents(
                onEnter: (ZegoUIKitUser user) async {
                  log("✅ User entered: ${user.name} (${user.id})");

                  final localUser = ZegoUIKit().getLocalUser();
                  final isLocalUserHost = localUser.id == user.id && isHost;

                  if (user.id != localUser.id || !isHost) {
                    controller.viewerCount.value++;
                  }

                  if (roomId != null && roomId!.isNotEmpty) {
                    if (!isHost || user.id != localUser.id) {
                      try {
                        await controller.updateWatchCount(roomId!);
                        log("📈 updateWatchCount API called for viewer: ${user.name}");
                      } catch (e) {
                        log("⚠️ Failed to update watch count: $e");
                      }
                    }
                  }
                },
                onLeave: (ZegoUIKitUser user) {
                  log("❌ User left: ${user.name} (${user.id})");

                  final localUser = ZegoUIKit().getLocalUser();

                  if (user.id != localUser.id || !isHost) {
                    if (controller.viewerCount.value > 0) {
                      controller.viewerCount.value--;
                    }
                  }
                },
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: showComments ? 400.h : 0,
              child: showComments
                  ? LiveCommentWidget(
                eventId: eventId,
                streamId: isFromEvent ? null : roomId,
                isFromEvent: isFromEvent,
              )
                  : SizedBox.shrink(),
            ),
          ),

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
                          child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.red, Colors.redAccent]),
                                borderRadius: BorderRadius.circular(20.r),
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
                                  Text("LIVE", style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),

                            Obx(() => Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.visibility, color: Colors.white, size: 14.sp),
                                  SizedBox(width: 6.w),
                                  Text("${controller.viewerCount.value}", style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                                ],
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
                          child: Icon(Icons.more_vert, color: Colors.white, size: 20.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                if (!showComments)
                  Padding(
                    padding: EdgeInsets.only(right: 16.w, bottom: 100.h),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showComments = !showComments;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple, Colors.deepPurple],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withValues(alpha: 0.4),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(Icons.chat_bubble, color: Colors.white, size: 24.sp),
                        ),
                      ),
                    ),
                  ),

                if (showComments)
                  Padding(
                    padding: EdgeInsets.only(right: 16.w, bottom: 420.h),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showComments = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                        ),
                      ),
                    ),
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
              /// Drag bar
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),

              /// Title
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

              /// Link Boxes for HOST
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

              /// OPTIONS FOR HOST
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
                    controller.toggleRecording(roomId!);
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

              /// Create Poll (available for all)
              _buildMenuOption(
                icon: Icons.poll,
                title: "Create Poll",
                subtitle: "Engage with audience",
                color: Colors.orange,
                onTap: () {
                  log("the button is pressed");
                  Get.back();
                  CreatePollDialog.show(context, streamId: liveId!);
                },
              ),

              /// End Live (host only)
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

  /// LINK BOX UI (same as second)
  Widget _buildLinkBox({required String title, required String value}) {
    String displayValue = value;

    // first version logic kept
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
                  CustomSnackBar.success(
                    title: "Copied",
                    message: "$title copied to clipboard",
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

  /// MENU OPTION UI (same as second)
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

}

