import 'package:flutter/material.dart';
import 'package:travelmate/Services/Auth/AuthException.dart';
import 'package:travelmate/Services/Auth/AuthServices.dart';
import 'package:travelmate/Services/UserService.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelmate/Services/StorageService.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  late final AuthService _authService;
  final UserService _userService = UserService();

  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  String? _photoURL;

  @override
  void initState() {
    super.initState();
    _authService = AuthService.firebase();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final user = _authService.currentUser;

    if (user != null) {
      // Auth Data
      _nameController.text = user.displayName ?? '';
      _photoURL = user.photoURL;

      // Firestore Data
      try {
        final userData = await _userService.getUserData(user.id);
        if (userData != null) {
          if (userData['name'] != null && userData['name'].isNotEmpty) {
             _nameController.text = userData['name'];
          }
          _bioController.text = userData['bio'] ?? '';
          _phoneController.text = userData['phoneNumber'] ?? '';
        }
      } catch (e) {
        if (mounted) SnackbarHelper.showError(context, 'Error loading profile');
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final user = _authService.currentUser;

    if (user != null) {
      try {
        // 1. Update Auth Display Name
        await _authService.updateUser(displayName: _nameController.text);

        // 2. Update Firestore Data
        await _userService.updateUserData(user.id, {
          'name': _nameController.text,
          'bio': _bioController.text,
          'phoneNumber': _phoneController.text,
        });

        if (mounted) {
          SnackbarHelper.showSuccess(context, 'Profile updated successfully');
          Navigator.pop(context, true); // Return true to trigger refresh
        }
      } catch (e) {
        if (mounted) {
          SnackbarHelper.showError(context, 'Failed to update profile: $e');
        }
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  // --- Change Password Logic (Reused from Settings) ---
  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verify it\'s you',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please enter your current password to continue.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (oldPasswordController.text.isEmpty) {
                SnackbarHelper.showError(context, 'Enter current password');
                return;
              }

              try {
                await _authService.reauthenticate(oldPasswordController.text);
                if (mounted) {
                  Navigator.pop(context);
                  _showNewPasswordDialog();
                }
              } on WrongPasswordAuthException {
                if (mounted) SnackbarHelper.showError(context, 'Incorrect password');
              } catch (e) {
                if (mounted) SnackbarHelper.showError(context, 'Error: $e');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00897B)),
            child: const Text('NEXT'),
          ),
        ],
      ),
    );
  }

  void _showNewPasswordDialog() {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set New Password'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock_outline), // Fixed icon
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text.length < 6) {
                SnackbarHelper.showError(context, 'Password too short (min 6)');
                return;
              }
              if (newPasswordController.text != confirmPasswordController.text) {
                SnackbarHelper.showError(context, 'Passwords do not match');
                return;
              }

              try {
                await _authService.updatePassword(newPasswordController.text);
                if (mounted) {
                  Navigator.pop(context);
                  SnackbarHelper.showSuccess(context, 'Password updated!');
                }
              } on WeakPasswordAuthException {
                if (mounted) SnackbarHelper.showError(context, 'Password too weak');
              } catch (e) {
                if (mounted) SnackbarHelper.showError(context, 'Error: $e');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00897B)),
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    print('Picking image from source: $source');
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image == null) {
        print('No image picked');
        return;
      }
      print('Image picked: ${image.path}');

      setState(() => _isLoading = true);

      // Upload
      final storageService = StorageService();
      print('Calling uploadProfileImage...');
      final downloadUrl = await storageService.uploadProfileImage(
        image,
        _authService.currentUser!.id,
      );
      print('Upload finished. URL: $downloadUrl');

      // Update Auth
      print('Updating user profile...');
      await _authService.updateUser(photoURL: downloadUrl);

      setState(() {
        _photoURL = downloadUrl;
      });
      print('State updated with new URL');

      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Profile photo updated!');
      }
    } catch (e) {
      print('Error in _pickAndUploadImage: $e');
      if (mounted) {
        SnackbarHelper.showError(context, 'Error updating photo: $e');
      }
    } finally {
      print('Finished _pickAndUploadImage');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        bool isDesktop = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isDesktop) ...[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndUploadImage(ImageSource.camera);
                  },
                ),
              ],
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(isDesktop ? 'Select Photo' : 'Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndUploadImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
        actions: [
          if (_isLoading)
            const Center(child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
            ))
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: _isLoading && _nameController.text.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00897B)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                        GestureDetector(
                          onTap: _showImageSourceDialog,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: _photoURL != null 
                                    ? NetworkImage(_photoURL!) 
                                    : null,
                                child: _photoURL == null 
                                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00897B),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        prefixIcon: Icon(Icons.info_outline),
                        border: OutlineInputBorder(),
                        helperText: 'A short description about yourself',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      leading: const Icon(Icons.lock_outline, color: Color(0xFF00897B)),
                      title: const Text('Change Password'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _showChangePasswordDialog,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
