import 'package:flutter/foundation.dart';

import '../models/conseil.dart';
import '../repositories/conseil_repository.dart';

class ConseilProvider extends ChangeNotifier {
  ConseilProvider({
    ConseilRepository? repository,
  }) : _repository = repository ?? ConseilRepository();

  final ConseilRepository _repository;

  List<Conseil> _conseils = [];
  bool _isLoading = false;
  String? _error;

  String _searchQuery = '';
  String _selectedCategory = 'Tous';

  List<Conseil> get conseils => List.unmodifiable(_conseils);

  bool get isLoading => _isLoading;

  String? get error => _error;

  String get searchQuery => _searchQuery;

  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final categories = _conseils.map((e) => e.categorie).toSet().toList();
    return ['Tous', ...categories];
  }

  List<Conseil> get filteredConseils {
    return _conseils.where((conseil) {
      final query = _searchQuery.toLowerCase();

      final matchesSearch = query.isEmpty ||
          conseil.titre.toLowerCase().contains(query) ||
          conseil.contenu.toLowerCase().contains(query);

      final matchesCategory = _selectedCategory == 'Tous' ||
          conseil.categorie == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> loadConseils() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _conseils = _repository.getAll();

      if (_conseils.isEmpty) {
        await _createInitialConseils();
        _conseils = _repository.getAll();
      }
    } catch (_) {
      _error = 'Impossible de charger les conseils.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _createInitialConseils() async {
    final conseils = [
      Conseil(
        id: 'conseil-001',
        titre: 'Bien gérer l’arrosage',
        contenu:
            'Arrosez de préférence tôt le matin ou en fin de journée pour limiter l’évaporation.',
        categorie: 'Irrigation',
      ),
      Conseil(
        id: 'conseil-002',
        titre: 'Préparer le sol',
        contenu:
            'Un sol bien préparé favorise le développement des racines et améliore la croissance des cultures.',
        categorie: 'Sol',
      ),
      Conseil(
        id: 'conseil-003',
        titre: 'Surveiller les cultures',
        contenu:
            'Observez régulièrement les feuilles et les tiges afin de détecter rapidement les signes de maladie ou de ravageurs.',
        categorie: 'Protection',
      ),
      Conseil(
        id: 'conseil-004',
        titre: 'Planifier la récolte',
        contenu:
            'Suivez les dates de plantation et de récolte prévues afin de mieux organiser vos travaux agricoles.',
        categorie: 'Récolte',
      ),
    ];

    await _repository.saveAll(conseils);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'Tous';
    notifyListeners();
  }
}