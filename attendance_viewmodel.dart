import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/firebase_service.dart';

class AttendanceViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> markAttendance(String studentId, String studentName) async {
    _setLoading(true);
    _setError(null);
    try {
      await _firebaseService.markAttendance(studentId, studentName);
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  Stream<List<AttendanceModel>> getAllAttendance() {
    return _firebaseService.getAttendanceRecords();
  }

  Stream<List<AttendanceModel>> getStudentAttendance(String studentId) {
    return _firebaseService.getStudentAttendanceRecords(studentId);
  }
}
