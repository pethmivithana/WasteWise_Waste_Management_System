import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:csse_waste_management/reminders/helpers/date_helper.dart';
import 'package:csse_waste_management/reminders/helpers/custom_icon_collection_icons.dart';

enum BinType implements Comparable<BinType> {
  bag(icon: CustomIconCollection.bag),
  bin(icon: FontAwesomeIcons.trash),
  box(icon: FontAwesomeIcons.boxArchive),
  industrial(icon: FontAwesomeIcons.dumpster),
  wheelie(icon: CustomIconCollection.wheelie);

  const BinType({required this.icon});

  @override
  int compareTo(BinType other) => icon.codePoint - other.icon.codePoint;

  final IconData icon;
}

/// The collection frequency.
/// Can be weekly, fortnightly (14 days) or monthly (28 days)
enum CollectionFrequency implements Comparable<CollectionFrequency> {
  weekly(days: 7),
  fortnightly(days: 14),
  monthly(days: 28);

  const CollectionFrequency({required this.days});

  @override
  int compareTo(CollectionFrequency other) => days - other.days;

  final int days;
}

enum BinColor implements Comparable<BinColor> {
  black(baseColor: Colors.black),
  blue(baseColor: Colors.blue),
  brown(baseColor: Colors.brown),
  green(baseColor: Colors.green),
  grey(baseColor: Colors.grey),
  red(baseColor: Colors.red),
  white(baseColor: Colors.white),
  yellow(baseColor: Colors.yellow);

  const BinColor({required this.baseColor});

  @override
  int compareTo(BinColor other) => baseColor.value - other.baseColor.value;

  final Color baseColor;
}

final DateTime defaultCollectionDate = DateTime(2024, 1, 1);

class Bin {
  static const String tableName = 'Bin';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnBinType = 'binType';
  static const String columnBinColor = 'binColor';
  static const String columnCollectionDate = 'collectionDate';
  static const String columnCollectionFreq = 'collectionFreq';
  static const String columnIsPaused = 'isPaused';

  final int? id;
  final String name;
  final BinType binType;
  final BinColor binColor;
  final DateTime collectionDate;
  final CollectionFrequency collectionFrequency;
  final bool isPaused;

  Bin(
      {this.id,
      required this.name,
      required this.binType,
      required this.binColor,
      required this.collectionDate,
      required this.collectionFrequency,
      required this.isPaused});

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnName: name,
      columnBinType: binType.name,
      columnBinColor: binColor.name,
      columnCollectionDate: collectionDate.millisecondsSinceEpoch,
      columnCollectionFreq: collectionFrequency.name,
      columnIsPaused: (isPaused ? 1 : 0)
    };
  }

  factory Bin.fromMap(Map<String, dynamic> map) {
    return Bin(
        id: map[columnId] ?? 0,
        name: map[columnName] ?? '',
        binType: EnumToString.fromString(BinType.values, map[columnBinType]) ??
            BinType.bin,
        binColor:
            EnumToString.fromString(BinColor.values, map[columnBinColor]) ??
                BinColor.red,
        collectionDate:
            DateTime.fromMillisecondsSinceEpoch(map[columnCollectionDate]),
        collectionFrequency: EnumToString.fromString(
                CollectionFrequency.values, map[columnCollectionFreq]) ??
            CollectionFrequency.weekly,
        isPaused: (map[columnIsPaused] == 1));
  }

  get nextCollectionDate {
    return DateHelper.getNextCollectionDate(
        collectionDate, collectionFrequency);
  }

  @override
  String toString() {
    return 'Bin(id: $id, name: $name, binType: $binType, color: $binColor, collectionDate: $collectionDate, collectionFreq: $collectionFrequency)';
  }
}
