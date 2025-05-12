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
                  fillColor: const Color.fromARGB(245, 245, 220, 100),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Input Email
              TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: const Color.fromARGB(245, 245, 220, 100),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Input Password
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: const Color.fromARGB(245, 245, 220, 100),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
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
                child: const Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              TextButton(
                onPressed: onSwitchToLogIn,
                child: const Text(
                  'ALREADY HAVE AN ACCOUNT? SIGN IN',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
