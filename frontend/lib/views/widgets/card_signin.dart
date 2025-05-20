import 'package:flutter/material.dart';

class CardSignIn extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onSwitchToLogIn;
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController password;

  const CardSignIn({
    super.key,
    required this.onSignIn,
    required this.name,
    required this.email,
    required this.password,
    required this.onSwitchToLogIn,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 252),
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
              SizedBox(height: 20),
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
              const SizedBox(height: 10),

              // Input Email
              TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
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

              // Input Password
              TextField(
                controller: password,
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
              const SizedBox(height: 20),

              // Button Sign In
              ElevatedButton(
                onPressed: () {
                  if (name.text.isEmpty ||
                      password.text.isEmpty ||
                      email.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  onSignIn();
                },
                child: const Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(217, 228, 228, 228),
                    letterSpacing: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  backgroundColor: const Color.fromARGB(139, 69, 19, 100),
                  foregroundColor: Color.fromARGB(218, 165, 32, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: onSwitchToLogIn,
                child: const Text(
                  'Sudah memiliki akun? Masuk',
                  style: TextStyle(color: Color.fromARGB(255, 222, 187, 31)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
