import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/community_service.dart';
import '../widgets/primary_button.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});
  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _ctrl = TextEditingController();
  String _cat = 'témoignage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle publication')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Catégorie', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: ['témoignage', 'conseil', 'juridique', 'soutien'].map((c) =>
            ChoiceChip(label: Text(c), selected: _cat == c, onSelected: (_) => setState(() => _cat = c))
          ).toList()),
          const SizedBox(height: 20),
          Expanded(child: TextField(
            controller: _ctrl, maxLines: null, expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: 'Partagez votre histoire ou votre conseil. Anonyme.',
            ),
          )),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Publier anonymement', icon: Icons.send_rounded, onPressed: () async {
            if (_ctrl.text.trim().isEmpty) return;
            await context.read<CommunityService>().publish(content: _ctrl.text.trim(), category: _cat);
            if (mounted) context.pop();
          }),
        ]),
      ),
    );
  }
}
