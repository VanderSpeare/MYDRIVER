import 'package:flutter/material.dart';
import 'package:mydriver/features/auth/presentation/screens/register.dart';
import '/features/auth/presentation/screens/login.dart';
import 'package:mydriver/features/welcome/presentation/welcome.dart';
import 'package:provider/provider.dart';
import 'features/auth/logic/auth_controller.dart';
import 'features/customer/logic/customer_controller.dart';
import 'features/driver/logic/driver_controller.dart';
import 'features/employee/logic/employee_controller.dart';
import 'features/welcome/logic/welcome_controller.dart';
import 'routes/app_routes.dart';
import 'features/booking/presentation/screens/booking.dart';
import 'features/collaborator/presentation/collaborator.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => CustomerController()),
        ChangeNotifierProvider(create: (_) => DriverController()),
        ChangeNotifierProvider(create: (_) => EmployeeController()),
        ChangeNotifierProvider(create: (_) => WelcomeController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Driver',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (context) => const WelcomePage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.booking: (context) => const BookingPage(),
        AppRoutes.collaborator: (context) => const CollaboratorPage(),
        // Add other routes as needed
      },
    );
  }
}
