import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/care_service.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';

class RightsChatScreen extends StatefulWidget {
  const RightsChatScreen({super.key});
  @override
  State<RightsChatScreen> createState() => _RightsChatScreenState();
}

class _RightsChatScreenState extends State<RightsChatScreen> {
  final _ctrl = TextEditingController();

  static const _suggestions = [
    'Violence conjugale',
    'Procédure de divorce',
    'Garde des enfants',
    'Harcèlement au travail',
  ];

  void _send([String? preset]) async {
    final text = preset ?? _ctrl.text.trim();
    if (text.isEmpty) return;
    final care = context.read<CareService>();
    _ctrl.clear();
    await care.sendUserMessage('rights', text);
    await care.generateAIResponse('rights', text);
  }

  @override
  Widget build(BuildContext context) {
    final msgs = context.watch<CareService>().conversation('rights');
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Droits')),
      body: Column(
        children: [
          Expanded(
            child: msgs.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Posez une question juridique. Quelques sujets fréquents :',
                      style: TextStyle(color: AppColors.textMuted)),
                    const SizedBox(height: 16),
                    Wrap(spacing: 8, runSpacing: 8, children: _suggestions.map((s) =>
                      ActionChip(
                        label: Text(s),
                        onPressed: () => _send(s),
                      )).toList()),
                  ]),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: msgs.length,
                  itemBuilder: (_, i) => ChatBubble(message: msgs[i]),
                ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(
                      hintText: 'Votre question juridique…',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send_rounded, color: AppColors.gold), onPressed: () => _send()),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
