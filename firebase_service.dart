import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/attendance_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication
  Future<UserModel?> loginUser(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return await getUserDetails(credential.user!.uid);
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
    return null;
  }

  Future<UserModel?> registerUser(String email, String password, String name, String role) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        UserModel newUser = UserModel(
          uid: credential.user!.uid,
          email: email,
          name: name,
          role: role,
        );
        await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print('Error getting user details: $e');
    }
    return null;
  }

  User? get currentUser => _auth.currentUser;

  // Attendance
  Future<void> markAttendance(String studentId, String studentName) async {
    try {
      final attendance = AttendanceModel(
        id: '',
        studentId: studentId,
        studentName: studentName,
        timestamp: DateTime.now(),
        status: 'Present',
      );
      await _firestore.collection('attendance').add(attendance.toMap());
    } catch (e) {
      throw Exception('Failed to mark attendance: ${e.toString()}');
    }
  }

  Stream<List<AttendanceModel>> getAttendanceRecords() {
    return _firestore
        .collection('attendance')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AttendanceModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<AttendanceModel>> getStudentAttendanceRecords(String studentId) {
    return _firestore
        .collection('attendance')
        .where('studentId', isEqualTo: studentId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AttendanceModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
