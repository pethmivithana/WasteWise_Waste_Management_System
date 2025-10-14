import 'package:csse_waste_management/reminders/models/bin.dart';
import 'package:flutter/material.dart';

/// Widget to allow the selection of a collection frequency
class CollectionFrequencySelector extends StatelessWidget {
  final CollectionFrequency? collectionFrequency;
  final Function(CollectionFrequency?) onSelectionChanged;
  final EdgeInsets? edgeInsets;

  final String? errorText;

  const CollectionFrequencySelector(
      {super.key,
      this.collectionFrequency,
      this.errorText,
      this.edgeInsets,
      required this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<CollectionFrequency>(
      label: const Text('Collection Frequency'),
      expandedInsets: edgeInsets,
      initialSelection: collectionFrequency,
      dropdownMenuEntries: _buildCollectionFrequencyDropdown(),
      onSelected: onSelectionChanged,
      errorText: errorText,
    );
  }

  List<DropdownMenuEntry<CollectionFrequency>>
      _buildCollectionFrequencyDropdown() {
    List<DropdownMenuEntry<CollectionFrequency>> dropdownItems = [];
    for (CollectionFrequency collFreq in CollectionFrequency.values) {
      var newItem = DropdownMenuEntry(
        value: collFreq,
        label: collFreq.name,
      );
      dropdownItems.add(newItem);
    }

    return dropdownItems;
  }
}
