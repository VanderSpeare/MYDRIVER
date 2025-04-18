import 'package:flutter/material.dart';
import '/routes/app_routes.dart';

class WelcomeController with ChangeNotifier {
  void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  void navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  void navigateToDriverRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.driverRegister);
  }
}
