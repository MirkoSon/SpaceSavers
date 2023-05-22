import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacesavers/widgets/appbar_widget.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    const String defaultUrl =
        "https://qwtyrzzptgfkgezhahwb.supabase.co/storage/v1/object/public/assets/user.png?t=2023-05-21T09%3A14%3A59.021Z";

    UserModel? user = authService.currentUser;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: () {
          if (user != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // Handle user avatar tapping for editing.
                    // Navigate to user profile editing page.
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.avatarUrl ?? defaultUrl),
                  ),
                ),
                const SizedBox(height: 20),
                Text('User ID: ${user.id}'),
              ],
            );
          } else {
            return const Text('No user is currently signed in.');
          }
        }(),
      ),
    );
  }
}
