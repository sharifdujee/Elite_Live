// To parse this JSON data, do
//
//     final scheduleEventDataModel = scheduleEventDataModelFromJson(jsonString);

import 'dart:convert';

ScheduleEventDataModel scheduleEventDataModelFromJson(String str) => ScheduleEventDataModel.fromJson(json.decode(str));

String scheduleEventDataModelToJson(ScheduleEventDataModel data) => json.encode(data.toJson());

class ScheduleEventDataModel {
  bool? success;
  String? message;
  ScheduleEventResult result;

  ScheduleEventDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory ScheduleEventDataModel.fromJson(Map<String, dynamic> json) => ScheduleEventDataModel(
    success: json["success"]??true,
    message: json["message"]??'',
    result: ScheduleEventResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class ScheduleEventResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<LiveEvent> events;

  ScheduleEventResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory ScheduleEventResult.fromJson(Map<String, dynamic> json) => ScheduleEventResult(
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    events: List<LiveEvent>.from(json["events"].map((x) => LiveEvent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}

class LiveEvent {
  String id;
  String userId;
  String eventType;
  String text;
  DateTime scheduleDate;
  double payAmount;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Count count;
  List<EventLike> eventLike;
  bool isLiked;

  LiveEvent({
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

  factory LiveEvent.fromJson(Map<String, dynamic> json) => LiveEvent(
    id: json["id"],
    userId: json["userId"],
    eventType: json["eventType"],
    text: json["text"],
    scheduleDate: DateTime.parse(json["scheduleDate"]),
    payAmount: (json["payAmount"] ?? 0).toDouble(),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["user"]),
    count: Count.fromJson(json["_count"]),
    eventLike: List<EventLike>.from(json["EventLike"].map((x) => EventLike.fromJson(x))),
    isLiked: json["isLiked"] ?? false, // Handle null by defaulting to false
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "eventType": eventType,
    "text": text,
    "scheduleDate": scheduleDate.toIso8601String(),
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
