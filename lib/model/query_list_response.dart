import 'dart:convert';

class QueryRequestsResponse {
  QueryRequestsResponse({
    this.result,
  });

  List<QueryResult>? result;

  factory QueryRequestsResponse.fromRawJson(String str) => QueryRequestsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QueryRequestsResponse.fromJson(Map<String, dynamic> json) => QueryRequestsResponse(
    result: List<QueryResult>.from(json["result"].map((x) => QueryResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result != null ? List<dynamic>.from(result!.map((x) => x.toJson())) : null,
  };
}

class QueryResult {
  QueryResult({
    this.searchQuery,
    this.language,
    this.startDate,
    this.endDate,
    this.queryTime,
    this.status,
    this.id,
  });

  List<String>? searchQuery;
  String? language;
  String? startDate;
  String? endDate;
  int? queryTime;
  String? status;
  String? id;

  factory QueryResult.fromRawJson(String str) => QueryResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QueryResult.fromJson(Map<String, dynamic> json) => QueryResult(
    searchQuery: List<String>.from(json["searchQuery"].map((x) => x)),
    language: json["language"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    queryTime: json["queryTime"],
    status: json["status"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "searchQuery": searchQuery != null ? List<dynamic>.from(searchQuery!.map((x) => x)) : null,
    "language": language,
    "startDate": startDate,
    "endDate": endDate,
    "queryTime": queryTime,
    "status": status,
    "id": id,
  };
}