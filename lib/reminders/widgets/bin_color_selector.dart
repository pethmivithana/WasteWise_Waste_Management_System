import 'package:flutter/material.dart';
import '../models/bin.dart';

class BinColorSelector extends StatelessWidget {
  final BinColor? binColor;
  final Function(BinColor?) onSelectionChanged;
  final String? errorText;
  final EdgeInsets? edgeInsets;

  const BinColorSelector(
      {super.key,
      this.binColor,
      this.errorText,
      this.edgeInsets,
      required this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<BinColor>(
      label: const Text('Bin Color'),
      expandedInsets: edgeInsets,
      initialSelection: binColor,
      dropdownMenuEntries: buildBinColorDropdown(),
      onSelected: onSelectionChanged,
      leadingIcon:
          binColor == null ? null : _getBinColorIcon(binColor!.baseColor),
      errorText: errorText,
    );
  }

  List<DropdownMenuEntry<BinColor>> buildBinColorDropdown() {
    List<DropdownMenuEntry<BinColor>> dropdownItems = [];
    for (BinColor binColor in BinColor.values) {
      var newItem = DropdownMenuEntry(
          value: binColor,
          label: binColor.name,
          leadingIcon: _getBinColorIcon(binColor.baseColor));
      dropdownItems.add(newItem);
    }

    return dropdownItems;
  }

  Widget _getBinColorIcon(Color color) {
    return Container(
        margin: const EdgeInsets.all(10.0),
        height: 20.0,
        width: 20.0,
        decoration: ShapeDecoration(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: color));
  }
}
