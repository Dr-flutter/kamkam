import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/community_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String _category = 'tout';
  static const _cats = ['tout', 'témoignage', 'conseil', 'juridique', 'soutien'];

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<CommunityService>();
    final posts = svc.posts(category: _category);
    return Scaffold(
      appBar: AppBar(title: const Text('KAMKAM Espace')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/community/new'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text('Publier', style: TextStyle(color: Colors.white)),
      ),
      body: Column(children: [
        SizedBox(
          height: 56,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _cats.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final c = _cats[i];
              return ChoiceChip(
                label: Text(c[0].toUpperCase() + c.substring(1)),
                selected: _category == c,
                onSelected: (_) => setState(() => _category = c),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final p = posts[i];
              return GlassCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withOpacity(0.15),
                      child: Text(p.pseudonym[0],
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.pseudonym, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(DateFormat('dd MMM · HH:mm', 'fr').format(p.createdAt),
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    ])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(p.category, style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Text(p.content, style: const TextStyle(fontSize: 15, height: 1.5)),
                  const SizedBox(height: 12),
                  Row(children: [
                    InkWell(
                      onTap: () => svc.heart(p.id),
                      child: Row(children: [
                        const Icon(Icons.favorite, size: 18, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text('${p.hearts}', style: const TextStyle(color: AppColors.textMuted)),
                      ]),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text('${p.comments}', style: const TextStyle(color: AppColors.textMuted)),
                  ]),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }
}
