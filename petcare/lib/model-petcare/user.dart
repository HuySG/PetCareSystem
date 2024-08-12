class User {
  int? userId;
  String? fullName;
  String? phone;
  String? dateOfBirth;
  bool? gender;
  String? email;
  String? password;
  String? address;
  String? createdDate;
  String? updatedDate;
  int? authCode;
  bool? status;
  bool? isStaff;
  bool? isAdmin;

  User(
      {this.userId,
      this.fullName,
      this.phone,
      this.dateOfBirth,
      this.gender,
      this.email,
      this.password,
      this.address,
      this.createdDate,
      this.updatedDate,
      this.authCode,
      this.status,
      this.isStaff,
      this.isAdmin});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    phone = json['phone'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    email = json['email'];
    password = json['password'];
    address = json['address'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    authCode = json['authCode'];
    status = json['status'];
    isStaff = json['isStaff'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['phone'] = this.phone;
    data['dateOfBirth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['password'] = this.password;
    data['address'] = this.address;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    data['authCode'] = this.authCode;
    data['status'] = this.status;
    data['isStaff'] = this.isStaff;
    data['isAdmin'] = this.isAdmin;
    return data;
  }
}
