import 'package:flutter/material.dart';

class CardLogin extends StatelessWidget {
  final VoidCallback onLogin;
  final TextEditingController name;
  final TextEditingController password;
  final VoidCallback onSwitchToSignIn;
  // Terima state rememberMe dari induk
  final ValueChanged<bool> onRememberMeChanged;
  final bool rememberMeValue; // Callback untuk perubahan rememberMe

  const CardLogin({
    super.key,
    required this.onLogin,
    required this.name,
    required this.password,
    required this.onSwitchToSignIn,
    required this.onRememberMeChanged,
    required this.rememberMeValue,
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
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 205, 204, 185),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: const Color.fromARGB(245, 255, 246, 205),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(245, 190, 161, 33),
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(245, 190, 161, 33),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 165, 235, 167),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Input Password
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 205, 204, 185),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: const Color.fromARGB(245, 255, 246, 205),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(245, 190, 161, 33),
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(245, 190, 161, 33),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 165, 235, 167),
                    width: 1.5,
                  ),
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
                      value: rememberMeValue,
                      onChanged: (value) {
                        onRememberMeChanged(value!);
                      },
                    ),
                    const Text('Remember Me'),
                  ],
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
                'Belum Memiliki Akun? Daftar',
                style: TextStyle(color: Color.fromARGB(255, 222, 187, 31)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
