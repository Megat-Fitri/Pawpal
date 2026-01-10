class User {
  String? userId;
  String? userEmail;
  String? userName;
  String? userPhone;
  String? userPassword;
  String? userRegdate;
  String? userImage;
  int? points;

  User(
      {this.userId,
      this.userEmail,
      this.userName,
      this.userPhone,
      this.userPassword,
      this.userRegdate,
      this.userImage,
      this.points
      });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['email'];
    userName = json['name'];
    userPhone = json['phone'];
    userPassword = json['password'];
    userRegdate = json['reg_date'];
    userImage = json['user_image'];
    points = int.parse(json['user_wallet']);
  }

  get name => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['email'] = userEmail;
    data['name'] = userName;
    data['phone'] = userPhone;
    data['password'] = userPassword;
    data['reg_date'] = userRegdate;
    data['user_image'] = userImage;
    data['user_wallet'] = points;
    return data;
  }
}