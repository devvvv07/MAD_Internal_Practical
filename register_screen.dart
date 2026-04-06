import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../student/student_dashboard_screen.dart';
import '../instructor/instructor_dashboard_screen.dart';
import '../admin/admin_dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedRole = 'student';

  void _routeUser(BuildContext context, String role) {
    if (role == 'admin') {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => AdminDashboardScreen()), (route) => false);
    } else if (role == 'instructor') {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => InstructorDashboardScreen()), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => StudentDashboardScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                obscureText: true,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(labelText: 'Role', border: OutlineInputBorder()),
                items: [
                  DropdownMenuItem(value: 'student', child: Text('Student')),
                  DropdownMenuItem(value: 'instructor', child: Text('Instructor')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _selectedRole = value);
                },
              ),
              SizedBox(height: 20),
              if (authVM.errorMessage != null)
                Text(authVM.errorMessage!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 20),
              authVM.isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        bool success = await authVM.register(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          _nameController.text.trim(),
                          _selectedRole,
                        );
                        if (success && authVM.currentUser != null) {
                          _routeUser(context, authVM.currentUser!.role);
                        }
                      },
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                      child: Text('Register'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
