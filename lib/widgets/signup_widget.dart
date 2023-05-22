import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_view.dart';
import '../services/auth_service.dart';

class SignUpWidget extends StatelessWidget {
  SignUpWidget({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
        ),
        Consumer<AuthService>(
          builder: (context, authService, _) {
            if (authService.isLoading.value) {
              return const CircularProgressIndicator();
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  authService
                      .signUp(emailController.text, passwordController.text)
                      .then((user) {
                    if (user == null) {
                      // Sign-up failed, show a notification
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to sign up')),
                      );
                    } else {
                      // Sign-up was successful
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }
                  });
                },
                child: const Text('Sign up'),
              ),
            );
          },
        ),
      ],
    );
  }
}
