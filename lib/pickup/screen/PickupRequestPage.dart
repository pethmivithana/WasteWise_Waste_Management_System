import 'package:csse_waste_management/pickup/data/firestore.dart';
import 'package:csse_waste_management/pickup/model/pickup_model.dart';
import 'package:csse_waste_management/pickup/screen/PaymentPage.dart';
import 'package:flutter/material.dart';

class PickupRequestPage extends StatefulWidget {
  const PickupRequestPage({super.key});

  @override
  _PickupRequestPageState createState() => _PickupRequestPageState();
}

class _PickupRequestPageState extends State<PickupRequestPage> {
  String enteredAddress = '';
  String selectedGarbageType = 'Food Waste';
  String selectedGarbageSize = 'Less than 5Kg';
  DateTime selectedDate = DateTime.now();
  bool noTrucksAvailable = false;
  double fee = 0;

  List<String> garbageTypes = ['Food Waste', 'Plastic', 'Glass', 'Paper'];
  List<String> garbageSizes = ['Less than 5Kg', '5-10Kg', 'More than 10Kg'];

  final FirestoreDatasource _firestoreDatasource = FirestoreDatasource();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(selectedDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void checkTruckAvailability() {
    Map<int, String> collectionSchedule = {
      1: 'Food Waste', // Monday
      2: 'Plastic', // Tuesday
      3: 'Glass', // Wednesday
      4: 'Paper', // Thursday
      5: 'Food Waste', // Friday
      6: 'None', // Saturday
      7: 'None' // Sunday
    };

    int weekday = selectedDate.weekday;

    if (collectionSchedule[weekday] == 'None' ||
        collectionSchedule[weekday] != selectedGarbageType) {
      setState(() {
        noTrucksAvailable = true;
      });
    } else {
      setState(() {
        noTrucksAvailable = false;
      });
    }
  }

  void calculateFee() {
    if (selectedGarbageType == 'Food Waste') {
      if (selectedGarbageSize == 'Less than 5Kg') {
        fee = 575.0;
      } else if (selectedGarbageSize == '5-10Kg') {
        fee = 875.0;
      } else {
        fee = 1200.0;
      }
    } else if (selectedGarbageType == 'Plastic') {
      if (selectedGarbageSize == 'Less than 5Kg') {
        fee = 600.0;
      } else if (selectedGarbageSize == '5-10Kg') {
        fee = 900.0;
      } else {
        fee = 1300.0;
      }
    } else if (selectedGarbageType == 'Glass') {
      if (selectedGarbageSize == 'Less than 5Kg') {
        fee = 650.0;
      } else if (selectedGarbageSize == '5-10Kg') {
        fee = 950.0;
      } else {
        fee = 1400.0;
      }
    } else if (selectedGarbageType == 'Paper') {
      if (selectedGarbageSize == 'Less than 5Kg') {
        fee = 550.0;
      } else if (selectedGarbageSize == '5-10Kg') {
        fee = 800.0;
      } else {
        fee = 1200.0;
      }
    } else {
      fee = 0;
    }
  }

  void handleSubmitPickup() async {
    // Validation checks
    if (enteredAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an address.')),
      );
      return;
    }

    if (noTrucksAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid date for pickup.')),
      );
      return;
    }

    Pickup pickup = Pickup(
      enteredAddress: enteredAddress,
      selectedGarbageType: selectedGarbageType,
      selectedGarbageSize: selectedGarbageSize,
      selectedDate: selectedDate,
      fee: fee, // Make sure fee is included here
    );

    bool result = await _firestoreDatasource.addPickup(pickup);

    if (result) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentPage(
                  fee: fee,
                )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to submit request. Please try again.')),
      );
    }
  }

  // Format date as string
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Request'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter Address:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 246, 239, 239),
                  prefixIcon:
                      const Icon(Icons.location_on, color: Color(0xFF00C04B)),
                ),
                onChanged: (value) {
                  setState(() {
                    enteredAddress = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Select Garbage Type:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 246, 239, 239),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: DropdownButton<String>(
                  value: selectedGarbageType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGarbageType = newValue!;
                      calculateFee();
                      checkTruckAvailability(); // Check availability after type change
                    });
                  },
                  underline: const SizedBox(),
                  isExpanded: true,
                  items: garbageTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(type),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select Garbage Size:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 246, 239, 239),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: DropdownButton<String>(
                  value: selectedGarbageSize,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGarbageSize = newValue!;
                      calculateFee();
                    });
                  },
                  underline: const SizedBox(),
                  isExpanded: true,
                  items: garbageSizes.map((String size) {
                    return DropdownMenuItem<String>(
                      value: size,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(size),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select Date:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_today,
                      color: Color(0xFF00C04B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 246, 239, 239),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                      _dateController.text = _formatDate(selectedDate);
                      calculateFee();
                      checkTruckAvailability();
                    });
                  }
                },
                controller: _dateController,
              ),
              const SizedBox(height: 8),
              if (noTrucksAvailable)
                const Text(
                  'No trucks available on this date for the selected garbage type.',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              Text(
                'Estimated Fee: \$${fee.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: handleSubmitPickup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C04B),
                  minimumSize: const Size(
                      double.infinity, 50), // Set text color to white
                ),
                child: const Text('Proceed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
