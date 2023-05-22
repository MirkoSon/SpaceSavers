import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacesavers/services/image_service.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class UserDetails extends StatefulWidget {
  final UserModel user;

  const UserDetails({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late AuthService authService;
  late UserService userService;
  late ImageService imageService;
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
    userService = Provider.of<UserService>(context, listen: false);
    imageService = Provider.of<ImageService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            Text('Credits: ${widget.user.credits}'),
            TextButton(
              onPressed: () async {
                final pickedImage = await imageService.pickImage();
                if (pickedImage != null) {
                  final imageName = await imageService.uploadImage(pickedImage);
                  if (imageName != null) {
                    // 'Image uploaded successfully: $imageName'
                    userService.updateUserDetails(avatarUrl: imageName);
                  } else {
                    //'Image upload failed'
                  }
                }
              },
              child: const Text('Upload Image'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Implement the function to update user details in AuthService.
                await userService.updateUserDetails(
                    name: _nameController.text, email: _emailController.text);
                // Update the UI.
                setState(() {});
              },
              child: const Text('Update Details'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
