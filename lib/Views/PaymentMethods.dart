import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  String _cardHolderName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // 1. Try to use Auth Display Name first (Instant)
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        if (mounted) {
          setState(() {
            _cardHolderName = user.displayName!;
          });
        }
      }

      // 2. Try to fetch from Firestore (for potential updates)
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists && doc.data()!.containsKey('name')) {
          final firestoreName = doc.data()!['name'].toString();
          if (firestoreName.isNotEmpty) {
            if (mounted) {
              setState(() {
                _cardHolderName = firestoreName;
              });
            }
          }
        } else if (_cardHolderName == 'Loading...') {
          // If Firestore fails/empty AND we still have 'Loading...' (meaning Auth name failed too)
          if (mounted) {
            setState(() {
              _cardHolderName = 'Valued User';
            });
          }
        }
      } catch (e) {
        print('Error fetching name: $e');
        if (_cardHolderName == 'Loading...' && mounted) {
          setState(() {
            _cardHolderName = 'Valued User';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mock payment methods with dynamic name
    List<Map<String, String>> methods = [
      {
        'type': 'Visa',
        'number': '•••• •••• •••• 4242',
        'expiry': '12/25',
        'holder': _cardHolderName,
        'logo': 'assets/images/visa_logo.png',
      },
      {
        'type': 'Mastercard',
        'number': '•••• •••• •••• 8888',
        'expiry': '09/24',
        'holder': _cardHolderName,
        'logo': 'assets/images/mastercard_logo.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: const Color(0xFF00897B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Your Cards',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ...methods.map((method) => _buildCardItem(method)).toList(),

          const SizedBox(height: 25),
          
        ],
      ),
    );
  }

  Widget _buildCardItem(Map<String, String> method) {
    bool isVisa = method['type'] == 'Visa';
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isVisa
              ? [const Color(0xFF1A1F71), const Color(0xFF2B32B2)]
              : [const Color(0xFF222222), const Color(0xFF444444)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
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
              Icon(Icons.credit_card, color: Colors.white, size: 30),
              Text(
                method['type']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            method['number']!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2,
              fontFamily: 'Courier', // Monospace feel
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Card Holder',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  Text(
                    method['holder']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expires',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  Text(
                    method['expiry']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
