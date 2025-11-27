// To parse this JSON data, do
//
//     final poolDataModel = poolDataModelFromJson(jsonString);

import 'dart:convert';

PoolDataModel poolDataModelFromJson(String str) =>
    PoolDataModel.fromJson(json.decode(str));

String poolDataModelToJson(PoolDataModel data) =>
    json.encode(data.toJson());

class PoolDataModel {
  bool success;
  String message;
  List<PoolResult> result; // ✅ Changed to List

  PoolDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory PoolDataModel.fromJson(Map<String, dynamic> json) => PoolDataModel(
    success: json["success"]??true,
    message: json["message"]??'',
    result: List<PoolResult>.from(
        json["result"].map((x) => PoolResult.fromJson(x))
    ), // ✅ Parse as list
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class PoolResult {
  String id;
  String userId;
  String? streamId;
  String question;
  List<String> options;
  String? createdAt; // ✅ Add these fields from API
  String? updatedAt; // ✅ Add these fields from API

  PoolResult({
    required this.id,
    required this.userId,
    this.streamId,
    required this.question,
    required this.options,
    this.createdAt,
    this.updatedAt,
  });

  factory PoolResult.fromJson(Map<String, dynamic> json) => PoolResult(
    id: json["id"] ?? "",
    userId: json["userId"] ?? "",
    streamId: json["streamId"],
    question: json["question"] ?? "",
    options: List<String>.from(json["options"] ?? []),
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "streamId": streamId,
    "question": question,
    "options": List<dynamic>.from(options.map((x) => x)),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}