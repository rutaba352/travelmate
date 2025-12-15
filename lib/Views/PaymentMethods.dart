import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  // Mock payment methods
  List<Map<String, String>> methods = [
    {
      'type': 'Visa',
      'number': '•••• •••• •••• 4242',
      'expiry': '12/25',
      'holder': 'John Anderson',
      'logo':
          'assets/images/visa_logo.png', // You might not have assets, use Icon
    },
    {
      'type': 'Mastercard',
      'number': '•••• •••• •••• 8888',
      'expiry': '09/24',
      'holder': 'John Anderson',
      'logo': 'assets/images/mastercard_logo.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          ElevatedButton.icon(
            onPressed: () => SnackbarHelper.showInfo(
              context,
              'Add Card Feature coming soon',
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Date Payment Method'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 30),
          const Text(
            'Transaction History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildTransactionItem('Flight to Paris', 'Dec 12, 2024', '-\$450.00'),
          _buildTransactionItem('Hotel in Dubai', 'Nov 20, 2024', '-\$250.00'),
          _buildTransactionItem(
            'Refund',
            'Nov 21, 2024',
            '+\$50.00',
            isRefund: true,
          ),
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

  Widget _buildTransactionItem(
    String title,
    String date,
    String amount, {
    bool isRefund = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isRefund
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRefund ? Icons.arrow_downward : Icons.arrow_upward,
              color: isRefund ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isRefund ? Colors.green : Colors.red,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
