import 'dart:convert';

class Pet {
  String? petId;
  String? userId;
  String? petName;
  String? petAge;
  String? petGender;
  String? petType;
  String? petCategory;
  String? petHealth;
  String? petDesc;
  List<String> image_paths = []; 
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
    this.petAge,
    this.petGender,
    this.petType,
    this.petCategory,
    this.petHealth,
    this.petDesc,
    this.image_paths = const [],
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
    petAge = json['pet_age'];
    petGender = json['pet_gender'];
    petType = json['pet_type'];
    petCategory = json['category'];
    petHealth = json['pet_health'];
    petDesc = json['description'];
    image_paths = (json['image_paths'] != null && json['image_paths'] != '')
        ? List<String>.from(jsonDecode(json['image_paths']))
        : []; // <---- FIX here, always safe
    latitude = json['lat'];
    longitude = json['lng'];
    petCreateDate = json['created_at'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = petId;
    data['user_id'] = userId;
    data['pet_name'] = petName;
    data['pet_age'] = petAge;
    data['pet_gender'] = petGender;
    data['pet_type'] = petType;
    data['category'] = petCategory;
    data['pet_health'] = petHealth;
    data['description'] = petDesc;
    data['image_paths'] = image_paths.join(",");
    data['lat'] = latitude;
    data['lng'] = longitude;
    data['created_at'] = petCreateDate;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_phone'] = userPhone;



    return data;
  }
}