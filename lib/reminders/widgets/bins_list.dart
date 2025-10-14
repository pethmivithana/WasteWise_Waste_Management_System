import 'package:flutter/material.dart';
import 'package:csse_waste_management/reminders/models/bin.dart';
import 'package:csse_waste_management/reminders/widgets/bin_tile.dart';

/// A widget to show a list of bins
class BinsList extends StatelessWidget {
  final Future<List<Bin>> binList;
  final Function(Bin) onEditBin;
  final Function(Bin) onDeleteBin;

  const BinsList(
      {super.key,
      required this.binList,
      required this.onEditBin,
      required this.onDeleteBin});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bin>>(
      future: binList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No bins found.  Click + to add one'));
        } else {
          final List<Bin> bins = snapshot.data!;
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 5);
            },
            itemBuilder: (context, index) {
              Bin bin = bins[index];
              return BinTile(
                bin: bin,
                onEditCallback: () {
                  onEditBin(bin);
                },
                onDeleteCallback: () {
                  onDeleteBin(bin);
                },
              );
            },
            itemCount: bins.length,
          );
        }
      },
    );
  }
}
