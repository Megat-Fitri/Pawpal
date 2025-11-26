class User {
  String? userId;
  String? userEmail;
  String? userName;
  String? userPhone;
  String? userPassword;
  String? userRegdate;

  User(
      {this.userId,
      this.userEmail,
      this.userName,
      this.userPhone,
      this.userPassword,
      this.userRegdate});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    userPassword = json['user_password'];
    userRegdate = json['user_regdate'];
  }

  get name => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_name'] = userName;
    data['user_phone'] = userPhone;
    data['user_password'] = userPassword;
    data['user_regdate'] = userRegdate;
    return data;
  }
}