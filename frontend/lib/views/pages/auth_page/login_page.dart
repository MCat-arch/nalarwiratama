import 'package:flutter/material.dart';
import 'package:frontend/services/user_repository.dart';
import 'package:frontend/views/widget_tree.dart';
import 'package:frontend/views/pages/auth_page/signin_page.dart';
import 'package:frontend/views/widgets/card_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserRepository _userRepo = UserRepository();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: Image.asset('assets/images/login.png').image,
              fit: BoxFit.cover,
            ),
          ),
          CardLogin(
            name: _nameController,
            password: _passwordController,
            onLogin: () async {
              if (_nameController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              final success = await _userRepo.login(
                _nameController.text,
                _passwordController.text,
              );
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login successful!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WidgetTree()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login failed. Check credentials.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            onSwitchToSignIn: () {
              print('Switching to Sign In');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
