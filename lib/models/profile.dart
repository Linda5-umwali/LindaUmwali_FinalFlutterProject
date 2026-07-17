import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String id;
  final String name;
  final String email;
  final String bio;
  final List<String> skills;
  final bool isStudent;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.skills,
    required this.isStudent,
  });

  factory Profile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Profile(
      id: doc.id,
      name: data['name']?.toString() ?? 'Unknown User',
      email: data['email']?.toString() ?? '',
      bio: data['bio']?.toString() ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      isStudent: data['isStudent'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'skills': skills,
      'isStudent': isStudent,
    };
  }
}
