class UserModel {
  int id;
  String username;
  String email;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }
}

class UserLoginRequest {
  String email;
  String password;

  UserLoginRequest({
    required this.email,
    required this.password,
  });

  factory UserLoginRequest.fromJson(Map<String, dynamic> json) {
    return UserLoginRequest(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class UserSignupRequest {
  String email;
  String password;
  String username;
  String fullname;

  UserSignupRequest({
    required this.email,
    required this.password,
    required this.username,
    required this.fullname,
  });

  factory UserSignupRequest.fromJson(Map<String, dynamic> json) {
    return UserSignupRequest(
      email: json['email'],
      password: json['password'],
      username: json['username'],
      fullname: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'username': username,
      'name': fullname,
    };
  }
}

class UserResponse {
  String token;
  String refreshToken;
  UserModel user;

  UserResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'];

    return UserResponse(
      token: data['token'],
      refreshToken: data['refresh_token'],
      user: UserModel.fromJson(data['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refresh_token': refreshToken,
      'user': user.toJson(),
    };
  }
}
