import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._();

  static const String culturesBox = 'cultures';
  static const String activitesBox = 'activites';
  static const String conseilsBox = 'conseils';

  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox<Map>(culturesBox);
    await Hive.openBox<Map>(activitesBox);
    await Hive.openBox<Map>(conseilsBox);
  }

  static Box<Map> get cultures => Hive.box<Map>(culturesBox);

  static Box<Map> get activites => Hive.box<Map>(activitesBox);

  static Box<Map> get conseils => Hive.box<Map>(conseilsBox);
}