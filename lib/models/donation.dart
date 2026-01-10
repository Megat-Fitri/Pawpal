class Donation {
  String? donationId;
  String? donationType;
  String? amount;
  String? description;
  String? createdAt;
  String? petName;
  String? petId;
  List<String> imagesPath = [];

  Donation({
    this.donationId,
    this.donationType,
    this.amount,
    this.description,
    this.createdAt,
    this.petName,
    this.petId,
    this.imagesPath = const [],
  });

  Donation.fromJson(Map<String, dynamic> json) {
    donationId = json['donation_id'];
    donationType = json['donation_type'];
    amount = json['amount'];
    description = json['description'];
    createdAt = json['created_at'];
    petName = json['pet_name'];
    petId = json['pet_id'];
    imagesPath = json['images_path'] != null
        ? json['images_path'].toString().split(",")
        : [];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['donation_id'] = donationId;
    data['donation_type'] = donationType;
    data['amount'] = amount;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['pet_name'] = petName;
    data['pet_id'] = petId;
    data['images_path'] = imagesPath.join(",");
    return data;
  }
}