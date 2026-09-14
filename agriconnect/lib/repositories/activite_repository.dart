import '../models/activite.dart';
import '../services/hive_service.dart';

class ActiviteRepository {
  List<Activite> getAll() {
    return HiveService.activites.values
        .map(
          (data) => Activite.fromMap(
            Map<String, dynamic>.from(data),
          ),
        )
        .toList();
  }

  Future<void> save(Activite activite) async {
    await HiveService.activites.put(
      activite.id,
      activite.toMap(),
    );
  }

  Future<void> delete(String id) async {
    await HiveService.activites.delete(id);
  }

  List<Activite> getByCultureId(String cultureId) {
    return getAll()
        .where((activite) => activite.cultureId == cultureId)
        .toList();
  }
}