import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/care_service.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/risk_badge.dart';

class CareChatScreen extends StatefulWidget {
  const CareChatScreen({super.key});
  @override
  State<CareChatScreen> createState() => _CareChatScreenState();
}

class _CareChatScreenState extends State<CareChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  bool _typing = false;

  void _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    final care = context.read<CareService>();
    _ctrl.clear();
    await care.sendUserMessage('care', text);
    _scrollDown();
    setState(() => _typing = true);
    await care.generateAIResponse('care', text);
    setState(() => _typing = false);
    _scrollDown();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final care = context.watch<CareService>();
    final msgs = care.conversation('care');

    return Scaffold(
      appBar: AppBar(
        title: const Text('KAMKAM Care'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: RiskBadge(score: care.currentRiskScore)),
          ),
        ],
      ),
      body: Column(
        children: [
          if (msgs.isEmpty)
            Expanded(child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 24),
                  Text('Je suis là, sans jugement.', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text('Partagez ce que vous vivez. Tout est confidentiel et reste sur votre téléphone.',
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
                ]),
              ),
            ))
          else
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.all(16),
                itemCount: msgs.length + (_typing ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i == msgs.length) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(padding: EdgeInsets.all(12), child: Text('KAMKAM écrit…',
                        style: TextStyle(color: AppColors.textMuted, fontStyle: FontStyle.italic))),
                    );
                  }
                  return ChatBubble(message: msgs[i]);
                },
              ),
            ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              top: false,
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    minLines: 1, maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Écrivez votre message…',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _send,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
