import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/components/glass_container.dart';
import 'package:my_profile/components/terminal/terminal_commands.dart';
import 'package:my_profile/core/app_colors.dart';
import 'package:my_profile/core/sections.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

const _chips = ['help', 'projects', 'skills', 'contact', 'cv'];

class TerminalPanel extends StatefulWidget {
  const TerminalPanel({super.key});

  @override
  State<TerminalPanel> createState() => _TerminalPanelState();
}

class _TerminalPanelState extends State<TerminalPanel> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();
  final _lines = <String>["Type 'help' to explore — or tap a command below."];
  final _history = <String>[];
  int _histIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _open(String url) async {
    var s = url;
    if (!s.startsWith('http') && !s.startsWith('mailto') && !s.startsWith('tel')) {
      // Same approach as side_menu: resolve relative assets against Uri.base.
      final base = Uri.base.toString().split('?').first.split('#').first;
      s = base.endsWith('/') ? '$base$s' : '$base/$s';
    }
    try {
      await launchUrl(Uri.parse(s));
    } catch (_) {}
  }

  void _run(String input) {
    final text = input.trim();
    _controller.clear();
    if (text.isEmpty) return;
    final st = context.read<MyInfoBloc>().state;
    final r = runCommand(
      text,
      TerminalContext(
          user: st.userInfo, moreInfos: st.moreInfos, projects: st.myProjects),
    );
    _history.add(text);
    _histIndex = _history.length;
    setState(() {
      if (r.clear) {
        _lines.clear();
      } else {
        _lines..add('\$ $text')..addAll(r.lines);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
    if (r.navigateTo != null) scrollToSection(r.navigateTo!);
    if (r.openUrl != null) _open(r.openUrl!);
  }

  void _setText(String t) => _controller.value =
      TextEditingValue(text: t, selection: TextSelection.collapsed(offset: t.length));

  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    if (e is KeyUpEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.tab) {
      final c = completeCommand(_controller.text);
      if (c != null) _setText(c);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowUp && _history.isNotEmpty) {
      _histIndex = (_histIndex - 1).clamp(0, _history.length - 1);
      _setText(_history[_histIndex]);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowDown && _history.isNotEmpty) {
      _histIndex = (_histIndex + 1).clamp(0, _history.length);
      _setText(_histIndex == _history.length ? '' : _history[_histIndex]);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final mono = GoogleFonts.shareTechMono(color: AppColors.textPrimary, fontSize: 14);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return GlassContainer(
      height: isMobile ? 220 : 260,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            for (final c in [Colors.red, Colors.amber, Colors.green])
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(color: c, shape: BoxShape.circle),
              ),
            const SizedBox(width: 6),
            Text('guest@thangpn:~\$',
                style: mono.copyWith(color: AppColors.primary, fontSize: 12)),
          ]),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              itemCount: _lines.length,
              itemBuilder: (_, i) => Text(_lines[i], style: mono, softWrap: true),
            ),
          ),
          Wrap(spacing: 8, children: [
            for (final c in _chips)
              ActionChip(
                label: Text(c, style: mono.copyWith(fontSize: 12)),
                onPressed: () => _run(c),
              ),
          ]),
          Focus(
            onKeyEvent: _onKey,
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              style: mono,
              onSubmitted: (v) {
                _run(v);
                _focus.requestFocus();
              },
              decoration: InputDecoration(
                prefixText: '\$ ',
                prefixStyle: mono.copyWith(color: AppColors.primary),
                isDense: true,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
