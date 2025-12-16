import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Views/HotelList.dart';
import 'package:travelmate/Views/TouristSpotsList.dart';
import 'package:travelmate/Views/MyTrips.dart';
import 'package:travelmate/Views/Activities.dart';
import 'package:travelmate/Views/Dining.dart';
import 'package:travelmate/Views/PaymentMethods.dart';

import 'package:travelmate/Views/HelpSupport.dart';
import 'package:travelmate/Views/PrivacyPolicy.dart';
import 'package:travelmate/Views/Saved.dart';
import 'package:travelmate/Views/Settings.dart'; // Added import

// ===== Header =====
Widget buildHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          const Text(
            'TravelMate',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00897B),
            ),
          ),
        ],
      ),
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF00897B).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: const Color(0xFF00897B),
          onPressed: () {},
        ),
      ),
    ],
  );
}

// ===== Location Input =====
Widget buildLocationInput(
  BuildContext context, {
  required TextEditingController controller,
  required IconData icon,
  required String hint,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF00897B)),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
      ),
    ),
  );
}

// ===== Search Section =====
Widget buildSearchSection(
  BuildContext context,
  TextEditingController startLocationController,
  TextEditingController destinationController, {
  VoidCallback? onSearch,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF00897B), Color(0xFF26A69A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF00897B).withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plan Your Journey',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        buildLocationInput(
          context,
          controller: startLocationController,
          icon: Icons.my_location,
          hint: 'Start Location',
        ),
        const SizedBox(height: 15),
        buildLocationInput(
          context,
          controller: destinationController,
          icon: Icons.location_on,
          hint: 'Destination',
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF00897B),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search),
                SizedBox(width: 8),
                Text(
                  'Search',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// ===== Popular Destinations =====
Widget buildPopularDestinations(
  List<Map<String, dynamic>> destinations,
  Function(Map<String, dynamic>)? onDestinationTap,
) {
  if (destinations.isEmpty) {
    return const SizedBox.shrink();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Popular Destinations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'See All',
              style: TextStyle(
                color: Color(0xFF00897B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 15),
      SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: destinations.length,
          itemBuilder: (context, index) {
            final dest = destinations[index];
            final imagePath = dest['image'] ?? 'assets/images/placeholder.jpg';
            final isNetworkImage = imagePath.toString().startsWith('http');

            return GestureDetector(
              onTap: () => onDestinationTap?.call(dest),
              child: Container(
                width: 140,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: isNetworkImage
                            ? Image.network(
                                imagePath,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: const Color(
                                        0xFF00897B,
                                      ).withOpacity(0.3),
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: Color(0xFF00897B),
                                        ),
                                      ),
                                    ),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                              )
                            : Image.asset(
                                imagePath,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: const Color(
                                        0xFF00897B,
                                      ).withOpacity(0.3),
                                      child: const Center(
                                        child: Icon(
                                          Icons.location_city,
                                          size: 40,
                                          color: Color(0xFF00897B),
                                        ),
                                      ),
                                    ),
                              ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dest['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dest['rating'] ?? '4.5',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

// ===== Quick Actions =====
Widget buildQuickActions(BuildContext context) {
  final actions = [
    {'icon': Icons.hotel, 'label': 'Hotels', 'color': const Color(0xFF00897B)},
    {'icon': Icons.tour, 'label': 'Tours', 'color': const Color(0xFF26A69A)},
    {
      'icon': Icons.restaurant,
      'label': 'Dining',
      'color': const Color(0xFF00897B),
    },
    {
      'icon': Icons.local_activity,
      'label': 'Activities',
      'color': const Color(0xFF26A69A),
    },
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Quick Actions',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF263238),
        ),
      ),
      const SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (action['label'] == 'Hotels') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HotelList()),
                  );
                } else if (action['label'] == 'Tours') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TouristSpotsList(),
                    ),
                  );
                } else if (action['label'] == 'Activities') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Activities()),
                  );
                } else if (action['label'] == 'Dining') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Dining()),
                  );
                } else {
                  SnackbarHelper.showInfo(
                    context,
                    'Opening ${action['label']}...',
                  );
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: (action['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Icon(
                      action['icon'] as IconData,
                      color: action['color'] as Color,
                      size: 30,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

// ===== Recent Searches =====
Widget buildRecentSearches(
  List<Map<String, String>> searches,
  VoidCallback onClear,
  Function(int) onDelete,
) {
  if (searches.isEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Searches',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF263238),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[50], // Light background
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Icon(Icons.history, size: 40, color: Colors.grey[400]),
              const SizedBox(height: 10),
              Text(
                'No recent searches',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
          TextButton(
            onPressed: onClear,
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      const SizedBox(height: 10),
      ...List.generate(searches.length, (index) {
        final search = searches[index];
        return buildSearchItem(
          search['from'] ?? '',
          search['to'] ?? '',
          onDelete: () => onDelete(index),
        );
      }),
    ],
  );
}

Widget buildSearchItem(String from, String to, {VoidCallback? onDelete}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF00897B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.history, color: Color(0xFF00897B), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '$from → $to',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onDelete != null)
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
            onPressed: onDelete,
            constraints: const BoxConstraints(), // Compact
            padding: EdgeInsets.zero,
          )
        else
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      ],
    ),
  );
}

