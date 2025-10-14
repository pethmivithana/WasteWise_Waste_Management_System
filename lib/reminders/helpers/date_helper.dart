import 'package:jiffy/jiffy.dart';
import 'package:csse_waste_management/reminders/models/bin.dart';
import 'package:clock/clock.dart';

class DateHelper {
  /// Calc the next collection date after today
  static DateTime getNextCollectionDate(
      DateTime baseCollectionDate, CollectionFrequency collectionFrequency) {
    DateTime today = getToday();
    DateTime nextCollectionDate = baseCollectionDate;

    while (nextCollectionDate.isBefore(today)) {
      nextCollectionDate =
          nextCollectionDate.add(Duration(days: collectionFrequency.days));
    }

    return nextCollectionDate;
  }

  /// get the printable version of the next collection date
  static String getFormattedNextCollectionDate(DateTime nextCollectionDate) {
    DateTime now = clock.now();
    DateTime tomorrow = now.add(const Duration(days: 1));

    String formattedDate = '';

    if (nextCollectionDate.day == now.day &&
        nextCollectionDate.month == now.month &&
        nextCollectionDate.year == now.year) {
      formattedDate = 'Today';
    } else if (nextCollectionDate.day == tomorrow.day &&
        nextCollectionDate.month == tomorrow.month &&
        nextCollectionDate.year == tomorrow.year) {
      formattedDate = 'Tomorrow';
    } else {
      formattedDate = Jiffy.parseFromDateTime(nextCollectionDate)
          .format(pattern: 'EEEE, do MMMM');
    }

    return formattedDate;
  }

  /// Get today's date, minus the time segment
  static DateTime getToday() {
    DateTime now = clock.now();
    return DateTime(now.year, now.month, now.day);
  }
}
