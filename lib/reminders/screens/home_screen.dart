import 'package:flutter/material.dart';
import 'package:csse_waste_management/reminders/services/database_service.dart';
import 'package:csse_waste_management/reminders/widgets/bins_list.dart';
import 'package:csse_waste_management/reminders/widgets/delete_confirmation_dialog.dart';
import 'package:csse_waste_management/reminders/screens/edit_screen.dart';
import 'package:csse_waste_management/user_management/login_signup/screen/home.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> with WidgetsBindingObserver {
  final DatabaseService db = DatabaseService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bin Reminder'),
        backgroundColor: const Color(0xFF00C04B),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditScreen()),
              ).then((_) => {setState(() {})});
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add a SizedBox for spacing below the AppBar
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // Increased padding for more space
              child: BinsList(
                binList: db.listBins(),
                onEditBin: (bin) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(bin: bin),
                    ),
                  ).then((_) => {setState(() {})});
                },
                onDeleteBin: (bin) {
                  showAdaptiveDialog(
                    context: context,
                    builder: (_) => DeleteConfirmationDialog(
                      onConfirmDelete: () async {
                        await db.deleteBin(bin.id!);
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          // Add space at the bottom
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
