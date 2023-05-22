// In your main.dart file

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/image_service.dart';
import '../services/supabase_service.dart';
import '../screens/auth_view.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    var supabaseService = SupabaseService();
    var client = supabaseService.client;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(client, logger),
          //dispose: (_, AuthService service) => service.dispose(),
        ),
        Provider<UserService>(
          create: (context) {
            var authService = Provider.of<AuthService>(context, listen: false);
            return UserService(client, authService, logger);
          },
          //dispose: (_, UserService service) => service.dispose(),
        ),
        Provider<ImageService>(
          create: (context) {
            var authService = Provider.of<AuthService>(context, listen: false);
            return ImageService(client, authService, logger);
          },
          //dispose: (_, ImageService service) => service.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'My Flutter App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthenticationView(),
      ),
    );
  }
}
