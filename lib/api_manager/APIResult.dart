
class APIResult {
  final Map<String, dynamic> data;
  final List<dynamic> dataList;
  final int status;
  final String message;

  APIResult({this.data, this.dataList, this.status, this.message});

  factory APIResult.fromJson(Map<String, dynamic> json) {
    return APIResult(
      data: (json['data'] is Map)?json['data']:null,
      dataList: (json['data'] is List)?json['data']:null,
      status: int.parse(json['status']),
      message: json['message']??"",
    );
  }
}