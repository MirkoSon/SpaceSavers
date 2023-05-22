import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/signup_widget.dart';
import '../widgets/signin_widget.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  AuthenticationViewState createState() => AuthenticationViewState();
}

class AuthenticationViewState extends State<AuthenticationView> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Flutter App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            showLogin ? SignInWidget() : SignUpWidget(),
            TextButton(
              onPressed: () {
                setState(() {
                  showLogin = !showLogin;
                });
              },
              child: Text(showLogin ? 'Create Account' : 'Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
