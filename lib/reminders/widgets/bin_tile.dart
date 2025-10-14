import 'package:flutter/material.dart';
import 'package:csse_waste_management/reminders/models/bin.dart';
import 'package:csse_waste_management/reminders/extensions/material_colors.dart';
import 'package:csse_waste_management/reminders/helpers/date_helper.dart';

/// A widget to show the bin details in a [BinsList]
class BinTile extends StatelessWidget {
  final Bin bin;
  final Function() onDeleteCallback;
  final Function() onEditCallback;

  const BinTile(
      {super.key,
      required this.bin,
      required this.onDeleteCallback,
      required this.onEditCallback});

  @override
  Widget build(BuildContext context) {
    String nextCollectionDueText =
        DateHelper.getFormattedNextCollectionDate(bin.nextCollectionDate);

    return ListTile(
      tileColor: context.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(5)),
      onTap: onEditCallback,
      leading: buildIcon(bin),
      title: Text(
        bin.name,
      ),
      subtitle: Text(bin.isPaused ? 'Paused' : 'Due $nextCollectionDueText'),
      trailing: MenuAnchor(
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.more_vert),
            tooltip: 'Show menu',
          );
        },
        menuChildren: [
          MenuItemButton(
            onPressed: onDeleteCallback,
            child: const Text('Remove'),
          )
        ],
      ),
    );
  }

  Icon buildIcon(Bin bin) {
    return Icon(
      bin.binType.icon,
      color: bin.binColor.baseColor,
    );
  }
}
