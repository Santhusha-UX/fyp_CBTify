// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Make sure to add flutter_secure_storage to your pubspec.yaml
import 'relaxation_page.dart';

class AuthBackend {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<bool> signUp(String email, String password, String name) async {
    final usersStr = await _storage.read(key: 'users');
    final users = usersStr != null ? json.decode(usersStr) as Map<String, dynamic> : {};

    if (users.containsKey(email)) {
      return false; // User already exists
    }

    users[email] = json.encode({'password': password, 'name': name});
    await _storage.write(key: 'users', value: json.encode(users));
    return true;
  }

  static Future<bool> signIn(String email, String password) async {
    final usersStr = await _storage.read(key: 'users');
    final users = usersStr != null ? json.decode(usersStr) as Map<String, dynamic> : {};

    if (!users.containsKey(email) || json.decode(users[email])['password'] != password) {
      return false; // User not found or password mismatch
    }

    return true;
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Welcome Back' : 'Join Us'),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/images/CBTify.png', height: 200),
                Text(
                  _isLogin ? 'Login to continue' : 'Create your account',
                  style: const TextStyle(fontSize: 16, color: Colors.white54),
                ),
                const SizedBox(height: 20),
                if (!_isLogin)
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      onPressed: _authenticate,
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                    ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin ? 'Create new account' : 'I already have an account'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _authenticate() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    bool success;
    if (_isLogin) {
      success = await AuthBackend.signIn(email, password);
    } else {
      success = await AuthBackend.signUp(email, password, name);
    }

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, RelaxationScreen.routeName);
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(_isLogin ? 'Could not log in. Please check your credentials.' : 'Sign up failed. Email may already be in use.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
