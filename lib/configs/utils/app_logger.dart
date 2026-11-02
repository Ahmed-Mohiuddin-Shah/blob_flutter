import 'package:logging/logging.dart';
import 'package:measure_flutter/measure_flutter.dart';

final Logger appLog = Logger('blob');

void bootstrapLogging({required bool forwardToMeasure}) {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
    if (!forwardToMeasure) return;
    Measure.instance.log(
      record.message,
      severity: _severity(record.level),
    );
  });
}

LogSeverity _severity(Level level) {
  if (level >= Level.SHOUT) return LogSeverity.fatal;
  if (level >= Level.SEVERE) return LogSeverity.error;
  if (level >= Level.WARNING) return LogSeverity.warning;
  if (level >= Level.INFO) return LogSeverity.info;
  return LogSeverity.debug;
}
