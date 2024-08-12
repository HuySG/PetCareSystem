class Pet {
  int? petId;
  String? petName;
  String? petType;
  String? breed;
  bool? gender;
  String? dateOfBirth;
  int? weight;
  String? currentDiet;
  String? note;
  String? imageProfile;
  String? createdDate;
  String? updatedDate;
  int? userId;
  int? diabetes;
  int? arthritis;
  int? vaccine;

  Pet(
      {this.petId,
      this.petName,
      this.petType,
      this.breed,
      this.gender,
      this.dateOfBirth,
      this.weight,
      this.currentDiet,
      this.note,
      this.imageProfile,
      this.createdDate,
      this.updatedDate,
      this.userId,
      this.diabetes,
      this.arthritis,
      this.vaccine});

  Pet.fromJson(Map<String, dynamic> json) {
    petId = json['petId'];
    petName = json['petName'];
    petType = json['petType'];
    breed = json['breed'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    weight = json['weight'];
    currentDiet = json['currentDiet'];
    note = json['note'];
    imageProfile = json['imageProfile'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    userId = json['userId'];
    diabetes = json['diabetes'];
    arthritis = json['arthritis'];
    vaccine = json['vaccine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['petId'] = this.petId;
    data['petName'] = this.petName;
    data['petType'] = this.petType;
    data['breed'] = this.breed;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['weight'] = this.weight;
    data['currentDiet'] = this.currentDiet;
    data['note'] = this.note;
    data['imageProfile'] = this.imageProfile;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    data['userId'] = this.userId;
    data['diabetes'] = this.diabetes;
    data['arthritis'] = this.arthritis;
    data['vaccine'] = this.vaccine;
    return data;
  }
}
