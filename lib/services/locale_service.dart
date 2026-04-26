import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LocaleService extends ChangeNotifier {
  late Box _box;
  String _lang = 'fr';
  String get lang => _lang;

  static const supported = {
    'fr': 'Français', 'en': 'English', 'ff': 'Fulfulde',
    'ewo': 'Ewondo', 'dua': 'Duala', 'bam': 'Bamoun',
  };

  Future<void> load() async {
    _box = Hive.box('settings');
    _lang = _box.get('lang', defaultValue: 'fr') as String;
    notifyListeners();
  }

  Future<void> set(String l) async {
    _lang = l;
    await _box.put('lang', l);
    notifyListeners();
  }
}
