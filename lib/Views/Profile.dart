import 'package:flutter/material.dart';
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

  final TextEditingController _nameController =
      TextEditingController(text: 'John Anderson');
  final TextEditingController _emailController =
      TextEditingController(text: 'john.anderson@email.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+1 234 567 8900');
  final TextEditingController _bioController =
      TextEditingController(text: 'Adventure seeker | World explorer 🌍');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
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
            onPressed: () {
              Navigator.pop(context);
              SnackbarHelper.showSuccess(context, 'Logged out successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: const Color(0xFF00897B),
        child: CustomScrollView(
          slivers: [
            buildAppBar(_isEditing, () {
              setState(() => _isEditing = true);
              SnackbarHelper.showInfo(context, 'Edit mode enabled');
            }),
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