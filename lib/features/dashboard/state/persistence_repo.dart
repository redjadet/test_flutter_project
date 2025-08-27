import 'dart:convert';
import 'dart:io';

import 'package:complex_ui/features/dashboard/state/models.dart';
import 'package:complex_ui/features/dashboard/state/persistence.dart'
    as file_store;
import 'package:complex_ui/features/dashboard/state/persistence_hive.dart'
    as db_store;
import 'package:path_provider/path_provider.dart';

// Toggle this flag to switch between DB (Hive) and file-based persistence.
// You can also wire this to an env, a remote config, or a settings screen.
enum PersistenceBackend { file, hive }

class PersistenceRepo {
  static PersistenceBackend? _cached;

  static Future<PersistenceBackend> current() async {
    if (_cached != null) return _cached!;
    try {
      final base = await getApplicationSupportDirectory();
      final file = File(
        '${base.path}/complex_ui/persistence_backend.json',
      );
      if (await file.exists()) {
        final m = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        final s = (m['backend'] as String?) ?? 'file';
        _cached = s == 'hive'
            ? PersistenceBackend.hive
            : PersistenceBackend.file;
      } else {
        _cached = PersistenceBackend.file;
      }
    } catch (_) {
      _cached = PersistenceBackend.file;
    }
    return _cached!;
  }

  static Future<void> setBackend(PersistenceBackend backend) async {
    _cached = backend;
    try {
      final base = await getApplicationSupportDirectory();
      final dir = Directory('${base.path}/complex_ui');
      if (!await dir.exists()) await dir.create(recursive: true);
      final file = File('${dir.path}/persistence_backend.json');
      await file.writeAsString(jsonEncode({'backend': backend.name}));
    } catch (_) {}
  }
}

Future<void> saveDashboardState(DashboardState state) async {
  final backend = await PersistenceRepo.current();
  if (backend == PersistenceBackend.hive) {
    await db_store.saveDashboardStateDb(state);
  } else {
    await file_store.saveDashboardState(state);
  }
}

Future<DashboardState?> loadDashboardState() async {
  final backend = await PersistenceRepo.current();
  if (backend == PersistenceBackend.hive) {
    return db_store.loadDashboardStateDb();
  } else {
    return file_store.loadDashboardState();
  }
}
