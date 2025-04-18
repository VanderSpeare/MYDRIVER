/*import 'package:flutter/material.dart';
import '/components/social_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isLogin = true;

  final Color primaryColor = const Color(0xFF00D084);
  final Color secondaryColor = const Color(0xFF03045E);

  void toggleForm() => setState(() => isLogin = !isLogin);

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isLogin ? primaryColor : secondaryColor;
    final Color accentColor = isLogin ? secondaryColor : primaryColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Phạm Đại Trí - CNPM1'),
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildForm(context, accentColor),
          _buildSideToggle(accentColor),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, Color accentColor) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          children: [
            _buildHeaderIcon(accentColor),
            const SizedBox(height: 30),
            _buildTextField("Email", isLogin),
            const SizedBox(height: 12),
            _buildTextField("Password", isLogin, obscure: true),
            if (!isLogin) ...[
              const SizedBox(height: 12),
              _buildTextField("Confirm Password", false, obscure: true),
            ],
            if (isLogin)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 30),
            _buildActionButton(),
            const SizedBox(height: 25),
            Row(
              children: [
                const Expanded(child: Divider(color: Colors.white30)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Or connect with",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                const Expanded(child: Divider(color: Colors.white30)),
              ],
            ),
            const SizedBox(height: 16),
            _buildSocialRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(Color color) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white,
      child: Icon(Icons.lock_clock_rounded, size: 40, color: color),
    );
  }

  Widget _buildTextField(String hint, bool fillGreen, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: fillGreen ? Colors.green[300] : Colors.indigo[300],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: isLogin ? primaryColor : secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        isLogin ? "LOG IN" : "SIGN UP",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSocialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SocialButton(icon: Icons.facebook),
        SocialButton(icon: FontAwesomeIcons.linkedinIn),
        SocialButton(icon: FontAwesomeIcons.twitter),
      ],
    );
  }

  Widget _buildSideToggle(Color bgColor) {
    return Align(
      alignment: isLogin ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: toggleForm,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 45,
          height: double.infinity,
          color: bgColor,
          alignment: Alignment.center,
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              isLogin ? "SIGN UP" : "LOG IN",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/