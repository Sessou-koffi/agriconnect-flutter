import 'package:flutter/foundation.dart';

import '../models/culture.dart';
import '../repositories/culture_repository.dart';

class CultureProvider extends ChangeNotifier {
  CultureProvider({
    CultureRepository? repository,
  }) : _repository = repository ?? CultureRepository();

  final CultureRepository _repository;

  List<Culture> _cultures = [];
  bool _isLoading = false;
  String? _error;

  List<Culture> get cultures => List.unmodifiable(_cultures);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadCultures() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cultures = _repository.getAll();
    } catch (e) {
      _error = 'Impossible de charger les cultures.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCulture(Culture culture) async {
    try {
      await _repository.save(culture);
      await loadCultures();
      return true;
    } catch (e) {
      _error = 'Impossible d’ajouter la culture.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCulture(Culture culture) async {
    try {
      await _repository.save(culture);
      await loadCultures();
      return true;
    } catch (e) {
      _error = 'Impossible de modifier la culture.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCulture(String id) async {
    try {
      await _repository.delete(id);
      await loadCultures();
      return true;
    } catch (e) {
      _error = 'Impossible de supprimer la culture.';
      notifyListeners();
      return false;
    }
  }

  Culture? getCultureById(String id) {
    try {
      return _cultures.firstWhere(
        (culture) => culture.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}