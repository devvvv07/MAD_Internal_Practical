import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/attendance_viewmodel.dart';
import '../auth/login_screen.dart';
import '../../models/attendance_model.dart';

class InstructorDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final attendanceVM = Provider.of<AttendanceViewModel>(context, listen: false);

    final user = authVM.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Instructor Dashboard'),
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
                    color: Colors.blue.shade50,
                    child: ListTile(
                      leading: Icon(Icons.person_pin, size: 50, color: Colors.blue),
                      title: Text('Inst. ${user.name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: Text('Manage Courses & Classes'),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<AttendanceModel>>(
                    stream: attendanceVM.getAllAttendance(), // Ideally filtered by instructor's course
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                      if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text('No class records found.'));
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final record = snapshot.data![index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(child: Text(record.studentName[0].toUpperCase())),
                              title: Text(record.studentName),
                              subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(record.timestamp)),
                              trailing: Chip(
                                label: Text(record.status),
                                backgroundColor: Colors.green.shade100,
                              ),
                            ),
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
