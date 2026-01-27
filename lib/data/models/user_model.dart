class UserModel {
  String? userId;
  String? name;
  String? email;
  String? mobNo;
  String? gender;
  String? createdAt;
  bool isOnline = false;
  int? accountStatus = 1; //1-> Active, 2->InActive, 3->Suspended
  String? profilePic = "";
  int? profileStatus = 1; //1->public, 2->friends, 3->private

  UserModel({
    this.userId,
    this.name,
    this.email,
    this.mobNo,
    this.gender,
    this.createdAt,
    this.isOnline = false,
    this.accountStatus = 1,
    this.profilePic = "",
    this.profileStatus = 1,
  });

  // Convert UserModel to a map for Firestore
  Map<String, dynamic> toDoc() {
    return {
      "userId": userId,
      "name": name,
      "email": email,
      "mobNo": mobNo,
      "gender": gender,
      "createdAt": createdAt,
      "isOnline": isOnline,
      "accountStatus": accountStatus,
      "profilePic": profilePic,
      "profileStatus": profileStatus,
    };
  }

  // Factory constructor to create a UserModel from a Firestore document
  factory UserModel.fromDoc(Map<String, dynamic> doc) {
    return UserModel(
      userId: doc["userId"],
      name: doc["name"],
      email: doc["email"],
      mobNo: doc["mobNo"],
      gender: doc["gender"],
      createdAt: doc["createdAt"],
      isOnline: doc["isOnline"] ?? false,
      accountStatus: doc["accountStatus"] ?? 1,
      profilePic: doc["profilePic"] ?? "",
      profileStatus: doc["profileStatus"] ?? 1,
    );
  }
}
