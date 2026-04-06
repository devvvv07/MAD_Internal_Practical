import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/attendance_viewmodel.dart';
import '../auth/login_screen.dart';
import '../../models/attendance_model.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final attendanceVM = Provider.of<AttendanceViewModel>(context, listen: false);

    final user = authVM.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
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
                    color: Colors.red.shade50,
                    child: ListTile(
                      leading: Icon(Icons.admin_panel_settings, size: 50, color: Colors.red),
                      title: Text('Admin: ${user.name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: Text('Full System Access'),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<AttendanceModel>>(
                    stream: attendanceVM.getAllAttendance(), // Admins see everything
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                      if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text('No system records found.'));
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final record = snapshot.data![index];
                          return ListTile(
                            leading: Icon(Icons.history),
                            title: Text('${record.studentName} - ${record.status}'),
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
