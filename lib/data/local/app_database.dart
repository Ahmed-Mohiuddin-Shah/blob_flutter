import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class WhatsappPackDrafts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get identifier => text()();
  TextColumn get name => text()();
  TextColumn get publisher => text()();
  TextColumn get trayPath => text().nullable()();
  BoolColumn get animated => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class WhatsappPackStickers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get packId => integer().references(WhatsappPackDrafts, #id)();
  TextColumn get stickerId => text()();
  TextColumn get localPath => text()();
  TextColumn get emoji => text().withDefault(const Constant('🙂'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [WhatsappPackDrafts, WhatsappPackStickers])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'blob_local'));

  @override
  int get schemaVersion => 1;
}

AppDatabase? _db;
AppDatabase get appDatabase => _db ??= AppDatabase();
