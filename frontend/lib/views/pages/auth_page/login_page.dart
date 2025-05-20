import 'package:flutter/material.dart';
import 'package:frontend/services/user_repository.dart';
import 'package:frontend/views/widget_tree.dart';
import 'package:frontend/views/pages/auth_page/signin_page.dart';
import 'package:frontend/views/widgets/card_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserRepository _userRepo = UserRepository();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    _loadRememberMePreference().then((value) {
      setState(() {
        _rememberMe = value;
      });
    });
  }

  Future<void> saveRememberMePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', value);
  }

  Future<bool> _loadRememberMePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('remember_me') ?? false;
  }

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
            rememberMeValue: _rememberMe,
            onRememberMeChanged: (value) {
              setState(() {
                _rememberMe = value; // Perbarui state Remember Me
              });
              print('Remember Me: $_rememberMe'); // Debugging log
            },
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
