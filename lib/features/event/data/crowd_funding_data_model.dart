

// To parse this JSON data, do
//
//     final crowdFundingDataModel = crowdFundingDataModelFromJson(jsonString);

import 'dart:convert';

CrowdFundingDataModel crowdFundingDataModelFromJson(String str) => CrowdFundingDataModel.fromJson(json.decode(str));

String crowdFundingDataModelToJson(CrowdFundingDataModel data) => json.encode(data.toJson());

class CrowdFundingDataModel {
  bool? success;
  String? message;
  CrowdFundingResult result;

  CrowdFundingDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory CrowdFundingDataModel.fromJson(Map<String, dynamic> json) => CrowdFundingDataModel(
    success: json["success"]??true,
    message: json["message"]??'',
    result: CrowdFundingResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class CrowdFundingResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<CrowdFundingEvent> events;

  CrowdFundingResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory CrowdFundingResult.fromJson(Map<String, dynamic> json) => CrowdFundingResult(
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    events: List<CrowdFundingEvent>.from(json["events"].map((x) => CrowdFundingEvent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}

class CrowdFundingEvent {
  String id;
  String userId;
  String eventType;
  String text;
  dynamic scheduleDate;
  int payAmount;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Count count;
  List<dynamic> eventLike;
  bool isLiked;

  CrowdFundingEvent({
    required this.id,
    required this.userId,
    required this.eventType,
    required this.text,
    required this.scheduleDate,
    required this.payAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.count,
    required this.eventLike,
    required this.isLiked,
  });

  factory CrowdFundingEvent.fromJson(Map<String, dynamic> json) => CrowdFundingEvent(
    id: json["id"],
    userId: json["userId"],
    eventType: json["eventType"],
    text: json["text"],
    scheduleDate: json["scheduleDate"],
    payAmount: json["payAmount"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["user"]),
    count: Count.fromJson(json["_count"]),
    eventLike: List<dynamic>.from(json["EventLike"].map((x) => x)),
    isLiked: json["isLiked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "eventType": eventType,
    "text": text,
    "scheduleDate": scheduleDate,
    "payAmount": payAmount,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "user": user.toJson(),
    "_count": count.toJson(),
    "EventLike": List<dynamic>.from(eventLike.map((x) => x)),
    "isLiked": isLiked,
  };
}

class Count {
  int eventLike;
  int eventComment;

  Count({
    required this.eventLike,
    required this.eventComment,
  });

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    eventLike: json["EventLike"],
    eventComment: json["EventComment"],
  );

  Map<String, dynamic> toJson() => {
    "EventLike": eventLike,
    "EventComment": eventComment,
  };
}

class User {
  String id;
  String firstName;
  String lastName;
  String profileImage;
  String profession;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.profession,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileImage: json["profileImage"],
    profession: json["profession"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
    "profession": profession,
  };
}
