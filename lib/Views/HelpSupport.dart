import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({Key? key}) : super(key: key);

  Future<void> _makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        SnackbarHelper.showError(context, 'Could not launch dialer');
      }
    } catch (e) {
      SnackbarHelper.showError(context, 'Error launching phone: $e');
    }
  }

  Future<void> _sendEmail(String email, BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request - TravelMate',
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        SnackbarHelper.showError(context, 'Could not launch email app');
      }
    } catch (e) {
      SnackbarHelper.showError(context, 'Error launching email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 16),
            _buildExpansionTile(
              'How do I book a hotel?',
              'Navigate to the "Hotels" section from the Home screen, select your desired hotel, choose your dates, and click "Book Now".',
            ),
            _buildExpansionTile(
              'How do I book a tour?',
              'Go to "Tours" or "Tourist Spots", select a place, and click "Book Ticket". You can select the date and number of tickets there.',
            ),
            _buildExpansionTile(
              'What payment methods are supported?',
              'We currently support credit/debit cards and cash on arrival for select bookings.',
            ),
            _buildExpansionTile(
              'How can I cancel my booking?',
              'Go to "My Trips" in your Profile, select the trip you want to cancel, and click the "Cancel" option.',
            ),
             _buildExpansionTile(
              'Is my data safe?',
              'Yes, we use Firebase authentication and secure storage to keep your data safe.',
            ),
            const SizedBox(height: 32),
             const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Need more help? Get in touch with our support team.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
             const SizedBox(height: 20),
            _buildContactCard(
              context,
              icon: Icons.phone,
              title: 'Phone Support',
              detail: '0306 6816806',
              onTap: () => _makePhoneCall('03066816806', context),
            ),
            const SizedBox(height: 16),
           _buildContactCard(
              context,
              icon: Icons.email,
              title: 'Email Support',
              detail: 'support2travelmateteam@gmail.com',
              onTap: () => _sendEmail('support2travelmateteam@gmail.com', context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF263238),
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            content,
            style: TextStyle(color: Colors.grey[700], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String detail,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
       elevation: 3,
       shadowColor: Colors.grey.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF00897B), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                  ],
                ),
              ),
               const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
