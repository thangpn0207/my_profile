import 'package:flutter_test/flutter_test.dart';
import 'package:my_profile/components/terminal/terminal_commands.dart';
import 'package:my_profile/core/sections.dart';
import 'package:my_profile/models/my_project.dart';
import 'package:my_profile/models/user_info.dart';

void main() {
  final user = UserInfo.fromJson({
    'name': 'Thang',
    'role': 'Flutter developer',
    'city': 'Ha Noi',
    'country': 'VIET NAM',
    'university': 'GREENWICH',
    'coding': [
      {'percent': 0.95, 'name': 'Flutter'},
      {'percent': 0.5, 'name': 'Dart'},
    ],
    'cvURL': 'cv.pdf',
    'githubURL': 'https://github.com/x',
    'linkinURL': 'https://linkedin.com/in/x',
    'facebookURL': null,
    'mailto': 'a@b.com',
  });
  final projects = [
    MyProject.fromJson({'name': 'Alpha', 'company': 'C', 'role': 'R'}),
    MyProject.fromJson({'name': 'Beta', 'company': 'C', 'role': 'R'}),
  ];
  final ctx = TerminalContext(user: user, projects: projects);
  const empty = TerminalContext();

  test('help lists every command', () {
    final text = runCommand('help', ctx).lines.join('\n');
    for (final n in terminalCommandNames) {
      expect(text, contains(n));
    }
  });

  test('projects', () {
    final r = runCommand('projects', ctx);
    expect(r.navigateTo, Section.projects);
    expect(r.lines.where((l) => l.contains('Alpha')).length, 1);
    expect(r.lines.where((l) => l.contains('Beta')).length, 1);
  });

  test('about navigates', () {
    expect(runCommand('about', ctx).navigateTo, Section.about);
  });

  test('skills bars', () {
    final lines = runCommand('skills', ctx).lines;
    expect(lines[0], contains('██████████'));
    expect(lines[0], isNot(contains('░')));
    expect(lines[1], contains('█████░░░░░'));
  });

  test('contact', () {
    final t = runCommand('contact', ctx).lines.join('\n');
    expect(t, contains('a@b.com'));
    expect(t, contains('https://github.com/x'));
  });

  test('cv', () {
    expect(runCommand('cv', ctx).openUrl, 'cv.pdf');
  });

  test('social lists non-null only', () {
    final t = runCommand('social', ctx).lines.join('\n');
    expect(t, contains('linkedin.com'));
    expect(t, contains('github.com'));
    expect(t.toLowerCase(), isNot(contains('facebook')));
  });

  test('clear', () {
    expect(runCommand('clear', ctx).clear, isTrue);
  });

  test('sudo hire-me', () {
    expect(runCommand('sudo hire-me', ctx).openUrl, startsWith('mailto:'));
  });

  test('normalizes input', () {
    expect(runCommand('  HELP  ', ctx).lines, runCommand('help', ctx).lines);
  });

  test('empty input', () {
    expect(runCommand('', ctx).lines, isEmpty);
    expect(runCommand('   ', ctx).lines, isEmpty);
  });

  test('unknown command', () {
    expect(runCommand('foo', ctx).lines,
        ["command not found: foo. Type 'help'."]);
  });

  test('null user', () {
    for (final c in ['whoami', 'skills', 'contact', 'cv', 'social']) {
      expect(runCommand(c, empty).lines, ['data not loaded yet'], reason: c);
    }
  });

  test('huge input does not throw', () {
    final r = runCommand('a' * 5000, ctx);
    expect(r.lines.length, 1);
    expect(r.lines.first.length, lessThan(100));
  });

  test('completeCommand', () {
    expect(completeCommand('pro'), 'projects');
    expect(completeCommand('x'), isNull);
    expect(completeCommand(''), isNull);
  });
}
