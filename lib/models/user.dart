class User {
  final String email;
  final String uid;
  final String? displayName;
  final String accessToken;
  final String refreshToken;

  User({
    required this.email,
    required this.uid,
    this.displayName,
    required this.accessToken,
    required this.refreshToken,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      uid: map['uid'] as String,
      displayName: map['displayName'] as String?,
      accessToken: map['stsTokenManager']['accessToken'] as String,
      refreshToken: map['stsTokenManager']['refreshToken'] as String,
    );
  }
}
