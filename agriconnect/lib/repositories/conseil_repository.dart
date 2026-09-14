import '../models/conseil.dart';
import '../services/hive_service.dart';

class ConseilRepository {
  List<Conseil> getAll() {
    return HiveService.conseils.values
        .map(
          (data) => Conseil.fromMap(
            Map<String, dynamic>.from(data),
          ),
        )
        .toList();
  }

  Future<void> save(Conseil conseil) async {
    await HiveService.conseils.put(
      conseil.id,
      conseil.toMap(),
    );
  }

  Future<void> saveAll(List<Conseil> conseils) async {
    for (final conseil in conseils) {
      await save(conseil);
    }
  }
}