import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/care_service.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/glass_card.dart';

class MenModuleScreen extends StatefulWidget {
  const MenModuleScreen({super.key});
  @override
  State<MenModuleScreen> createState() => _MenModuleScreenState();
}

class _MenModuleScreenState extends State<MenModuleScreen> {
  int _tab = 0;
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Module Hommes')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Coach'), icon: Icon(Icons.air)),
              ButtonSegment(value: 1, label: Text('Apprendre'), icon: Icon(Icons.menu_book)),
              ButtonSegment(value: 2, label: Text('Groupes'), icon: Icon(Icons.groups)),
            ],
            selected: {_tab},
            onSelectionChanged: (s) => setState(() => _tab = s.first),
          ),
        ),
        Expanded(child: IndexedStack(index: _tab, children: [_chat(), _learn(), _groups()])),
      ]),
    );
  }

  Widget _chat() {
    final msgs = context.watch<CareService>().conversation('anger');
    return Column(children: [
      Expanded(child: msgs.isEmpty
        ? const Center(child: Padding(
            padding: EdgeInsets.all(32),
            child: Text('Décrivez ce que vous ressentez. Le coach vous proposera une technique de décompression.',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
          ))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: msgs.length,
            itemBuilder: (_, i) => ChatBubble(message: msgs[i]),
          )),
      Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
        child: SafeArea(top: false, child: Row(children: [
          Expanded(child: TextField(controller: _ctrl, decoration: const InputDecoration(hintText: 'Comment vous sentez-vous ?', border: InputBorder.none))),
          IconButton(icon: const Icon(Icons.send_rounded, color: Color(0xFF6D4C41)), onPressed: () async {
            if (_ctrl.text.isEmpty) return;
            final t = _ctrl.text; _ctrl.clear();
            final s = context.read<CareService>();
            await s.sendUserMessage('anger', t);
            await s.generateAIResponse('anger', t);
          }),
        ])),
      ),
    ]);
  }

  Widget _learn() {
    const items = [
      ('Reconnaître les signaux de la colère', 'Cœur qui s\'accélère, mâchoire serrée, voix qui monte… Apprenez à les capter tôt.'),
      ('Déconstruire la masculinité toxique', 'Pourquoi "être un homme" ne signifie pas dominer ou contrôler.'),
      ('Communication non violente', 'Exprimer un besoin sans accuser, écouter sans interrompre.'),
      ('Respect du consentement', 'Comprendre les limites et les respecter en toute circonstance.'),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => GlassCard(
        onTap: () {},
        child: Row(children: [
          const Icon(Icons.menu_book_rounded, color: Color(0xFF6D4C41)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(items[i].$1, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(items[i].$2, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
          ])),
        ]),
      ),
    );
  }

  Widget _groups() {
    const groups = [
      ('Groupe Yaoundé · Mardis', 'Coach Jean-Marc · 12 membres'),
      ('Groupe Douala · Jeudis', 'Coach Patrick · 8 membres'),
      ('En ligne · Samedis', 'Coach Patricia · 24 membres'),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => GlassCard(
        onTap: () {},
        child: Row(children: [
          const CircleAvatar(backgroundColor: Color(0xFFFFE0B2), child: Icon(Icons.groups, color: Color(0xFF6D4C41))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(groups[i].$1, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(groups[i].$2, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ])),
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ]),
      ),
    );
  }
}
