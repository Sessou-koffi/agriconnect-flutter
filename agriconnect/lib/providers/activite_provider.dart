import 'package:flutter/foundation.dart';

import '../models/activite.dart';
import '../repositories/activite_repository.dart';

class ActiviteProvider extends ChangeNotifier {
  ActiviteProvider({
    ActiviteRepository? repository,
  }) : _repository = repository ?? ActiviteRepository();

  final ActiviteRepository _repository;

  List<Activite> _activites = [];
  bool _isLoading = false;
  String? _error;

  List<Activite> get activites => List.unmodifiable(_activites);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadActivites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _activites = _repository.getAll();
    } catch (_) {
      _error = 'Impossible de charger les activités.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addActivite(Activite activite) async {
    try {
      await _repository.save(activite);
      await loadActivites();
      return true;
    } catch (_) {
      _error = 'Impossible d’ajouter l’activité.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteActivite(String id) async {
    try {
      await _repository.delete(id);
      await loadActivites();
      return true;
    } catch (_) {
      _error = 'Impossible de supprimer l’activité.';
      notifyListeners();
      return false;
    }
  }

  List<Activite> getByCultureId(String cultureId) {
    return _activites
        .where((activite) => activite.cultureId == cultureId)
        .toList();
  }
}