import 'package:flutter/material.dart';
import 'package:travelmate/Services/Auth/AuthException.dart';
import 'package:travelmate/Services/Auth/AuthServices.dart';
import 'package:travelmate/Services/UserService.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/Widgets.dart';
import 'package:travelmate/Services/SavedItemsService.dart';
import 'package:travelmate/Views/EditProfile.dart';
import 'package:travelmate/Views/LoginScreen.dart';
import 'package:travelmate/Views/MyTrips.dart';
import 'package:travelmate/Services/DataSeeder.dart';
import 'package:travelmate/Views/MainNavigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelmate/Services/StorageService.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isEditing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? _photoURL;

  final UserService _userService = UserService();
  final SavedItemsService _savedItemsService = SavedItemsService();

  final TextEditingController _nameController = TextEditingController(
    text: 'John Anderson',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'john.anderson@email.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+1 234 567 8900',
  );
  final TextEditingController _bioController = TextEditingController(
    text: 'Adventure seeker | World explorer 🌍',
  );

  late final AuthService _authService;

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

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;

    if (user != null) {
      if (!mounted) return;

      // First, set data from Firebase Auth (works for Google Sign-In)
      setState(() {
        _emailController.text = user.email;
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          _nameController.text = user.displayName!;
        }
        _photoURL = user.photoURL;
      });

      // Then try to get additional data from Firestore
      try {
        final userData = await _userService.getUserData(user.id);

        if (userData != null && mounted) {
          setState(() {
            if (userData['name'] != null &&
                userData['name'].toString().isNotEmpty) {
              if (user.displayName == null || user.displayName!.isEmpty) {
                _nameController.text = userData['name'];
              }
            }
            _phoneController.text = userData['phoneNumber'] ?? 'Not provided';
            if (userData['bio'] != null &&
                userData['bio'].toString().isNotEmpty) {
              _bioController.text = userData['bio'];
            }
          });
        }
      } catch (e) {
        // Silent error
      }
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
    await _loadUserData();
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
                borderRadius: BorderRadius.circular(8),
              ),
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

      // Refresh
      await _loadUserData();

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
    // Check for Desktop (Windows/Linux/MacOS) where camera might not be supported directly
    // simplified: just show both options, but knowing they might open file picker
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
          ],
        ),
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
            buildAppBar(
              _isEditing,
              () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfile()),
                );
                _loadUserData();
              },
              photoURL: _photoURL,
              userName: _nameController.text,
              onPhotoTap: _showImageSourceDialog,
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Nested StreamBuilders for real-time stats
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _savedItemsService.getBookingsStream(),
                      builder: (context, bookingsSnapshot) {
                        return StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _savedItemsService.getSavedItemsStream(),
                          builder: (context, savedSnapshot) {
                            final bookingsCount =
                                bookingsSnapshot.data?.length ?? 0;
                            final savedCount = savedSnapshot.data?.length ?? 0;

                            return buildStatsSection(
                              context,
                              trips: bookingsCount,
                              places: savedCount,
                              photos: 12, // Placeholder
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildMyPlansPreviewStream(),
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
                    buildMenuSection(
                      _showLogoutDialog,
                      context,
                      onSettingsReturn: _loadUserData,
                    ),
                    const SizedBox(height: 20),
                    // Developer Tools
                    ExpansionTile(
                      title: const Text(
                        'Developer Options',
                        style: TextStyle(color: Colors.grey),
                      ),
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.cloud_upload,
                            color: Colors.orange,
                          ),
                          title: const Text('Seed Data to Firestore'),
                          subtitle: const Text('Upload static hotels & spots'),
                          onTap: () async {
                            try {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );

                              // Call Seeder
                              final seeder = DataSeeder();
                              await seeder.seedTouristSpots();
                              await seeder.seedHotels();

                              if (context.mounted) {
                                Navigator.pop(context); // Close loading
                                SnackbarHelper.showSuccess(
                                  context,
                                  'Data Seeded Successfully!',
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.pop(context);
                                SnackbarHelper.showError(
                                  context,
                                  'Seeding Failed: $e',
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
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

  Widget _buildMyPlansPreviewStream() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _savedItemsService.getBookingsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final plans = snapshot.data!.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Plans',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      MainNavigation.switchTab(
                        2,
                      ); // Switch to My Trips (Need to add My Trips tab or navigate)
                      // Actually My Trips is a separate page usually reachable from "See All"
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyTrips(),
                        ),
                      );
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(color: Color(0xFF00897B)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 12, bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00897B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getPlanIcon(plan['category'] ?? 'General'),
                                size: 20,
                                color: const Color(0xFF00897B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                plan['name'] ?? 'Trip',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          plan['category'] ?? 'General',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              plan['startDate'] ?? 'Upcoming',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Booked',
                              style: TextStyle(
                                color: const Color(0xFF00897B),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getPlanIcon(String category) {
    if (category == 'Flights') return Icons.flight;
    if (category == 'Hotels') return Icons.hotel;
    if (category == 'Activities') return Icons.local_activity;
    if (category == 'Restaurants') return Icons.restaurant;
    return Icons.card_travel;
  }
}
