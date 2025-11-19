

// To parse this JSON data, do
//
//     final myCrowdFundingDataModel = myCrowdFundingDataModelFromJson(jsonString);

import 'dart:convert';

MyCrowdFundingDataModel myCrowdFundingDataModelFromJson(String str) => MyCrowdFundingDataModel.fromJson(json.decode(str));

String myCrowdFundingDataModelToJson(MyCrowdFundingDataModel data) => json.encode(data.toJson());

class MyCrowdFundingDataModel {
  bool success;
  String message;
  MyCrowdResult result;

  MyCrowdFundingDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory MyCrowdFundingDataModel.fromJson(Map<String, dynamic> json) => MyCrowdFundingDataModel(
    success: json["success"]??'true',
    message: json["message"]??'',
    result: MyCrowdResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class MyCrowdResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<Event> events;

  MyCrowdResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory MyCrowdResult.fromJson(Map<String, dynamic> json) => MyCrowdResult(
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}

class Event {
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
  List<EventLike> eventLike;
  bool isLiked;

  Event({
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

  factory Event.fromJson(Map<String, dynamic> json) => Event(
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
    eventLike: List<EventLike>.from(json["EventLike"].map((x) => EventLike.fromJson(x))),
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
    "EventLike": List<dynamic>.from(eventLike.map((x) => x.toJson())),
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

class EventLike {
  String id;

  EventLike({
    required this.id,
  });

  factory EventLike.fromJson(Map<String, dynamic> json) => EventLike(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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
