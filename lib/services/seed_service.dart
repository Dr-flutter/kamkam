import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/contact_model.dart';
import '../models/post_model.dart';

class SeedService {
  static Future<void> seedIfEmpty() async {
    const uuid = Uuid();
    final contacts = Hive.box<ContactModel>('contacts');
    final posts = Hive.box<PostModel>('posts');

    if (contacts.isEmpty) {
      final demo = [
        ContactModel(id: uuid.v4(), name: 'Maman Aïssatou', phone: '+237 6 90 12 34 56', relation: 'Mère'),
        ContactModel(id: uuid.v4(), name: 'Sœur Larissa', phone: '+237 6 77 23 45 67', relation: 'Sœur'),
        ContactModel(id: uuid.v4(), name: 'Amie Marie', phone: '+237 6 55 34 56 78', relation: 'Amie'),
      ];
      for (final c in demo) {
        await contacts.put(c.id, c);
      }
    }

    if (posts.isEmpty) {
      final demo = [
        PostModel(id: uuid.v4(), pseudonym: 'Aurore', category: 'témoignage',
          content: "Pendant 3 ans, j'ai cru que c'était normal. Aujourd'hui je suis libre. Tu peux y arriver aussi. ❤️",
          hearts: 124, comments: 18, createdAt: DateTime.now().subtract(const Duration(hours: 2))),
        PostModel(id: uuid.v4(), pseudonym: 'Lionne 237', category: 'conseil',
          content: "Astuce sécurité : gardez toujours une copie de vos papiers chez une personne de confiance hors du foyer.",
          hearts: 89, comments: 7, createdAt: DateTime.now().subtract(const Duration(hours: 6))),
        PostModel(id: uuid.v4(), pseudonym: 'Sage Femme', category: 'juridique',
          content: "Le numéro vert MINFEF 1500 est gratuit 24h/24. Conservez-le précieusement.",
          hearts: 201, comments: 24, createdAt: DateTime.now().subtract(const Duration(days: 1))),
        PostModel(id: uuid.v4(), pseudonym: 'Brise du Wouri', category: 'soutien',
          content: "Je traverse une période difficile. Vos messages me donnent du courage chaque jour. Merci à toutes 🌸",
          hearts: 156, comments: 42, createdAt: DateTime.now().subtract(const Duration(days: 2))),
      ];
      for (final p in demo) {
        await posts.put(p.id, p);
      }
    }
  }
}
