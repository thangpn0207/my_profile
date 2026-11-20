import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/components/command_palette.dart';
import 'package:my_profile/components/matrix_rain_overlay.dart';
import 'package:my_profile/components/tech_grid_background.dart';
import 'package:my_profile/components/terminal/terminal_commands.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:my_profile/components/glass_container.dart';
import '../../core/app_colors.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.children});

  final List<Widget> children;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _parallax = ValueNotifier(0);
  // Spotlight position in grid-painter space (see _setPointer).
  final ValueNotifier<Offset?> _pointer = ValueNotifier(null);
  // Never updated: used when the spotlight is disabled.
  final ValueNotifier<Offset?> _noPointer = ValueNotifier(null);

  // The grid is translated by -parallax*0.15, so painter y = screen y + parallax*0.15.
  void _setPointer(Offset? screenPos) => _pointer.value =
      screenPos == null ? null : screenPos + Offset(0, _parallax.value * 0.15);

  TerminalContext _termCtx = const TerminalContext();
  int _konami = 0;
  OverlayEntry? _rain;

  bool _onKey(KeyEvent e) {
    if (e is! KeyDownEvent || _rain != null) return false;
    // Ignore while the user types in a text field (e.g. the terminal).
    final typing = FocusManager.instance.primaryFocus?.context
            ?.findAncestorWidgetOfExactType<EditableText>() !=
        null;
    if (typing) return false;
    _konami = konamiAdvance(_konami, e.logicalKey);
    if (_konami == 10) {
      _konami = 0;
      if (ResponsiveBreakpoints.of(context).isDesktop &&
          !MediaQuery.disableAnimationsOf(context)) {
        final entry = OverlayEntry(
          builder: (_) => MatrixRainOverlay(onDone: _removeRain),
        );
        _rain = entry;
        Overlay.of(context).insert(entry);
      }
    }
    return false;
  }

  void _removeRain() {
    _rain
      ?..remove()
      ..dispose();
    _rain = null;
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
    _scrollController.addListener(() {
      _parallax.value = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _removeRain();
    _scrollController.dispose();
    _parallax.dispose();
    _pointer.dispose();
    _noPointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        final spotlight = ResponsiveBreakpoints.of(context).isDesktop &&
            !MediaQuery.disableAnimationsOf(context);
        _termCtx = TerminalContext(
          user: state.userInfo,
          moreInfos: state.moreInfos,
          projects: state.myProjects,
        );
        void openPalette() => showCommandPalette(context, _termCtx);
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.keyK, meta: true):
                openPalette,
            const SingleActivator(LogicalKeyboardKey.keyK, control: true):
                openPalette,
          },
          child: Focus(
            autofocus: true,
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: MouseRegion(
                onHover: (e) {
                  if (spotlight) _setPointer(e.localPosition);
                },
                onExit: (_) {
                  if (spotlight) _setPointer(null);
                },
                child: Stack(
                  children: [
                    // Enhanced Parallax Tech Grid
                    ValueListenableBuilder<double>(
                      valueListenable: _parallax,
                      child: TechGridBackground(
                          pointer: spotlight ? _pointer : _noPointer),
                      builder: (context, offset, child) => Transform.translate(
                        offset: Offset(0, -(offset * 0.15)),
                        child: child,
                      ),
                    ),

                    AnimatedSwitcher(
                      duration: 800.ms,
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      layoutBuilder: (Widget? currentChild,
                          List<Widget> previousChildren) {
                        return Stack(
                          children: <Widget>[
                            ...previousChildren,
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },
                      child: _buildChildByState(context, state),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChildByState(BuildContext context, MyInfoState state) {
    if (state.loadingState == LoadingState.loading && state.userInfo == null) {
      return _buildLoadingOverlay(key: const ValueKey('loading'));
    }
    if (state.loadingState == LoadingState.err) {
      return _buildErrorOverlay(key: const ValueKey('error'));
    }
    return _buildMainContent(context, key: const ValueKey('content'));
  }

  Widget _buildLoadingOverlay({required Key key}) {
    return Container(
      key: key,
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                'SYSTEM_BOOTING',
                style: GoogleFonts.shareTechMono(
                  color: AppColors.primary,
                  fontSize: 28,
                  letterSpacing: 6,
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 2.seconds, color: AppColors.accentYellow)
                .shake(hz: 2, curve: Curves.easeInOut),
            const SizedBox(height: 50),
            SizedBox(
              width: 250,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.surface,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorOverlay({required Key key}) {
    return Container(
      key: key,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.terminal, size: 80, color: AppColors.error)
                .animate(onPlay: (c) => c.repeat())
                .shimmer(color: Colors.white, duration: 1.seconds),
            const SizedBox(height: 20),
            Text(
              'FATAL_ERROR: DATA_INITIALIZATION_FAILED',
              style: GoogleFonts.shareTechMono(
                  color: AppColors.error, fontSize: 18),
            ),
            const SizedBox(height: 40),
            OutlinedButton(
              onPressed: () => context.read<MyInfoBloc>().add(OnInit()),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text('REBOOT',
                  style: GoogleFonts.shareTechMono(color: AppColors.error)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, {required Key key}) {
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return Scaffold(
      key: key,
      backgroundColor: Colors.transparent,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.background.withValues(alpha: 0.95),
              elevation: 0,
              centerTitle: true,
              leading: Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu, color: AppColors.primary),
                ),
              ),
              title: Text(
                'PROFILE_OS v4.0',
                style: GoogleFonts.shareTechMono(
                    color: AppColors.primary, fontSize: 14),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                    color: AppColors.primary.withValues(alpha: 0.1), height: 1),
              ),
            ),
      drawer: isDesktop ? null : SideMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            SizedBox(
              width: (MediaQuery.sizeOf(context).width * 0.25).clamp(300, 380),
              child: GlassContainer(
                margin: const EdgeInsets.all(20),
                borderRadius: 12.0,
                opacity: 0.6,
                boxBorder: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15)),
                child: SideMenu(),
              )
                  .animate()
                  .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic)
                  .fadeIn(),
            ),
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 20 : 16,
                  vertical: isDesktop ? 20 : 10,
                ),
                child: Center(
                  // Keep line length readable on wide monitors.
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      children: [
                        ...widget.children.map((child) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: child,
                            )),
                        const SizedBox(height: 60),
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.4),
        border: Border(
            top: BorderSide(color: AppColors.primary.withValues(alpha: 0.1))),
      ),
      child: Column(
        children: [
          Text(
            'DESIGNED_BY // PHAM_NGOC_THANG',
            style: GoogleFonts.shareTechMono(
                color: AppColors.primary, fontSize: 14, letterSpacing: 2),
          ),
          const SizedBox(height: 12),
          Text(
            'BUILT_WITH_FLUTTER_AND_PASSION © 2026',
            style: GoogleFonts.shareTechMono(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                fontSize: 10),
          ),
        ],
      ),
    );
  }
}
