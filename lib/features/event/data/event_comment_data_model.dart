// To parse this JSON data, do
//
//     final eventCommentDataModel = eventCommentDataModelFromJson(jsonString);

// Update your EventCommentDataModel class

class EventCommentDataModel {
  bool? success;
  String? message;
  EventCommentResult? result;

  EventCommentDataModel({this.success, this.message, this.result});

  EventCommentDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? EventCommentResult.fromJson(json['result'])
        : null;
  }
}

class EventCommentResult {
  String? id;
  List<EventComment> eventComment;  // ← Keep this lowercase in your model

  EventCommentResult({this.id, required this.eventComment});

  factory EventCommentResult.fromJson(Map<String, dynamic> json) {
    return EventCommentResult(
      id: json['id'],
      // ✅ FIX: Map from 'EventComment' (capital) to eventComment (lowercase)
      eventComment: (json['EventComment'] as List<dynamic>?)
          ?.map((e) => EventComment.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class EventComment {
  String id;
  String comment;
  String createdAt;
  CommentUser user;
  List<ReplyComment> replyComment;

  EventComment({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.user,
    required this.replyComment,
  });

  factory EventComment.fromJson(Map<String, dynamic> json) {
    return EventComment(
      id: json['id'] ?? '',
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] ?? '',
      user: CommentUser.fromJson(json['user'] ?? {}),
      // ✅ FIX: Map from 'ReplyComment' (capital) to replyComment (lowercase)
      replyComment: (json['ReplyComment'] as List<dynamic>?)
          ?.map((e) => ReplyComment.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class CommentUser {
  String id;
  String profileImage;
  String firstName;
  String lastName;

  CommentUser({
    required this.id,
    required this.profileImage,
    required this.firstName,
    required this.lastName,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id'] ?? '',
      profileImage: json['profileImage'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}

class ReplyComment {
  String id;
  String replyComment;
  String createdAt;
  CommentUser user;

  ReplyComment({
    required this.id,
    required this.replyComment,
    required this.createdAt,
    required this.user,
  });

  factory ReplyComment.fromJson(Map<String, dynamic> json) {
    return ReplyComment(
      id: json['id'] ?? '',
      replyComment: json['replyComment'] ?? '',
      createdAt: json['createdAt'] ?? '',
      user: CommentUser.fromJson(json['user'] ?? {}),
    );
  }
}


