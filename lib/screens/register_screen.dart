import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _pin = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _lang = 'fr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Créer un profil', style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                const Text('Anonyme. Aucune donnée ne quitte votre téléphone.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                const SizedBox(height: 32),
                const Text('Prénom (ou pseudonyme)', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(hintText: 'Marie, Aïssatou…'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 20),
                const Text('Code PIN secret (4 chiffres)', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pin,
                  decoration: const InputDecoration(hintText: '••••'),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) => (v == null || v.length != 4) ? '4 chiffres requis' : null,
                ),
                const SizedBox(height: 20),
                const Text('Langue préférée', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  for (final entry in const {
                    'fr':'Français', 'en':'English', 'ff':'Fulfulde',
                    'ewo':'Ewondo', 'dua':'Duala', 'bam':'Bamoun'}.entries)
                    ChoiceChip(
                      label: Text(entry.value),
                      selected: _lang == entry.key,
                      onSelected: (_) => setState(() => _lang = entry.key),
                    ),
                ]),
                const SizedBox(height: 40),
                PrimaryButton(
                  label: 'Créer mon profil',
                  icon: Icons.shield_outlined,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    await context.read<AuthService>().register(
                      name: _name.text.trim(), pin: _pin.text, language: _lang,
                    );
                    if (mounted) context.go('/home');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
