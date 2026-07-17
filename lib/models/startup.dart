import 'package:cloud_firestore/cloud_firestore.dart';

/// this represents an ALU startup.
class Startup {
  final String id;
  final String startupName;
  final String description;
  final String industry;
  final String logo;
  final String founder;
  final String email;
  final String website;
  final String location;
  final List<String> members;
  final DateTime createdAt;

  Startup({
    required this.id,
    required this.startupName,
    required this.description,
    required this.industry,
    required this.logo,
    required this.founder,
    required this.email,
    required this.website,
    required this.location,
    required this.members,
    required this.createdAt,
  });

  factory Startup.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Startup(
      id: doc.id,
      startupName: data['startupName'] ?? '',
      description: data['description'] ?? '',
      industry: data['industry'] ?? '',
      logo: data['logo'] ?? '',
      founder: data['founder'] ?? '',
      email: data['email'] ?? '',
      website: data['website'] ?? '',
      location: data['location'] ?? '',
      members: data['members'] is List
          ? List<String>.from(data['members'])
          : <String>[],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory Startup.fromMap(Map<String, dynamic> map, String id) {
    return Startup(
      id: id,
      startupName: map['startupName'] ?? '',
      description: map['description'] ?? '',
      industry: map['industry'] ?? '',
      logo: map['logo'] ?? '',
      founder: map['founder'] ?? '',
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      location: map['location'] ?? '',
      members: map['members'] is List
          ? List<String>.from(map['members'])
          : <String>[],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
                DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startupName': startupName,
      'description': description,
      'industry': industry,
      'logo': logo,
      'founder': founder,
      'email': email,
      'website': website,
      'location': location,
      'members': members,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Startup copyWith({
    String? startupName,
    String? description,
    String? industry,
    String? logo,
    String? founder,
    String? email,
    String? website,
    String? location,
    List<String>? members,
    DateTime? createdAt,
  }) {
    return Startup(
      id: id,
      startupName: startupName ?? this.startupName,
      description: description ?? this.description,
      industry: industry ?? this.industry,
      logo: logo ?? this.logo,
      founder: founder ?? this.founder,
      email: email ?? this.email,
      website: website ?? this.website,
      location: location ?? this.location,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return '''
Startup
------------------------
Name: $startupName
Industry: $industry
Founder: $founder
Location: $location
Website: $website''';
  }
}
