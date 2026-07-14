import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a student's application to an opportunity.
class Application {
  final String id;
  final String opportunityId;
  final String studentId;
  final String startupId;
  final String studentName;
  final String studentEmail;
  final String phone;
  final String resumeUrl;
  final String coverLetter;
  final String status; // 'pending' / 'accepted' / 'rejected'
  final DateTime appliedAt;
  final String opportunityTitle;
  final String startupName;

  Application({
    required this.id,
    required this.opportunityId,
    required this.studentId,
    required this.startupId,
    required this.studentName,
    required this.studentEmail,
    required this.phone,
    required this.resumeUrl,
    required this.coverLetter,
    required this.status,
    required this.appliedAt,
    required this.opportunityTitle,
    required this.startupName,
  });

  /// Builds an [Application] from a Firestore document.
  factory Application.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return Application(
      id: doc.id,
      opportunityId: data['opportunityId'] ?? '',
      studentId: data['studentId'] ?? '',
      startupId: data['startupId'] ?? '',
      studentName: data['studentName'] ?? '',
      studentEmail: data['studentEmail'] ?? '',
      phone: data['phone'] ?? '',
      resumeUrl: data['resumeUrl'] ?? '',
      coverLetter: data['coverLetter'] ?? '',
      status: data['status'] ?? 'pending',
      appliedAt: (data['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      opportunityTitle: data['opportunityTitle'] ?? '',
      startupName: data['startupName'] ?? '',
    );
  }

  /// Converts this [Application] into a map suitable for writing to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'opportunityId': opportunityId,
      'studentId': studentId,
      'startupId': startupId,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'phone': phone,
      'resumeUrl': resumeUrl,
      'coverLetter': coverLetter,
      'status': status,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'opportunityTitle': opportunityTitle,
      'startupName': startupName,
    };
  }

  /// Returns a copy of this [Application] with the given fields replaced.
  Application copyWith({
    String? status,
    String? resumeUrl,
    String? opportunityTitle,
    String? startupName,
  }) {
    return Application(
      id: id,
      opportunityId: opportunityId,
      studentId: studentId,
      startupId: startupId,
      studentName: studentName,
      studentEmail: studentEmail,
      phone: phone,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      coverLetter: coverLetter,
      status: status ?? this.status,
      appliedAt: appliedAt,
      opportunityTitle: opportunityTitle ?? this.opportunityTitle,
      startupName: startupName ?? this.startupName,
    );
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

  String get formattedAppliedAt =>
      '${_months[appliedAt.month - 1]} ${appliedAt.day}, ${appliedAt.year}';

  String get statusLabel => status[0].toUpperCase() + status.substring(1);

  @override
  String toString() {
    return '''
Application
-----------------------
Student:
$studentName

Opportunity:
${opportunityTitle.isNotEmpty ? opportunityTitle : opportunityId}

Startup:
${startupName.isNotEmpty ? startupName : startupId}

Status:
$statusLabel

Applied:
$formattedAppliedAt''';
  }
}
