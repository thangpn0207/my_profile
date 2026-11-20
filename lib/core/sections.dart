import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Section {
  home('Home'),
  stats('Stats'),
  terminal('Terminal'),
  projects('Projects'),
  about('About');

  const Section(this.label);

  final String label;

  /// One static key per section; only one HomeScreen is mounted at a time.
  GlobalKey get key => _keys[this]!;

  static final Map<Section, GlobalKey> _keys = {
    for (final s in Section.values) s: GlobalKey(debugLabel: s.name),
  };

  static Section? tryParse(String? name) {
    for (final s in Section.values) {
      if (s.name == name) return s;
    }
    return null;
  }
}

Future<void> scrollToSection(Section s) async {
  final ctx = s.key.currentContext;
  if (ctx == null) return;
  await Scrollable.ensureVisible(
    ctx,
    duration: const Duration(milliseconds: 600),
    curve: Curves.easeInOutCubic,
  );
  SystemNavigator.routeInformationUpdated(
      uri: Uri(path: '/${s.name}'), replace: true);
}
