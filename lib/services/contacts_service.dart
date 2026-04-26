import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/contact_model.dart';

class ContactsService extends ChangeNotifier {
  final _uuid = const Uuid();
  late Box<ContactModel> _box;

  List<ContactModel> get contacts => _box.values.toList();
  List<ContactModel> get trusted => _box.values.where((c) => c.isTrusted).toList();

  Future<void> load() async {
    _box = Hive.box<ContactModel>('contacts');
    notifyListeners();
  }

  Future<void> add({required String name, required String phone, required String relation, bool trusted = true}) async {
    if (trusted && this.trusted.length >= 5) {
      throw Exception('Maximum 5 contacts de confiance');
    }
    final c = ContactModel(id: _uuid.v4(), name: name, phone: phone, relation: relation, isTrusted: trusted);
    await _box.put(c.id, c);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _box.delete(id);
    notifyListeners();
  }

  Future<void> toggleTrusted(String id) async {
    final c = _box.get(id);
    if (c == null) return;
    c.isTrusted = !c.isTrusted;
    await c.save();
    notifyListeners();
  }
}
