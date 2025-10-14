import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_waste_management/reminders/helpers/date_helper.dart';
import 'package:csse_waste_management/reminders/services/database_service.dart';
import 'package:csse_waste_management/reminders/models/bin.dart';
import 'package:csse_waste_management/reminders/services/notification_service.dart';
import 'package:logger/logger.dart';

class BackgroundWorker {
  static const backgroundWorkerUniqueName =
      "dev.jonclarke.bin_reminder.backgroundWorker";

  static const backgroundWorkerTaskKey =
      "dev.jonclarke.bin_reminder.background.scheduledTask";

  final Logger _logger = Logger();

  final DatabaseService _databaseService;

  BackgroundWorker({required DatabaseService databaseService})
      : _databaseService = databaseService;

  Future<void> cleanUpCollectionDates() async {
    _logger.d('Clean up collection dates');

    await _databaseService.updatePastCollectionDates();
  }

  Future<void> sendNotifications(
      NotificationService notificationService) async {
    // clear any existing notifications for this bin
    _logger.d('clear existing notifications');
    await notificationService.cancelAllNotifications();

    List<Bin> bins = await _databaseService.listDueBins();
    _logger.d('${bins.length} bins found with collections due');

    _logger.d('Send notifications');
    for (Bin b in bins) {
      // collection is due, send a notification
      await notificationService.showNotification(b.id!, 'Bin Reminder',
          '${b.name} is due ${DateHelper.getFormattedNextCollectionDate(b.collectionDate)}');
    }
  }
}

/// background worker task
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    const dateLastRunSharedPrefSettingName = "bgw_lastchecked";

    Logger logger = Logger();
    logger.d('Workmanager.executeTask called for task $task');

    try {
      switch (task) {
        case BackgroundWorker.backgroundWorkerTaskKey:
          final prefs = await SharedPreferences.getInstance();
          String? dateLastRunSetting =
              prefs.getString(dateLastRunSharedPrefSettingName);

          DateTime dateLastRun = (dateLastRunSetting == null
              ? DateHelper.getToday()
              : DateTime.parse(dateLastRunSetting));
          logger.d('Last run date = $dateLastRun');

          if (dateLastRun.isBefore(DateHelper.getToday())) {
            logger.d('Last run date is in the past, run background tasks');
            // scheduled job last ran yesterday.  Run it now
            BackgroundWorker dw = BackgroundWorker(
              databaseService: DatabaseService(),
            );
            await dw.cleanUpCollectionDates();
            await dw.sendNotifications(NotificationService());
          }

          await prefs.setString(dateLastRunSharedPrefSettingName,
              DateHelper.getToday().toIso8601String());
          break;
      }
    } catch (e, s) {
      logger.e('Error running background task', error: e, stackTrace: s);
    }

    return Future.value(true);
  });
}
