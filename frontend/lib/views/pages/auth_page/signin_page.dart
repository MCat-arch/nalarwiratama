import 'package:flutter/material.dart';
import 'package:frontend/services/user_repository.dart';
import 'package:frontend/views/widgets/card_signin.dart';
import 'package:frontend/views/pages/auth_page/login_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final UserRepository _userRepo = UserRepository();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: const Color.fromARGB(132, 235, 231, 200),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 40),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign In',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image(
                    image: Image.asset('/images/signin.png').image,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30),
                CardSignIn(
                  name: _nameController,
                  email: _emailController,
                  password: _passwordController,
                  onSignIn: () async {
                    if (_nameController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    final success = await _userRepo.signIn(
                      _emailController.text,
                      _passwordController.text,
                      _nameController.text,
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sign in successful!'),
                          backgroundColor: Colors.green,
                        ),
                        // _userRepo.saveUser(success)
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Sign in failed. User may already exist.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  onSwitchToLogIn: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
