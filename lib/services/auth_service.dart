import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final _uuid = const Uuid();
  late Box<UserModel> _box;
  late Box _settings;
  UserModel? _current;
  bool _stealthActive = false;

  UserModel? get current => _current;
  bool get isAuthenticated => _current != null;
  bool get stealthActive => _stealthActive;
  bool get hasAccount => _box.isNotEmpty;

  Future<void> load() async {
    _box = Hive.box<UserModel>('users');
    _settings = Hive.box('settings');
    if (_box.isNotEmpty) {
      _current = _box.values.first;
    }
    _stealthActive = _settings.get('stealthActive', defaultValue: false) as bool;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String pin,
    String language = 'fr',
  }) async {
    final u = UserModel(
      id: _uuid.v4(),
      displayName: name,
      pin: pin,
      language: language,
      createdAt: DateTime.now(),
    );
    await _box.put(u.id, u);
    _current = u;
    notifyListeners();
  }

  Future<bool> loginWithPin(String pin) async {
    if (_box.isEmpty) return false;
    final u = _box.values.first;
    if (u.pin == pin) {
      _current = u;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _current = null;
    notifyListeners();
  }

  Future<void> updateSafeWord(String word) async {
    if (_current == null) return;
    _current!.safeWord = word;
    await _current!.save();
    notifyListeners();
  }

  Future<void> updateLanguage(String lang) async {
    if (_current == null) return;
    _current!.language = lang;
    await _current!.save();
    notifyListeners();
  }

  Future<void> setStealthDisguise(String disguise) async {
    if (_current == null) return;
    _current!.stealthDisguise = disguise;
    _current!.stealthMode = true;
    await _current!.save();
    notifyListeners();
  }

  Future<void> activateStealth() async {
    _stealthActive = true;
    await _settings.put('stealthActive', true);
    notifyListeners();
  }

  Future<void> deactivateStealth() async {
    _stealthActive = false;
    await _settings.put('stealthActive', false);
    notifyListeners();
  }
}
