import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';

part 'db.g.dart';

enum Status { red, green }

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get status => intEnum<Status>().nullable()();
}

@UseMoor(tables: [Tasks])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> populate() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
      await into(tasks).insert(
        TasksCompanion.insert(status: Value(Status.red)), // ok
      );
      await into(tasks).insert(
        TasksCompanion.insert(status: Value(Status.green)), // ok
      );
      await into(tasks).insert(
        TasksCompanion.insert(status: Value(null)), // error
      );
    });
  }

  Future<List<Task>> query(Status? status) {
    final query = select(tasks)..where((tbl) => tbl.status.equalsValue(status));
    return query.get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}
