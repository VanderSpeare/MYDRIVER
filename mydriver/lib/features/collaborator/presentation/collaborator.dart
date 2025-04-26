import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/logic/auth_controller.dart';
import '/../routes/app_routes.dart';

class CollaboratorPage extends StatelessWidget {
  const CollaboratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthController>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to the Admin Dashboard!\n(Role: Employee)',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
