
// To parse this JSON data, do
//
//     final discoverGroupDataModel = discoverGroupDataModelFromJson(jsonString);

import 'dart:convert';

DiscoverGroupDataModel discoverGroupDataModelFromJson(String str) => DiscoverGroupDataModel.fromJson(json.decode(str));

String discoverGroupDataModelToJson(DiscoverGroupDataModel data) => json.encode(data.toJson());

class DiscoverGroupDataModel {
  bool success;
  String message;
  List<DiscoverGroupResult> result;

  DiscoverGroupDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory DiscoverGroupDataModel.fromJson(Map<String, dynamic> json) => DiscoverGroupDataModel(
    success: json["success"],
    message: json["message"],
    result: List<DiscoverGroupResult>.from(json["result"].map((x) => DiscoverGroupResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class DiscoverGroupResult {
  String id;
  String groupName;
  String photo;
  bool isPublic;
  DateTime createdAt;
  Count count;

  DiscoverGroupResult({
    required this.id,
    required this.groupName,
    required this.photo,
    required this.isPublic,
    required this.createdAt,
    required this.count,
  });

  factory DiscoverGroupResult.fromJson(Map<String, dynamic> json) => DiscoverGroupResult(
    id: json["id"],
    groupName: json["groupName"],
    photo: json["photo"],
    isPublic: json["isPublic"],
    createdAt: DateTime.parse(json["createdAt"]),
    count: Count.fromJson(json["_count"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "groupName": groupName,
    "photo": photo,
    "isPublic": isPublic,
    "createdAt": createdAt.toIso8601String(),
    "_count": count.toJson(),
  };
}

class Count {
  int groupMember;

  Count({
    required this.groupMember,
  });

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    groupMember: json["groupMember"],
  );

  Map<String, dynamic> toJson() => {
    "groupMember": groupMember,
  };
}
