class UserModel {
  String? uid;
  String? email;
  String? userName;
  String? phoneNumber;

  UserModel({this.uid, this.email, this.userName, this.phoneNumber});

 factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'],
    email: map['email'],
    userName: map['userName'],
    phoneNumber: map['phoneNumber'],
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'userName': userName,
    'phoneNumber': phoneNumber,
  };

}