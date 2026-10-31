import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_colors.dart';
import '../core/sections.dart';
import 'terminal/terminal_commands.dart';

class _Entry {
  const _Entry(this.label, this.run);
  final String label;
  final Future<void> Function() run;
}

// Duplicate of terminal_panel.dart's private _open (resolves relative assets).
Future<void> _open(String url) async {
  var s = url;
  if (!s.startsWith('http') &&
      !s.startsWith('mailto') &&
      !s.startsWith('tel')) {
    final base = Uri.base.toString().split('?').first.split('#').first;
    s = base.endsWith('/') ? '$base$s' : '$base/$s';
  }
  try {
    await launchUrl(Uri.parse(s));
  } catch (_) {}
}

Future<void> showCommandPalette(BuildContext context, TerminalContext ctx) {
  final entries = [
    for (final s in Section.values) _Entry(s.label, () => scrollToSection(s)),
    _Entry('cv', () async {
      final url = runCommand('cv', ctx).openUrl;
      if (url != null) await _open(url);
    }),
    _Entry('contact', () async {
      final m = ctx.user?.mailto;
      if (m != null && m.isNotEmpty) await _open('mailto:$m');
    }),
  ];
  return showDialog<void>(
    context: context,
    builder: (_) => _Palette(entries: entries),
  );
}

class _Palette extends StatefulWidget {
  const _Palette({required this.entries});
  final List<_Entry> entries;

  @override
  State<_Palette> createState() => _PaletteState();
}

class _PaletteState extends State<_Palette> {
  String _q = '';

  List<_Entry> get _matches => widget.entries
      .where((e) => e.label.toLowerCase().contains(_q.toLowerCase()))
      .toList();

  void _run(_Entry e) {
    Navigator.of(context).pop();
    e.run();
  }

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.shareTechMono(color: AppColors.primary);
    final matches = _matches;
    return Dialog(
      backgroundColor: AppColors.surface,
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.only(top: 80, left: 16, right: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              style: style,
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                prefixText: '> ',
                prefixStyle: style,
                hintText: 'jump to...',
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
              ),
              onChanged: (v) => setState(() => _q = v),
              onSubmitted: (_) {
                if (matches.isNotEmpty) _run(matches.first);
              },
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final e in matches)
                    ListTile(
                      dense: true,
                      title: Text(e.label, style: style),
                      onTap: () => _run(e),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
