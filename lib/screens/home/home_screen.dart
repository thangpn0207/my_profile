import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/core/sections.dart';
import 'package:my_profile/screens/main/main_screen.dart';

import '../../core/app_dimensions.dart';
import '../../components/terminal/terminal_panel.dart';
import 'components/highlights.dart';
import 'components/home_banner.dart';
import 'components/my_projects.dart';
import 'components/recommendations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialSection});

  final Section? initialSection;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Section? _pendingSection;

  @override
  void initState() {
    super.initState();
    _pendingSection = widget.initialSection;
    // Trigger data loading when screen initializes
    context.read<MyInfoBloc>().add(OnInit());
  }

  void _scrollOnce() {
    final s = _pendingSection;
    if (s == null) return;
    _pendingSection = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToSection(s));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyInfoBloc, MyInfoState>(
      listenWhen: (p, c) =>
          p.loadingState != c.loadingState &&
          c.loadingState == LoadingState.loaded,
      listener: (_, __) => _scrollOnce(),
      child: MainScreen(
        children: [
          KeyedSubtree(key: Section.home.key, child: const HomeBanner()),
          KeyedSubtree(key: Section.terminal.key, child: const TerminalPanel()),
          KeyedSubtree(key: Section.stats.key, child: const HighLightsInfo()),
          SizedBox(height: AppDimensions.paddingM),
          KeyedSubtree(key: Section.projects.key, child: const MyProjects()),
          SizedBox(height: AppDimensions.paddingM),
          KeyedSubtree(key: Section.about.key, child: const AboutMe()),
        ],
      ),
    );
  }
}
