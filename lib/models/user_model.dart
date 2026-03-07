class UserModel {
  final String uid;
  final String email;
  final String fullName;

  UserModel({required this.uid, required this.email, required this.fullName});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'createdAt': DateTime.now(),
    };
  }
}
