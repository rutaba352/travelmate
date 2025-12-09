import 'package:flutter/material.dart';
import 'package:travelmate/Services/Auth/AuthException.dart';
import 'package:travelmate/Services/Auth/AuthServices.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/Widgets.dart';
import 'package:travelmate/Views/LoginScreen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isEditing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController(text: '+1 234 567 8900');
  final TextEditingController _bioController =
      TextEditingController(text: 'Adventure seeker | World explorer 🌍');

  late final AuthService _authService;
  String? _photoURL;

  @override
  void initState() {
    super.initState();
    _authService = AuthService.firebase();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _authService.currentUser;
    if (user != null) {
      setState(() {
        _emailController.text = user.email;
        _photoURL = user.photoURL;
        
        // Set display name if available (from Google Sign-In)
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          _nameController.text = user.displayName!;
        } else {
          // Extract name from email as fallback
          final emailName = user.email.split('@')[0];
          _nameController.text = emailName.replaceAll('.', ' ').split(' ')
              .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
              .join(' ');
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isEditing = false;
      });

      SnackbarHelper.showSuccess(context, 'Profile updated successfully!');
    }
  }

  Future<void> _refreshProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    _loadUserData(); // Reload user data
    if (mounted) {
      SnackbarHelper.showSuccess(context, 'Profile refreshed');
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _handleLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      await _authService.logOut();
      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Logged out successfully');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } on UserNotLoggedInAuthException {
      if (mounted) {
        SnackbarHelper.showError(context, 'No user is currently logged in');
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(
          context,
          'Failed to logout. Please try again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: const Color(0xFF00897B),
        child: CustomScrollView(
          slivers: [
            // Custom AppBar with profile picture
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: const Color(0xFF00897B),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  _nameController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF00897B),
                        const Color(0xFF00897B).withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: _photoURL != null
                              ? NetworkImage(_photoURL!)
                              : null,
                          child: _photoURL == null
                              ? Text(
                                  _nameController.text.isNotEmpty
                                      ? _nameController.text[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00897B),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                if (!_isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      setState(() => _isEditing = true);
                      SnackbarHelper.showInfo(context, 'Edit mode enabled');
                    },
                  ),
              ],
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    buildStatsSection(),
                    const SizedBox(height: 20),
                    buildProfileInfo(
                      _nameController,
                      _emailController,
                      _phoneController,
                      _bioController,
                      _isEditing,
                      _isLoading,
                      () => setState(() => _isEditing = false),
                      _saveProfile,
                      context,
                    ),
                    const SizedBox(height: 20),
                    buildMenuSection(_showLogoutDialog, context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}