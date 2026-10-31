import '../../core/sections.dart';
import '../../models/more_info.dart';
import '../../models/my_project.dart';
import '../../models/user_info.dart';

class TerminalContext {
  const TerminalContext({
    this.user,
    this.moreInfos = const [],
    this.projects = const [],
  });

  final UserInfo? user;
  final List<MoreInfo> moreInfos;
  final List<MyProject> projects;
}

class TerminalResult {
  const TerminalResult({
    this.lines = const [],
    this.navigateTo,
    this.openUrl,
    this.clear = false,
  });

  final List<String> lines;
  final Section? navigateTo;
  final String? openUrl;
  final bool clear;
}

const List<String> terminalCommandNames = [
  'help',
  'whoami',
  'about',
  'skills',
  'projects',
  'contact',
  'social',
  'cv',
  'clear',
];

const _help = {
  'help': 'list commands',
  'whoami': 'who am I',
  'about': 'jump to About section',
  'skills': 'coding skills',
  'projects': 'list projects',
  'contact': 'how to reach me',
  'social': 'social links',
  'cv': 'open my CV',
  'clear': 'clear the screen',
};

const _notLoaded = TerminalResult(lines: ['data not loaded yet']);

String? completeCommand(String prefix) {
  final p = prefix.trim().toLowerCase();
  if (p.isEmpty) return null;
  for (final n in terminalCommandNames) {
    if (n.startsWith(p)) return n;
  }
  return null;
}

String _bar(double? percent) {
  final n = ((percent ?? 0) * 10).round().clamp(0, 10);
  return ('█' * n).padRight(10, '░');
}

TerminalResult runCommand(String input, TerminalContext ctx) {
  final cmd = input.trim().toLowerCase();
  if (cmd.isEmpty) return const TerminalResult();
  final user = ctx.user;

  switch (cmd) {
    case 'help':
      return TerminalResult(lines: [
        for (final e in _help.entries) '${e.key.padRight(10)}${e.value}',
      ]);
    case 'clear':
      return const TerminalResult(clear: true);
    case 'about':
      return TerminalResult(lines: [
        for (final m in ctx.moreInfos) ...?m.details,
        'scrolling to About...',
      ], navigateTo: Section.about);
    case 'projects':
      return TerminalResult(
        lines: ctx.projects.isEmpty
            ? ['no projects found']
            : [
                for (final p in ctx.projects)
                  '${p.name ?? '?'} - ${p.company ?? ''} (${p.role ?? ''})',
              ],
        navigateTo: Section.projects,
      );
    case 'sudo hire-me':
      final m = ctx.user?.mailto;
      if (m == null || m.isEmpty) return _notLoaded;
      return TerminalResult(
        lines: ['permission granted. opening mail client...'],
        openUrl: m.startsWith('mailto:') ? m : 'mailto:$m',
      );
  }

  if (!{'whoami', 'skills', 'contact', 'cv', 'social'}.contains(cmd)) {
    final shown = cmd.length > 40 ? '${cmd.substring(0, 40)}…' : cmd;
    return TerminalResult(lines: ["command not found: $shown. Type 'help'."]);
  }
  if (user == null) return _notLoaded;

  switch (cmd) {
    case 'whoami':
      return TerminalResult(lines: [
        '${user.name ?? ''} - ${user.role ?? ''}',
        '${user.city ?? ''}, ${user.country ?? ''}',
        user.university ?? '',
      ]);
    case 'skills':
      final coding = user.coding ?? [];
      return TerminalResult(
        lines: coding.isEmpty
            ? ['no skills found']
            : [
                for (final c in coding)
                  '${(c.name ?? '?').padRight(10)} ${_bar(c.percent)} '
                      '${((c.percent ?? 0) * 100).round()}%',
              ],
      );
    case 'contact':
      return TerminalResult(lines: [
        'email:  ${user.mailto ?? 'n/a'}',
        'github: ${user.githubURL ?? 'n/a'}',
      ]);
    case 'social':
      final links = {
        'linkedin': user.linkinURL,
        'github': user.githubURL,
        'facebook': user.facebookURL,
      };
      return TerminalResult(lines: [
        for (final e in links.entries)
          if (e.value != null && e.value!.isNotEmpty)
            '${e.key.padRight(10)}${e.value}',
      ]);
    default: // cv
      final url = user.cvURL;
      if (url == null || url.isEmpty) {
        return const TerminalResult(lines: ['cv not available']);
      }
      return TerminalResult(lines: ['opening cv...'], openUrl: url);
  }
}
