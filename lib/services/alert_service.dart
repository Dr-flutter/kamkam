import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/alert_model.dart';

class AlertService extends ChangeNotifier {
  final _uuid = const Uuid();
  late Box<AlertModel> _box;

  List<AlertModel> get alerts {
    final list = _box.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> load() async {
    _box = Hive.box<AlertModel>('alerts');
    notifyListeners();
  }

  Future<AlertModel> trigger({
    required AlertLevel level,
    String location = 'Yaoundé · Quartier non spécifié',
    String note = '',
  }) async {
    final a = AlertModel(
      id: _uuid.v4(),
      level: level,
      location: location,
      note: note,
      createdAt: DateTime.now(),
    );
    await _box.put(a.id, a);
    notifyListeners();
    return a;
  }

  Future<void> resolve(String id) async {
    final a = _box.get(id);
    if (a == null) return;
    a.status = 'resolved';
    await a.save();
    notifyListeners();
  }
}
