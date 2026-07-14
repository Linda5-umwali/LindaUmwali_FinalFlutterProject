import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an internship, event, or other opportunity posted by a startup.
class Opportunity {
  final String id;
  final String title;
  final String description;
  final String startupId;
  final String startupName;
  final String category;
  final String location;
  final DateTime deadline;
  final String type;
  final String duration;
  final List<String> requirements;
  final String postedBy;
  final DateTime createdAt;

  Opportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.startupId,
    required this.startupName,
    required this.category,
    required this.location,
    required this.deadline,
    required this.type,
    required this.duration,
    required this.requirements,
    required this.postedBy,
    required this.createdAt,
  });

  /// Builds an [Opportunity] from a Firestore document.
  factory Opportunity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return Opportunity(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startupId: data['startupId'] ?? '',
      startupName: data['startupName'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      deadline: (data['deadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: data['type'] ?? '',
      duration: data['duration'] ?? '',
      requirements: List<String>.from(data['requirements'] ?? []),
      postedBy: data['postedBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Builds an [Opportunity] from a generic map (e.g. decoded JSON).
  factory Opportunity.fromMap(Map<String, dynamic> map, String id) {
    return Opportunity(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startupId: map['startupId'] ?? '',
      startupName: map['startupName'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      deadline: map['deadline'] is Timestamp
          ? (map['deadline'] as Timestamp).toDate()
          : DateTime.tryParse(map['deadline']?.toString() ?? '') ??
                DateTime.now(),
      type: map['type'] ?? '',
      duration: map['duration'] ?? '',
      requirements: List<String>.from(map['requirements'] ?? []),
      postedBy: map['postedBy'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
                DateTime.now(),
    );
  }

  /// Converts this [Opportunity] into a map suitable for writing to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startupId': startupId,
      'startupName': startupName,
      'category': category,
      'location': location,
      'deadline': Timestamp.fromDate(deadline),
      'type': type,
      'duration': duration,
      'requirements': requirements,
      'postedBy': postedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Returns a copy of this [Opportunity] with the given fields replaced.
  Opportunity copyWith({
    String? title,
    String? description,
    String? startupId,
    String? startupName,
    String? category,
    String? location,
    DateTime? deadline,
    String? type,
    String? duration,
    List<String>? requirements,
    String? postedBy,
    DateTime? createdAt,
  }) {
    return Opportunity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      startupId: startupId ?? this.startupId,
      startupName: startupName ?? this.startupName,
      category: category ?? this.category,
      location: location ?? this.location,
      deadline: deadline ?? this.deadline,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      requirements: requirements ?? this.requirements,
      postedBy: postedBy ?? this.postedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Returns the number of skills in [studentSkills] that also appear in
  /// [requirements] — used for the skill-match badge on opportunity cards.
  int matchScore(List<String> studentSkills) {
    final normalizedReqs = requirements.map((s) => s.toLowerCase()).toSet();
    final normalizedSkills = studentSkills.map((s) => s.toLowerCase()).toSet();
    return normalizedReqs.intersection(normalizedSkills).length;
  }

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get formattedDeadline =>
      '${_months[deadline.month - 1]} ${deadline.day}';

  @override
  String toString() {
    return '''
Opportunity
-----------------------
$title

Startup:
$startupName

Location:
$location

Category:
$category

Deadline:
$formattedDeadline

Requirements:
${requirements.join('\n')}''';
  }
}
