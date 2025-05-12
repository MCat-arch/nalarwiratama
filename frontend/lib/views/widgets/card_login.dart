import 'package:flutter/material.dart';

class CardLogin extends StatelessWidget {
  final VoidCallback onLogin;
  final TextEditingController name;
  final TextEditingController password;
  final VoidCallback onSwitchToSignIn;
  // Terima state rememberMe dari induk
  // final ValueChanged<bool>
  // onRememberMeChanged; // Callback untuk perubahan rememberMe

  const CardLogin({
    super.key,
    required this.onLogin,
    required this.name,
    required this.password,
    required this.onSwitchToSignIn,
    // required this.onRememberMeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input Name
            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Input Password
            TextField(
              obscureText: true,
              controller: password,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Checkbox and Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (value) {
                        // onRememberMeChanged(value!);
                      },
                    ),
                    const Text('Remember Me'),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'FORGOT PASSWORD?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Login Button
            ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[800],
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'LOGIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Sign In Text
            TextButton(
              onPressed: onSwitchToSignIn, // Perbaiki pemanggilan callback
              child: const Text(
                'ALREADY HAVE AN ACCOUNT? SIGN IN',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
