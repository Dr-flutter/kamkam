import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/post_model.dart';

class CommunityService extends ChangeNotifier {
  final _uuid = const Uuid();
  late Box<PostModel> _box;

  static const pseudos = [
    'Étoile du Sud', 'Lionne 237', 'Fleur de Manguier', 'Soleil Levant',
    'Rivière Calme', 'Phoenix', 'Aurore', 'Colombe', 'Brise du Wouri', 'Sage Femme',
  ];

  List<PostModel> posts({String? category}) {
    var list = _box.values.toList();
    if (category != null && category != 'tout') {
      list = list.where((p) => p.category == category).toList();
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> load() async {
    _box = Hive.box<PostModel>('posts');
    notifyListeners();
  }

  Future<void> publish({required String content, required String category}) async {
    final p = PostModel(
      id: _uuid.v4(),
      pseudonym: pseudos[DateTime.now().millisecondsSinceEpoch % pseudos.length],
      category: category,
      content: content,
      createdAt: DateTime.now(),
    );
    await _box.put(p.id, p);
    notifyListeners();
  }

  Future<void> heart(String id) async {
    final p = _box.get(id);
    if (p == null) return;
    p.hearts += 1;
    await p.save();
    notifyListeners();
  }
}
