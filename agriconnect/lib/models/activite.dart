class Activite {
  final String id;
  final String cultureId;
  final String type;
  final DateTime date;
  final String description;

  const Activite({
    required this.id,
    required this.cultureId,
    required this.type,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cultureId': cultureId,
      'type': type,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory Activite.fromMap(Map<String, dynamic> map) {
    return Activite(
      id: map['id'] as String,
      cultureId: map['cultureId'] as String,
      type: map['type'] as String,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String,
    );
  }
}