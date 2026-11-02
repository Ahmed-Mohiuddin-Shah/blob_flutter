import 'package:blob_flutter/configs/app/global/env_configs.dart';
import 'package:blob_flutter/configs/utils/app_logger.dart';
import 'package:flutter/widgets.dart';
import 'package:measure_flutter/measure_flutter.dart';

Future<void> runWithMeasure(Widget app) async {
  final enabled = EnvConfigs.measureEnabled;
  bootstrapLogging(forwardToMeasure: enabled);
  if (!enabled) {
    appLog.info('Measure disabled for this flavor');
    runApp(app);
    return;
  }
  // Self-hosted: native Android/iOS SDKs must point at your Measure API_URL
  // (AndroidManifest meta-data / iOS ClientInfo). Flutter layer only wraps UI.
  final apiUrl = EnvConfigs.measureApiUrl;
  if (apiUrl.isEmpty) {
    appLog.warning(
      'MEASURE_API_URL empty — native SDK will not reach self-hosted Measure',
    );
  } else {
    appLog.info('Measure enabled (self-hosted API: $apiUrl)');
  }
  await Measure.instance.init(
    () => runApp(MeasureWidget(child: app)),
    config: const MeasureConfig(enableLogging: true),
  );
}
