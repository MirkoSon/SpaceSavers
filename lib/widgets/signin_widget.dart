import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_view.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class SignInWidget extends StatelessWidget {
  SignInWidget({Key? key}) : super(key: key);
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
                  final userService =
                      Provider.of<UserService>(context, listen: false);
                  authService
                      .signIn(emailController.text, passwordController.text,
                          userService)
                      .then((user) {
                    if (user == null) {
                      // Sign-in failed, show a notification
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to sign in')),
                      );
                    } else {
                      print(authService);
                      // Sign-in was successful
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          if (authService.currentUser == null) {
                            print('Current user is null');
                            return const CircularProgressIndicator();
                          } else {
                            return const HomePage();
                          }
                        }),
                      );
                    }
                  });
                },
                child: const Text('Log in'),
              ),
            );
          },
        ),
      ],
    );
  }
}