// ===== Profile Widgets =====
Widget buildAppBar(
  bool isEditing,
  VoidCallback onEditTap, {
  String? photoURL,
  String? userName,
  VoidCallback? onPhotoTap,
}) {
  return SliverAppBar(
    expandedHeight: 200,
    floating: false,
    pinned: true,
    backgroundColor: const Color(0xFF00897B),
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00897B), Color(0xFF26A69A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Hero(
              tag: 'profile_avatar',
              child: GestureDetector(
                onTap: onPhotoTap,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: photoURL != null && photoURL.isNotEmpty
                            ? NetworkImage(photoURL)
                            : null,
                        child: photoURL == null || photoURL.isEmpty
                            ? Text(
                                userName != null && userName.isNotEmpty
                                    ? userName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00897B),
                                ),
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Color(0xFF00897B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      if (!isEditing)
        IconButton(icon: const Icon(Icons.edit), onPressed: onEditTap),
    ],
  );
}

Widget buildStatsSection(
  BuildContext context, {
  int trips = 0,
  int places = 0,
  int photos = 0,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(20),
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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildStatItem(context, trips.toString(), 'Trips', Icons.flight_takeoff),
        Container(width: 1, height: 40, color: Colors.grey[300]),
        buildStatItem(context, places.toString(), 'Saved', Icons.bookmark),
        Container(width: 1, height: 40, color: Colors.grey[300]),
        buildStatItem(context, photos.toString(), 'Photos', Icons.photo_camera),
      ],
    ),
  );
}

Widget buildStatItem(
  BuildContext context,
  String value,
  String label,
  IconData icon,
) {
  return Column(
    children: [
      Icon(icon, color: const Color(0xFF00897B), size: 24),
      const SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
    ],
  );
}

Widget buildDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Divider(height: 1, color: Colors.grey[200]),
  );
}

Widget buildMenuItem(
  BuildContext context,
  String title,
  IconData icon,
  VoidCallback onTap, {
  bool isDestructive = false,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red[50]
                    : const Color(0xFF00897B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive
                    ? Colors.red[700]
                    : const Color(0xFF00897B),
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDestructive
                      ? Colors.red[700]
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    ),
  );
}

Widget buildMenuSection(
  VoidCallback onLogout,
  BuildContext context, {
  VoidCallback? onSettingsReturn,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
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
    child: Column(
      children: [
        buildMenuItem(
          context,
          'My Trips',
          Icons.luggage,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyTrips()),
          ),
        ),
        buildDivider(),
        buildMenuItem(
          context,
          'Saved Places',
          Icons.bookmark,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Saved()),
          ),
        ),
        buildDivider(),
        buildMenuItem(
          context,
          'Payment Methods',
          Icons.payment,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PaymentMethods()),
          ),
        ),
        buildDivider(),
        buildMenuItem(context, 'Settings', Icons.settings, () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Settings()),
          );
          onSettingsReturn?.call();
        }),
        buildDivider(),
        buildMenuItem(
          context,
          'Help & Support',
          Icons.help_outline,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpSupport()),
          ),
        ),
        buildDivider(),
        buildMenuItem(
          context,
          'Privacy Policy',
          Icons.privacy_tip_outlined,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
          ),
        ),
        buildDivider(),
        buildMenuItem(
          context,
          'Logout',
          Icons.logout,
          onLogout,
          isDestructive: true,
        ),
      ],
    ),
  );
}

Widget buildInfoField(
  BuildContext context,
  String label,
  TextEditingController controller,
  IconData icon, {
  bool enabled = false,
  int maxLines = 1,
}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: enabled
              ? (isDarkMode ? Colors.grey[800] : Colors.grey[50])
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled
                ? const Color(0xFF00897B)
                : (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
          ),
        ),
        child: TextField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: enabled
                  ? const Color(0xFF00897B)
                  : (isDarkMode ? Colors.grey[500] : Colors.grey[400]),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildProfileInfo(
  TextEditingController nameController,
  TextEditingController emailController,
  TextEditingController phoneController,
  TextEditingController bioController,
  bool isEditing,
  bool isLoading,
  VoidCallback onCancel,
  VoidCallback onSave,
  BuildContext context,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(20),
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (isEditing)
              Row(
                children: [
                  TextButton(onPressed: onCancel, child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isLoading ? null : onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 20),
        buildInfoField(
          context,
          'Full Name',
          nameController,
          Icons.person_outline,
          enabled: isEditing,
        ),
        const SizedBox(height: 15),
        buildInfoField(
          context,
          'Email',
          emailController,
          Icons.email_outlined,
          enabled: isEditing,
        ),
        const SizedBox(height: 15),
        buildInfoField(
          context,
          'Phone',
          phoneController,
          Icons.phone_outlined,
          enabled: isEditing,
        ),
        const SizedBox(height: 15),
        buildInfoField(
          context,
          'Bio',
          bioController,
          Icons.info_outline,
          enabled: isEditing,
          maxLines: 2,
        ),
      ],
    ),
  );
}
