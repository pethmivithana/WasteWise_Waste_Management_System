import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double fee; // Pass the calculated fee

  const PaymentPage({super.key, required this.fee});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _cardNumberController = TextEditingController();
  final _nameOnCardController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _nameOnCardController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void handlePayment() {
    if (_formKey.currentState!.validate()) {
      // Simulate payment processing here (API call for payment processing can be added)

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment processed successfully!')),
      );

      // Navigate to HomeScreen after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PickupHome(), // Redirect to HomeScreen
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Fee: \$${widget.fee.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Please enter your card details:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                          _nameOnCardController, 'Name on Card', Icons.person,
                          validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      }),
                      const SizedBox(height: 16),
                      _buildTextField(_cardNumberController, 'Card Number',
                          Icons.credit_card, keyboardType: TextInputType.number,
                          validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your card number';
                        } else if (value.length < 16) {
                          return 'Card number must be 16 digits';
                        }
                        return null;
                      }),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(_expiryDateController,
                                'Expiry Date', Icons.calendar_today,
                                keyboardType: TextInputType.datetime,
                                validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter expiry date';
                              }
                              return null;
                            }),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                                _cvvController, 'CVV', Icons.lock,
                                keyboardType: TextInputType.number,
                                validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter CVV';
                              } else if (value.length < 3) {
                                return 'CVV must be 3 digits';
                              }
                              return null;
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: handlePayment,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: const Color(0xFF00C04B),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12)), // Button color
                        ),
                        child: const Text('Pay Now'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create text fields with validation
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validate}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF00C04B)),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 246, 239, 239),
      ),
      validator: validate, // Assign the validator
    );
  }
}

// Define the HomeScreen widget
class PickupHome extends StatelessWidget {
  const PickupHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(); // Close the HomeScreen
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/banking.png', // Replace with your image asset path
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                '🎉 Payment Successfully Submitted! 🎉',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Your pickup request has been successfully created.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),

                  backgroundColor: const Color(0xFF00C04B), // Button color
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
