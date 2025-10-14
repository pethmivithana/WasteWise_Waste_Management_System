import 'package:flutter/material.dart';
import '../models/bin.dart';

/// Widget to allow the selection of a bin type
class BinTypeSelector extends StatelessWidget {
  final BinType? binType;
  final Function(BinType?) onSelectionChanged;
  final String? errorText;
  final EdgeInsets? edgeInsets;
  const BinTypeSelector(
      {super.key,
      this.binType,
      this.errorText,
      this.edgeInsets,
      required this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<BinType>(
      label: const Text('Bin Type'),
      expandedInsets: edgeInsets,
      initialSelection: binType,
      dropdownMenuEntries: _buildBinTypeDropdown(),
      onSelected: onSelectionChanged,
      leadingIcon: binType == null ? null : Icon(binType?.icon),
      errorText: errorText,
    );
  }

  List<DropdownMenuEntry<BinType>> _buildBinTypeDropdown() {
    List<DropdownMenuEntry<BinType>> dropdownItems = [];
    for (BinType binType in BinType.values) {
      var newItem = DropdownMenuEntry(
          value: binType, label: binType.name, leadingIcon: Icon(binType.icon));
      dropdownItems.add(newItem);
    }

    return dropdownItems;
  }
}
