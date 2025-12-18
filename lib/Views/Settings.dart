import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/Services/Auth/AuthServices.dart';
import 'package:travelmate/Services/ThemeService.dart';
import 'package:travelmate/Services/Auth/AuthException.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Views/EditProfile.dart';
import 'package:travelmate/Views/HelpSupport.dart';
import 'package:travelmate/Views/PrivacyPolicy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travelmate/Views/LoginScreen.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _locationServices = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          _buildSectionHeader('Account Settings'),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfile()),
              ),
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: _showChangePasswordDialog,
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.security,
              title: 'Privacy & Security',
              subtitle: 'Manage your privacy settings',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
              ),
            ),
          ]),

          const SizedBox(height: 20),

          const SizedBox(height: 20),

          const SizedBox(height: 20),

          // Preferences Section
          _buildSectionHeader('Preferences'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.location_on_outlined,
              title: 'Location Services',
              subtitle: 'Use your location for better results',
              value: _locationServices,
              onChanged: (value) {
                setState(() => _locationServices = value);
              },
            ),
            _buildDivider(),
            _buildSwitchTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Enable dark theme',
              value: Provider.of<ThemeService>(context).isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeService>(
                  context,
                  listen: false,
                ).toggleTheme(value);
              },
            ),
          ]),

          const SizedBox(height: 20),

          // Support Section
          _buildSectionHeader('Support'),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help with your account',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupport()),
              ),
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.feedback_outlined,
              title: 'Send Feedback',
              subtitle: 'Share your thoughts with us',
              onTap: _showFeedbackDialog,
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.star_outline,
              title: 'Rate Us',
              subtitle: 'Rate TravelMate on the store',
              onTap: _showRatingDialog,
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'Version 1.0.0',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('About TravelMate'),
                    content: const Text(
                      'TravelMate is your ultimate travel companion, helping you discover new places, book flights and hotels, and create unforgettable memories.\n\nVersion: 1.0.0\nDeveloped by the TravelMate Team.',
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ]),

          const SizedBox(height: 20),

          const SizedBox(height: 20),

          const SizedBox(height: 20),

          // Danger Zone
          _buildSectionHeader('Danger Zone'),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context); // Close dialog
                          try {
                            await AuthService.firebase().logOut();
                            if (context.mounted) {
                              SnackbarHelper.showSuccess(
                                context,
                                'Logged out successfully',
                              );
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              SnackbarHelper.showError(
                                context,
                                'Failed to logout',
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00897B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('LOGOUT'),
                      ),
                    ],
                  ),
                );
              },
              textColor: const Color(0xFF00897B),
            ),
          ]),

          const SizedBox(height: 40),

          // Footer
          Center(
            child: Text(
              'TravelMate © 2024\nMade with ❤️ for travelers',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00897B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (textColor ?? const Color(0xFF00897B)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: textColor ?? const Color(0xFF00897B),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF00897B).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF00897B), size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF263238),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF00897B),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 68, color: Colors.grey[200]);
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final authService = AuthService.firebase();

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
                await authService.reauthenticate(oldPasswordController.text);
                if (mounted) {
                  Navigator.pop(context); // Close old pass dialog
                  _showNewPasswordDialog(context, authService);
                }
              } on WrongPasswordAuthException {
                if (mounted) {
                  SnackbarHelper.showError(context, 'Incorrect password');
                }
              } catch (e) {
                if (mounted) {
                  SnackbarHelper.showError(context, 'Error: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              foregroundColor: Colors.white,
            ),
            child: const Text('NEXT'),
          ),
        ],
      ),
    );
  }

  void _showNewPasswordDialog(BuildContext context, AuthService authService) {
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
              if (newPasswordController.text.isEmpty) {
                SnackbarHelper.showError(context, 'Enter new password');
                return;
              }
              if (newPasswordController.text.length < 6) {
                SnackbarHelper.showError(context, 'Password too short');
                return;
              }
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                SnackbarHelper.showError(context, 'Passwords do not match');
                return;
              }

              try {
                await authService.updatePassword(newPasswordController.text);
                if (context.mounted) {
                  Navigator.pop(context);
                  SnackbarHelper.showSuccess(
                    context,
                    'Password updated successfully',
                  );
                }
              } on WeakPasswordAuthException {
                if (context.mounted) {
                  SnackbarHelper.showError(context, 'Password is too weak');
                }
              } catch (e) {
                if (context.mounted) {
                  SnackbarHelper.showError(
                    context,
                    'Error updating password: $e',
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              foregroundColor: Colors.white,
            ),
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'We value your feedback! Please let us know how we can improve.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE0F2F1),
                child: Icon(Icons.email, color: Color(0xFF00897B)),
              ),
              title: const Text(
                'Email Us',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('support2travelmateteam@gmail.com'),
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'support2travelmateteam@gmail.com',
                  query: 'subject=TravelMate Feedback',
                );

                try {
                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri);
                  } else {
                    if (mounted) {
                      SnackbarHelper.showError(
                        context,
                        'Could not launch email app',
                      );
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    SnackbarHelper.showError(context, 'Error launching email');
                  }
                }
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    int selectedRating = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Center(child: Text('Rate Us')),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'How was your experience?',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < selectedRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedRating == 0) {
                    SnackbarHelper.showError(context, 'Please select a rating');
                    return;
                  }
                  Navigator.pop(context);
                  SnackbarHelper.showSuccess(
                    context,
                    'Thank you for rating us $selectedRating stars!',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                ),
                child: const Text('SUBMIT'),
              ),
            ],
          );
        },
      ),
    );
  }
}
