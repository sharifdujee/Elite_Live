class VideoModel {
  final String name;
  final String username;
  final String views;
  final String time;
  final String image;

  VideoModel({
    required this.name,
    required this.username,
    required this.views,
    required this.time,
    required this.image,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      name: json['name'],
      username: json['username'],
      views: json['views'],
      time: json['time'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'username': username,
    'views': views,
    'time': time,
    'image': image,
  };
}
