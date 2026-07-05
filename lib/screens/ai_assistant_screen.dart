import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../theme.dart';
import 'products_screen.dart';

/// "Grundfos Assist" — an AI product advisor UI. Answers are generated
/// on-device from the real catalogue (no external service), so the feature
/// demonstrates the experience for the proposal without a backend.
class AiAssistantScreen extends StatefulWidget {
  final String? seedQuestion;

  const AiAssistantScreen({super.key, this.seedQuestion});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _ChatMessage {
  final bool fromUser;
  final String text;
  final List<ProductFamily> suggestions;
  _ChatMessage(this.fromUser, this.text, [this.suggestions = const []]);
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _thinking = false;

  static const _prompts = [
    'Recommend a pump for domestic hot water',
    'Which pumps are best for wastewater?',
    'Show me circulator pumps',
    'I need a booster for pressure boosting',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(_ChatMessage(false,
        'Hi, I’m Grundfos Assist. Tell me about your application — the '
        'liquid, the job, the setting — and I’ll suggest pumps from the '
        'catalogue.'));
    if (widget.seedQuestion != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _send(widget.seedQuestion!));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(String raw) {
    final text = raw.trim();
    if (text.isEmpty || _thinking) return;
    setState(() {
      _messages.add(_ChatMessage(true, text));
      _thinking = true;
      _controller.clear();
    });
    _scrollDown();
    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      final (reply, suggestions) = _answer(text);
      setState(() {
        _thinking = false;
        _messages.add(_ChatMessage(false, reply, suggestions));
      });
      _scrollDown();
    });
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  /// On-device retrieval over the real catalogue: score products by term
  /// overlap with title/description, plus application keyword matches.
  (String, List<ProductFamily>) _answer(String query) {
    final repo = CatalogueRepository.instance;
    final q = query.toLowerCase();
    final terms = q
        .split(RegExp(r'[^a-z0-9]+'))
        .where((t) => t.length > 2)
        .toSet();

    final scored = <ProductFamily, int>{};
    for (final p in repo.products) {
      final hay = '${p.title} ${p.description}'.toLowerCase();
      var score = 0;
      for (final t in terms) {
        if (hay.contains(t)) score += 2;
      }
      if (p.sizable) score += 1;
      if (score > 0) scored[p] = score;
    }
    final ranked = scored.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = ranked.take(3).map((e) => e.key).toList();

    if (top.isEmpty) {
      return (
        'I couldn’t find a close match for that. Try naming the application '
        '(heating, wastewater, pressure boosting) or a pump type.',
        <ProductFamily>[]
      );
    }
    return (
      'Based on the catalogue, here ${top.length == 1 ? 'is a match' : 'are ${top.length} matches'} '
      'for “$query”. Tap any product for specs, performance curves and '
      'downloads.',
      top
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                  gradient: GfGradients.ai, shape: BoxShape.circle),
              child: const Icon(Icons.auto_awesome,
                  size: 16, color: GfColors.white),
            ),
            const SizedBox(width: 10),
            const Text('Grundfos Assist',
                style: TextStyle(
                    fontFamily: 'Grundfos-Extd', fontWeight: FontWeight.w700)),
          ],
        ),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_thinking ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == _messages.length) return const _TypingBubble();
                return _Bubble(message: _messages[i]);
              },
            ),
          ),
          if (_messages.length <= 1)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (final p in _prompts)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ActionChip(
                        label: Text(p),
                        backgroundColor: GfColors.grey100,
                        side: const BorderSide(color: GfColors.grey300),
                        onPressed: () => _send(p),
                      ),
                    ),
                ],
              ),
            ),
          _Composer(controller: _controller, onSend: () => _send(_controller.text)),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final _ChatMessage message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final fromUser = message.fromUser;
    return Column(
      crossAxisAlignment:
          fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.82),
          decoration: BoxDecoration(
            gradient: fromUser ? null : GfGradients.ai,
            color: fromUser ? GfColors.grey100 : null,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(fromUser ? 16 : 4),
              bottomRight: Radius.circular(fromUser ? 4 : 16),
            ),
          ),
          child: Text(message.text,
              style: TextStyle(
                  color: fromUser ? GfColors.ink : GfColors.white,
                  height: 1.45,
                  fontSize: 14.5)),
        ),
        for (final p in message.suggestions)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: GfColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GfColors.grey200),
              boxShadow: gfCardShadow,
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: p.image != null
                  ? Image.asset(p.image!, width: 44, height: 44, fit: BoxFit.contain)
                  : const Icon(Icons.water_drop_outlined),
              title: Text(p.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: GfColors.actionBlue)),
              subtitle: Text(p.description,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.chevron_right, color: GfColors.actionBlue),
              onTap: () {
                RecentlyViewed.instance.add(p);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ProductFamilyScreen(product: p)));
              },
            ),
          ),
      ],
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: GfGradients.ai,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const SizedBox(
        width: 36,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(0), SizedBox(width: 4), _Dot(150), SizedBox(width: 4), _Dot(300),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delayMs;
  const _Dot(this.delayMs);
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = ((_c.value * 900 - widget.delayMs) % 900) / 900;
        final op = 0.3 + 0.7 * (t < 0.5 ? t * 2 : (1 - t) * 2);
        return Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: GfColors.white.withValues(alpha: op.clamp(0.3, 1.0)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _Composer({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          12, 8, 12, 8 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: GfColors.white,
        border: Border(top: BorderSide(color: GfColors.grey200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Describe your application…',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 46,
              height: 46,
              decoration:
                  const BoxDecoration(gradient: GfGradients.ai, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_upward, color: GfColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
