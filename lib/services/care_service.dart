import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';

class CareService extends ChangeNotifier {
  final _uuid = const Uuid();
  late Box<MessageModel> _box;
  int _currentRiskScore = 20;

  int get currentRiskScore => _currentRiskScore;

  String get riskLevel {
    if (_currentRiskScore >= 70) return 'Critique';
    if (_currentRiskScore >= 40) return 'Modéré';
    return 'Bas';
  }

  Future<void> load() async {
    _box = Hive.box<MessageModel>('messages');
    notifyListeners();
  }

  List<MessageModel> conversation(String convId) {
    final list = _box.values.where((m) => m.conversationId == convId).toList();
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }

  Future<MessageModel> sendUserMessage(String convId, String text) async {
    final m = MessageModel(
      id: _uuid.v4(),
      conversationId: convId,
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    await _box.put(m.id, m);

    if (convId == 'care') _updateRisk(text);

    notifyListeners();
    return m;
  }

  Future<MessageModel> generateAIResponse(String convId, String userText) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final response = _aiResponse(convId, userText);
    final m = MessageModel(
      id: _uuid.v4(),
      conversationId: convId,
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
      riskScore: convId == 'care' ? _currentRiskScore : null,
    );
    await _box.put(m.id, m);
    notifyListeners();
    return m;
  }

  void _updateRisk(String text) {
    final t = text.toLowerCase();
    final critical = ['frappe', 'tuer', 'mort', 'menace', 'arme', 'couteau', 'battu', 'bat', 'sang'];
    final moderate = ['peur', 'crie', 'insulte', 'contrôle', 'isolée', 'seule', 'triste', 'pleure'];
    var delta = 0;
    for (final w in critical) {
      if (t.contains(w)) delta += 25;
    }
    for (final w in moderate) {
      if (t.contains(w)) delta += 10;
    }
    _currentRiskScore = (_currentRiskScore + delta).clamp(0, 100);
  }

  String _aiResponse(String convId, String userText) {
    if (convId == 'rights') {
      final t = userText.toLowerCase();
      if (t.contains('divorce')) {
        return "Au Cameroun, le divorce est encadré par le Code Civil. Tu peux l'engager pour cause de violence (article 229). Les étapes : 1) Constituer un avocat, 2) Déposer une requête au Tribunal de Grande Instance, 3) Audience de conciliation. Je peux t'orienter vers un avocat partenaire MINFEF.";
      }
      if (t.contains('violence') || t.contains('frappe')) {
        return "La violence conjugale est punie par la loi camerounaise (loi n°2016/007). Tu peux : 1) Porter plainte au commissariat le plus proche, 2) Demander un certificat médical, 3) Solliciter une ordonnance d'éloignement. Le MINFEF dispose d'un numéro vert : 1500.";
      }
      if (t.contains('garde') || t.contains('enfant')) {
        return "La garde des enfants est décidée par le juge selon l'intérêt supérieur de l'enfant. La mère est généralement privilégiée pour les enfants en bas âge. Tu peux demander une pension alimentaire.";
      }
      return "Je suis là pour t'informer sur tes droits. Précise ta situation : violence, divorce, garde d'enfants, harcèlement, héritage... Je t'oriente vers les recours adaptés.";
    }
    if (convId == 'anger') {
      return "Respire profondément 4 secondes, retiens 7, expire 8. La colère est une émotion légitime, mais la violence est un choix. Veux-tu essayer un exercice de décompression guidé ?";
    }
    // care
    if (_currentRiskScore >= 70) {
      return "Je suis très inquiète pour toi. Ta sécurité est la priorité absolue. Souhaites-tu que j'active le protocole d'alerte ? Je peux envoyer un signal anonyme géolocalisé au commissariat le plus proche et à un contact de confiance.";
    } else if (_currentRiskScore >= 40) {
      return "Ce que tu décris est sérieux. Tu n'es pas seule. Peux-tu me dire si tu te sens en sécurité physique en ce moment ? Je peux te proposer des techniques de protection immédiate.";
    }
    return "Merci de me partager cela. Je t'écoute sans jugement. Comment te sens-tu émotionnellement aujourd'hui — sur une échelle de 1 à 10 ?";
  }

  Future<void> resetRisk() async {
    _currentRiskScore = 20;
    notifyListeners();
  }
}
