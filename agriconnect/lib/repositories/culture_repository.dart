import '../models/culture.dart';
import '../services/hive_service.dart';

class CultureRepository {
  List<Culture> getAll() {
    return HiveService.cultures.values
        .map(
          (data) => Culture.fromMap(
            Map<String, dynamic>.from(data),
          ),
        )
        .toList();
  }

  Future<void> save(Culture culture) async {
    await HiveService.cultures.put(
      culture.id,
      culture.toMap(),
    );
  }

  Future<void> delete(String id) async {
    await HiveService.cultures.delete(id);
  }

  Culture? getById(String id) {
    final data = HiveService.cultures.get(id);

    if (data == null) {
      return null;
    }

    return Culture.fromMap(
      Map<String, dynamic>.from(data),
    );
  }
}