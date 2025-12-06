class Pet {
  String? petId;
  String? userId;
  String? petName;
  String? petType;
  String? petCategory;
  String? petDesc;
  List<String> images_paths = []; 
  String? latitude;
  String? longitude;
  String? petCreateDate;

  //user info
  String? userName;
  String? userEmail;
  String? userPhone;



  Pet({
    this.petId,
    this.userId,
    this.petName,
    this.petType,
    this.petCategory,
    this.petDesc,
    this.images_paths = const [],
    this.latitude,
    this.longitude,
    this.petCreateDate,
    this.userName,
    this.userEmail,
    this.userPhone,
  });

  Pet.fromJson(Map<String, dynamic> json) {
    petId = json['pet_id'];
    userId = json['user_id'];
    petName = json['pet_name'];
    petType = json['pet_type'];
    petCategory = json['category'];
    petDesc = json['description'];
    images_paths = json['images_paths'] != null
        ? json['images_paths'].toString().split(",")
        : []; // <---- FIX here, always safe
    latitude = json['lat'];
    longitude = json['lng'];
    petCreateDate = json['created_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = petId;
    data['user_id'] = userId;
    data['pet_name'] = petName;
    data['pet_type'] = petType;
    data['category'] = petCategory;
    data['description'] = petDesc;
    data['images_paths'] = images_paths.join(",");
    data['lat'] = latitude;
    data['lng'] = longitude;
    data['created_at'] = petCreateDate;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_phone'] = userPhone;



    return data;
  }
}