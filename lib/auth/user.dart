class User {
  int userId;
  String username;
  String email;
  String phone;
  String type;
  String token;
  String renewalToken;

  User(
      {required this.userId,
      required this.username,
      required this.email,
      required this.phone,
      required this.type,
      required this.token,
      required this.renewalToken});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['id'],
        username: responseData['username'],
        email: responseData['email'],
        phone: responseData['phone'],
        type: responseData['type'],
        token: responseData['access_token'],
        renewalToken: responseData['renewal_token']);
  }
}
