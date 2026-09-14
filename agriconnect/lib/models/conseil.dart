class Conseil {
  final String id;
  final String titre;
  final String contenu;
  final String categorie;

  const Conseil({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.categorie,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'categorie': categorie,
    };
  }

  factory Conseil.fromMap(Map<String, dynamic> map) {
    return Conseil(
      id: map['id'] as String,
      titre: map['titre'] as String,
      contenu: map['contenu'] as String,
      categorie: map['categorie'] as String,
    );
  }
}