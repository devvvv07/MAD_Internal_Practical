import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String id;
  final String studentId;
  final String studentName;
  final DateTime timestamp;
  final String status; // e.g., 'Present', 'Absent'

  AttendanceModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.timestamp,
    required this.status,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> data, String documentId) {
    return AttendanceModel(
      id: documentId,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'Present',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status,
    };
  }
}
