class UserEntity {
  final String uid;
  final String email;
  final String username;
  final String role;
  final String photoUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.username,
    this.role = 'user',
    this.photoUrl = '',
    required this.createdAt,
  });
}