import 'package:flutter/material.dart';
import '/../../routes/app_routes.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.map);
              },
              child: const Text('Select Location on Map'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.vehicleSelection);
              },
              child: const Text('Select Vehicle Type'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.rental);
              },
              child: const Text('Rent a Car'),
            ),
          ],
        ),
      ),
    );
  }
}