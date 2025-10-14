import 'package:csse_waste_management/payments/screen/Payments.dart';
import 'package:flutter/material.dart';

class PayPage extends StatelessWidget {
  final double payableAmount;

  const PayPage({super.key, required this.payableAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: const Color(0xFF00C04B), // App bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Payment Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Please pay LKR $payableAmount',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            PaymentForm(
              onPaymentSuccess: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentForm extends StatefulWidget {
  final VoidCallback onPaymentSuccess;

  const PaymentForm({super.key, required this.onPaymentSuccess});

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for the input fields
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Card Name
          TextFormField(
            controller: _cardNameController,
            decoration: const InputDecoration(
              labelText: 'Cardholder Name',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white, // Fill color for input field
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the cardholder name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Card Number
          TextFormField(
            controller: _cardNumberController,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty || value.length != 16) {
                return 'Please enter a valid 16-digit card number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Expiry Date
          TextFormField(
            controller: _expiryDateController,
            decoration: const InputDecoration(
              labelText: 'Expiry Date (MM/YY)',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.datetime,
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !RegExp(r"^(0[1-9]|1[0-2])\/?([0-9]{2})$").hasMatch(value)) {
                return 'Please enter a valid expiry date (MM/YY)';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // CVV
          TextFormField(
            controller: _cvvController,
            decoration: const InputDecoration(
              labelText: 'CVV',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.number,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty || value.length != 3) {
                return 'Please enter a valid 3-digit CVV';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C04B), // Button background color
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            ),
            onPressed: () {
              // Validate the form
              if (_formKey.currentState!.validate()) {
                // Trigger the success callback
                widget.onPaymentSuccess();
              }
            },
            child: const Text(
              'Proceed to Payment',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Please ensure your card details are correct before proceeding.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controllers when no longer needed
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}
