import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;

  const SocialButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }
}
