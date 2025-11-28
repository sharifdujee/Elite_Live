

// To parse this JSON data, do
//
//     final myScheduleEventDataModel = myScheduleEventDataModelFromJson(jsonString);

import 'dart:convert';

MyScheduleEventDataModel myScheduleEventDataModelFromJson(String str) =>
    MyScheduleEventDataModel.fromJson(json.decode(str));

String myScheduleEventDataModelToJson(MyScheduleEventDataModel data) =>
    json.encode(data.toJson());

class MyScheduleEventDataModel {
  bool? success;
  String? message;
  MyScheduleEventResult result;

  MyScheduleEventDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory MyScheduleEventDataModel.fromJson(Map<String, dynamic> json) =>
      MyScheduleEventDataModel(
        success: json["success"] ?? true,
        message: json["message"] ?? '',
        result: MyScheduleEventResult.fromJson(json["result"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class MyScheduleEventResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<Event> events;

  MyScheduleEventResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory MyScheduleEventResult.fromJson(Map<String, dynamic> json) =>
      MyScheduleEventResult(
        totalCount: json["totalCount"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
        currentPage: json["currentPage"] ?? 0,
        events: json["events"] != null
            ? List<Event>.from(json["events"].map((x) => Event.fromJson(x)))
            : [],
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
  DateTime scheduleDate;
  double payAmount;
  String recordedLink;
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
    required this.recordedLink,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.count,
    required this.eventLike,
    required this.isLiked,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"] ?? '',
    userId: json["userId"] ?? '',
    eventType: json["eventType"] ?? '',
    text: json["text"] ?? '',
    scheduleDate: json["scheduleDate"] != null
        ? DateTime.parse(json["scheduleDate"])
        : DateTime.now(),
    payAmount: (json["payAmount"] ?? 0).toDouble(),
    recordedLink: (json["recordedLink"] ?? "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
    createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : DateTime.now(),
    updatedAt: json["updatedAt"] != null
        ? DateTime.parse(json["updatedAt"])
        : DateTime.now(),
    user: json["user"] != null
        ? User.fromJson(json["user"])
        : User(
        id: '',
        firstName: '',
        lastName: '',
        profileImage: '',
        profession: ''
    ),
    count: json["_count"] != null
        ? Count.fromJson(json["_count"])
        : Count(eventLike: 0, eventComment: 0),
    eventLike: json["EventLike"] != null
        ? List<EventLike>.from(json["EventLike"].map((x) => EventLike.fromJson(x)))
        : [],
    isLiked: json["isLiked"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "eventType": eventType,
    "text": text,
    "scheduleDate": scheduleDate.toIso8601String(),
    "payAmount": payAmount,
    "recordedLink":recordedLink,
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
    eventLike: json["EventLike"] ?? 0,
    eventComment: json["EventComment"] ?? 0,
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
    id: json["id"] ?? '',
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
    id: json["id"] ?? '',
    firstName: json["firstName"] ?? '',
    lastName: json["lastName"] ?? '',
    profileImage: json["profileImage"] ?? '',
    profession: json["profession"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
    "profession": profession,
  };
}
