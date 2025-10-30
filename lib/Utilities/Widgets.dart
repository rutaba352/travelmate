import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Views/SpotDetails.dart';  // ← ADD THIS
import 'package:travelmate/Views/HotelList.dart';  // ← ADD THIS
import 'package:travelmate/Views/TouristSpotsList.dart';  // ← ADD THIS
import 'package:travelmate/Views/MyTrips.dart';  // ← ADD THIS
import 'package:travelmate/Views/Settings.dart';  // ← ADD THIS
import 'package:travelmate/Views/LoginScreen.dart';  // ← ADD THIS
import 'package:travelmate/Views/Activities.dart';
import 'package:travelmate/Views/Dining.dart';
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
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
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
Widget buildLocationInput({
  required TextEditingController controller,
  required IconData icon,
  required String hint,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF00897B)),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
    ),
  );
}

// ===== Search Section =====
Widget buildSearchSection(
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
          controller: startLocationController,
          icon: Icons.my_location,
          hint: 'Start Location',
        ),
        const SizedBox(height: 15),
        buildLocationInput(
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
Widget buildPopularDestinations() {
  final destinations = [
    {'name': 'Paris', 'image': '🗼', 'rating': '4.8'},
    {'name': 'Tokyo', 'image': '🗾', 'rating': '4.9'},
    {'name': 'Dubai', 'image': '🏙️', 'rating': '4.7'},
    {'name': 'Bali', 'image': '🏝️', 'rating': '4.8'},
  ];

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
            return Container(
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00897B).withOpacity(0.7),
                          const Color(0xFF26A69A).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        dest['image']!,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dest['name']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dest['rating']!,
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
    {'icon': Icons.restaurant, 'label': 'Dining', 'color': const Color(0xFF00897B)},
    {'icon': Icons.local_activity, 'label': 'Activities', 'color': const Color(0xFF26A69A)},
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
      MaterialPageRoute(
        builder: (context) => const HotelList(),
      ),
    );
  } else if (action['label'] == 'Tours') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TouristSpotsList(cityName: 'Popular Tours'),
      ),
    );
  } else if (action['label'] == 'Activities') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Activities(),
      ),
    );
  } 
  else if (action['label'] == 'Dining') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const Dining(),
    ),
  );
}
else {
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
Widget buildRecentSearches() {
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
      buildSearchItem('New York', 'Los Angeles'),
      buildSearchItem('London', 'Edinburgh'),
      buildSearchItem('Mumbai', 'Goa'),
    ],
  );
}

Widget buildSearchItem(String from, String to) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(15),
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
          child: const Icon(
            Icons.history,
            color: Color(0xFF00897B),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$from → $to',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      ],
    ),
  );
}

// ===== Profile Widgets =====
Widget buildAppBar(
  bool isEditing,
  VoidCallback onEditTap,
) {
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
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF00897B),
                      ),
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
          ],
        ),
      ),
    ),
    actions: [
      if (!isEditing)
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEditTap,
        ),
    ],
  );
}

Widget buildStatsSection() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
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
        buildStatItem('24', 'Trips', Icons.flight_takeoff),
        Container(width: 1, height: 40, color: Colors.grey[300]),
        buildStatItem('156', 'Places', Icons.location_on),
        Container(width: 1, height: 40, color: Colors.grey[300]),
        buildStatItem('89', 'Photos', Icons.photo_camera),
      ],
    ),
  );
}

Widget buildStatItem(String value, String label, IconData icon) {
  return Column(
    children: [
      Icon(icon, color: const Color(0xFF00897B), size: 24),
      const SizedBox(height: 8),
      Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF263238),
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
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
                color:
                    isDestructive ? Colors.red[700] : const Color(0xFF00897B),
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
                      : const Color(0xFF263238),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildMenuSection(VoidCallback onLogout, BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.white,
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
          'My Trips',
          Icons.luggage,
          () => SnackbarHelper.showInfo(context, 'Opening My Trips'),
        ),
        buildDivider(),
        buildMenuItem(
          'Saved Places',
          Icons.bookmark,
          () => SnackbarHelper.showInfo(context, 'Opening Saved Places'),
        ),
        buildDivider(),
        buildMenuItem(
          'Payment Methods',
          Icons.payment,
          () => SnackbarHelper.showInfo(context, 'Opening Payment Methods'),
        ),
        buildDivider(),
        buildMenuItem(
          'Settings',
          Icons.settings,
              () => Navigator.pushNamed(context, '/settings'),
        ),
        buildDivider(),
        buildMenuItem(
          'Help & Support',
          Icons.help_outline,
          () => SnackbarHelper.showInfo(context, 'Opening Help & Support'),
        ),
        buildDivider(),
        buildMenuItem(
          'Privacy Policy',
          Icons.privacy_tip_outlined,
          () => SnackbarHelper.showInfo(context, 'Opening Privacy Policy'),
        ),
        buildDivider(),
        buildMenuItem(
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
  String label,
  TextEditingController controller,
  IconData icon, {
  bool enabled = false,
  int maxLines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: enabled ? Colors.grey[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? const Color(0xFF00897B) : Colors.grey[300]!,
          ),
        ),
        child: TextField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF263238),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: enabled ? const Color(0xFF00897B) : Colors.grey[400],
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
      color: Colors.white,
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
            const Text(
              'Profile Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
            if (isEditing)
              Row(
                children: [
                  TextButton(
                    onPressed: onCancel,
                    child: const Text('Cancel'),
                  ),
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
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
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
          'Full Name',
          nameController,
          Icons.person_outline,
          enabled: isEditing,
        ),
        const SizedBox(height: 15),
        buildInfoField(
          'Email',
          emailController,
          Icons.email_outlined,
          enabled: isEditing,
        ),
        const SizedBox(height: 15),
        buildInfoField(
          'Phone',
          phoneController,
          Icons.phone_outlined,
          enabled: isEditing,
        ),
        const SizedBox(height: 15),
        buildInfoField(
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