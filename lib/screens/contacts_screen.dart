import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/contacts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/primary_button.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContactsService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts de confiance')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAdd(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Ajouter', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          GlassCard(
            gradient: AppColors.calmGradient,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Votre filet de sécurité',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textDark)),
              SizedBox(height: 8),
              Text('Jusqu\'à 5 personnes recevront vos alertes silencieuses, y compris via votre mot de code SMS.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 24),
          ...svc.contacts.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: Text(c.name[0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('${c.relation} · ${c.phone}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ])),
                Switch(
                  value: c.isTrusted, activeColor: AppColors.primary,
                  onChanged: (_) => svc.toggleTrusted(c.id),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                  onPressed: () => svc.remove(c.id),
                ),
              ]),
            ),
          )),
        ],
      ),
    );
  }

  void _showAdd(BuildContext context) {
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final relC = TextEditingController(text: 'Amie');
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Nouveau contact', style: Theme.of(ctx).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextField(controller: nameC, decoration: const InputDecoration(hintText: 'Nom')),
            const SizedBox(height: 12),
            TextField(controller: phoneC, decoration: const InputDecoration(hintText: 'Téléphone'), keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            TextField(controller: relC, decoration: const InputDecoration(hintText: 'Relation')),
            const SizedBox(height: 20),
            PrimaryButton(label: 'Enregistrer', onPressed: () async {
              if (nameC.text.isEmpty || phoneC.text.isEmpty) return;
              try {
                await context.read<ContactsService>().add(
                  name: nameC.text, phone: phoneC.text, relation: relC.text);
                if (ctx.mounted) Navigator.pop(ctx);
              } catch (e) {
                if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }),
          ]),
        ),
      ),
    );
  }
}
