class Culture {
  final String id;
  final String nom;
  final String type;
  final String parcelle;
  final DateTime datePlantation;
  final DateTime dateRecoltePrevue;
  final String statut;
  final String description;

  const Culture({
    required this.id,
    required this.nom,
    required this.type,
    required this.parcelle,
    required this.datePlantation,
    required this.dateRecoltePrevue,
    required this.statut,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'type': type,
      'parcelle': parcelle,
      'datePlantation': datePlantation.toIso8601String(),
      'dateRecoltePrevue': dateRecoltePrevue.toIso8601String(),
      'statut': statut,
      'description': description,
    };
  }

  factory Culture.fromMap(Map<String, dynamic> map) {
    return Culture(
      id: map['id'] as String,
      nom: map['nom'] as String,
      type: map['type'] as String,
      parcelle: map['parcelle'] as String,
      datePlantation: DateTime.parse(map['datePlantation'] as String),
      dateRecoltePrevue: DateTime.parse(
        map['dateRecoltePrevue'] as String,
      ),
      statut: map['statut'] as String,
      description: map['description'] as String,
    );
  }

  Culture copyWith({
    String? id,
    String? nom,
    String? type,
    String? parcelle,
    DateTime? datePlantation,
    DateTime? dateRecoltePrevue,
    String? statut,
    String? description,
  }) {
    return Culture(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      type: type ?? this.type,
      parcelle: parcelle ?? this.parcelle,
      datePlantation: datePlantation ?? this.datePlantation,
      dateRecoltePrevue: dateRecoltePrevue ?? this.dateRecoltePrevue,
      statut: statut ?? this.statut,
      description: description ?? this.description,
    );
  }
}