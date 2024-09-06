class Error {
  int status;
  String name;
  String message;

  Error({
    required this.status,
    required this.name,
    required this.message,
  });

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      status: json['status'],
      name: json['name'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'name': name,
      'message': message,
    };
  }
}

class ErrorResponse {
  String error;

  ErrorResponse({
    required this.error,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: json['msg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': error,
    };
  }
}