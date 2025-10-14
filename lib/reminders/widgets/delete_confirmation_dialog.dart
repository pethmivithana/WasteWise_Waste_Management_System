import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function onConfirmDelete;

  const DeleteConfirmationDialog({super.key, required this.onConfirmDelete});

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Confirm"),
      onPressed: () {
        onConfirmDelete();
        Navigator.pop(context, false);
      },
    );
    // set up the AlertDialog
    return AlertDialog(
      title: const Text("Remove this Bin?"),
      content: const Text(
          "Are you sure you want to remove this bin?  You will no longer receive reminders about it"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
}
