import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/attendance_viewmodel.dart';
import '../auth/login_screen.dart';
import '../../models/attendance_model.dart';

class StudentDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final attendanceVM = Provider.of<AttendanceViewModel>(context, listen: false);

    final user = authVM.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authVM.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          )
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.green.shade50,
                    child: ListTile(
                      leading: Icon(Icons.school, size: 50, color: Colors.green),
                      title: Text(user.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: Text(user.email),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.how_to_reg),
                  label: Text('Mark Attendance (Self)'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () async {
                    bool success = await attendanceVM.markAttendance(user.uid, user.name);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(success ? 'Attendance Marked!' : 'Failed to mark attendance')),
                    );
                  },
                ),
                SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<List<AttendanceModel>>(
                    stream: attendanceVM.getStudentAttendance(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                      if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text('No attendance records found.'));
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final record = snapshot.data![index];
                          return ListTile(
                            leading: Icon(Icons.check_circle, color: Colors.green),
                            title: Text(record.status),
                            subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(record.timestamp)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
