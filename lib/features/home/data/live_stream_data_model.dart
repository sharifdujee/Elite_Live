
// Live Stream Info Model
class LiveStreamInfo {
  final String hostName;
  final String hostImage;
  final String hostBio;
  final bool isFollowing;
  final bool isVerified;
  final int viewerCount;

  LiveStreamInfo({
    required this.hostName,
    required this.hostImage,
    required this.hostBio,
    this.isFollowing = false,
    this.isVerified = false,
    required this.viewerCount,
  });
}