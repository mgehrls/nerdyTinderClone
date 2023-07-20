class NewUser {
  final String uid;
  final String name;
  final int age;
  final String email;
  final String bio;
  final DateTime createdAt;
  final String profilePictureUrl;
  final String secondaryPictureUrl;
  final String tertiaryPictureUrl;

  const NewUser({
    required this.uid,
    required this.name,
    required this.age,
    required this.email,
    required this.bio,
    required this.createdAt,
    required this.profilePictureUrl,
    required this.secondaryPictureUrl,
    required this.tertiaryPictureUrl,
  });
}

class UserProfileInfo {
  final String uid;
  final String name;
  final int age;
  final String email;
  final String bio;
  final String profilePictureUrl;
  final String secondaryPictureUrl;
  final String tertiaryPictureUrl;

  UserProfileInfo({
    required this.uid,
    required this.name,
    required this.age,
    required this.email,
    required this.bio,
    required this.profilePictureUrl,
    required this.secondaryPictureUrl,
    required this.tertiaryPictureUrl,
  });
}
