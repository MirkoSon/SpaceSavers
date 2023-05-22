import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../screens/auth_view.dart';
import '../screens/details_view.dart';
import '../services/auth_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    const String defaultUrl =
        "https://qwtyrzzptgfkgezhahwb.supabase.co/storage/v1/object/public/assets/user.png?t=2023-05-21T09%3A14%3A59.021Z";

    return StreamBuilder<UserModel?>(
      stream:
          authService.authStateChanges.map((event) => authService.currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBar(title: const Text('Loading...'));
        }

        final user = snapshot.data;

        return AppBar(
          title: const Text('Home Page'),
          actions: user != null
              ? [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetails(
                            user: user,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: CachedNetworkImageProvider(
                            user.avatarUrl ?? defaultUrl),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      authService.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthenticationView()),
                      );
                    },
                  ),
                ]
              : [],
        );
      },
    );
  }
}
