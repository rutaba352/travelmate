import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: December 16, 2025',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Information We Collect',
              'We collect information you provide directly to us, such as when you create or modify your account, request on-demand services, contact customer support, or otherwise communicate with us. This information may include: name, email, phone number, and payment method.',
            ),
            _buildSection(
              '2. How We Use Your Data',
              'We use the information we collect to provide, maintain, and improve our services, such as to process payments, send receipts, provide customer support, and send updates and administrative messages.',
            ),
            _buildSection(
              '3. Data Security',
              'We implement appropriate technical and organizational measures to help protect your personal information from unauthorized access, use, disclosure, alteration, or destruction. We use Firebase services which provide industry-standard security.',
            ),
            _buildSection(
              '4. Sharing of Information',
              'We may share the information we collect with third parties to provide services on our behalf (e.g., payment processing) or for legal reasons.',
            ),
             _buildSection(
              '5. Your Rights',
              'You have the right to access, correct, or delete your personal information at any time. You can manage your account settings within the app or contact support for assistance.',
            ),
             _buildSection(
              '6. Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at support2travelmateteam@gmail.com.',
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'TravelMate Inc.',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00897B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
