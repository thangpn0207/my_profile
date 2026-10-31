# PROFILE_OS Upgrade Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the Flutter Web profile load fast and add an interactive terminal, cursor spotlight, scroll reveals, 3D project cards, Cmd/Ctrl+K palette and section deep links, keeping the black/yellow terminal look.

**Architecture:** A shared `Section` enum + `scrollToSection()` is the single navigation path used by the terminal, the command palette and existing buttons. The terminal's command logic is pure Dart (`terminal_commands.dart`) so it is unit-testable; widgets only render. Pointer and scroll state travel through `ValueNotifier`s so only the background layer repaints.

**Tech Stack:** Flutter 3.41 / Dart 3.11 web, flutter_bloc + hydrated_bloc, go_router, flutter_animate, google_fonts (bundled), url_launcher, flutter_test.

**Spec:** `docs/superpowers/specs/2026-10-31-profile-os-upgrade-design.md`

## Global Constraints

- Branch `feat/profile-os-upgrade`; one commit per task, message ends with `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`.
- Visual identity unchanged: colors from `lib/core/app_colors.dart`, mono font Share Tech Mono.
- Spotlight, tilt, glitch, matrix rain are desktop-only and disabled when `MediaQuery.disableAnimationsOf(context)` is true.
- Terminal input does not autofocus; Konami handler ignores events while an `EditableText` has primary focus.
- Deep links use hash URLs `/#/<section>`; unknown section names open the page without scrolling.
- `flutter analyze` must report no new issues after every task.
- Font download is user-approved (Google Fonts, OFL license). LinkedIn URL is changed only if the user supplies the correct one.

## Review Focus

- Terminal used before data loads (`UserInfo` null) → prints `data not loaded yet`, never throws.
- Deep link `/#/does-not-exist` → page renders normally, no exception, no scroll.
- Data load fails → error overlay with REBOOT is visible and REBOOT reloads (was impossible before F1).
- Very long or whitespace-only terminal input → no overflow, whitespace-only prints nothing.
- Typing `ArrowUp ArrowUp …` in the terminal field must not trigger Konami; Cmd+K inside the terminal field still opens the palette.

---

## File Structure

| File | Responsibility |
|------|----------------|
| `lib/core/sections.dart` (new) | `Section` enum, keys, `scrollToSection` |
| `lib/components/terminal/terminal_commands.dart` (new) | Pure command parsing/execution |
| `lib/components/terminal/terminal_panel.dart` (new) | Terminal UI |
| `lib/components/command_palette.dart` (new) | Cmd/Ctrl+K dialog |
| `lib/components/reveal_on_scroll.dart` (new) | `RevealOnScroll` + `RevealScope` |
| `lib/components/glitch_text.dart` (new) | `GlitchText` |
| `lib/components/matrix_rain_overlay.dart` (new) | Konami effect |
| `lib/core/project_keys.dart` (delete) | Replaced by sections |
| Modified | `my_info_bloc.dart`, `main_screen.dart`, `home_banner.dart`, `home_screen.dart`, `app_route.dart`, `tech_grid_background.dart`, `animated_counter.dart`, `highlights.dart`, `my_projects.dart`, `recommendations.dart`, `project_card.dart`, `main.dart`, `pubspec.yaml`, `web/index.html` |

---

### Task 1: Loading and scroll-performance fixes (F1–F3)

**Files:**
- Modify: `lib/bloc/my_info_bloc.dart:46-59`, `lib/screens/main/main_screen.dart:22-33,46-50`, `lib/screens/home/components/home_banner.dart`

**Interfaces:**
- Produces: `MainScreen` keeps a `ValueNotifier<double> _parallax`; `HomeBanner` becomes `StatelessWidget`.

- [ ] **Step 1:** In `_onInit`, delete `await Future.delayed(...)` and the `finally` block so the `catch` leaves `LoadingState.err`.
- [ ] **Step 2:** In `MainScreen`, replace `_parallaxOffset` + `setState` with a `ValueNotifier<double>` updated by the scroll listener; wrap only the `Transform.translate(... TechGridBackground)` in `ValueListenableBuilder`. Dispose the notifier.
- [ ] **Step 3:** In `HomeBanner` delete `_scrollOffset`, the `NotificationListener`, and the two `_scrollOffset` offsets (`Positioned.top` → `-50`, avatar `Transform.translate` removed). Convert to `StatelessWidget`.
- [ ] **Step 4:** Run `flutter analyze` → no issues; run `flutter run -d chrome` briefly: boot overlay disappears within ~1 s and scrolling is smooth.
- [ ] **Step 5:** Commit `fix: remove fake load delay, surface load errors, stop per-scroll rebuilds`.

### Task 2: Web meta, dependency cleanup, bundled fonts (F4–F7)

**Files:**
- Modify: `web/index.html`, `pubspec.yaml`, `lib/main.dart`
- Delete: `lib/service/api.dart`, `assets/gifs/loading.gif`, `assets/images/animation_bg.json`, `assets/icons/{check,download,dribble}.svg`, `test/widget_test.dart`
- Create: `web/og.png` (copy of `assets/images/avatar_cv.png`), `assets/google_fonts/*.ttf`

**Interfaces:**
- Produces: fonts resolved locally; `GoogleFonts.config.allowRuntimeFetching = false` set in `main()` before `runApp`.

- [ ] **Step 1:** `grep -rn` each file/package name above under `lib/` and `test/`; delete only those with zero references (`api.dart`, listed assets) and remove `dio`, `pretty_dio_logger`, `image_network`, `cached_network_image`, `http`, `lottie`, `gif` from `pubspec.yaml` plus the `assets/gifs/` entry. Run `flutter pub get`.
- [ ] **Step 2:** Edit `web/index.html`: viewport → `width=device-width, initial-scale=1.0`; add `og:title`, `og:description`, `og:type=website`, `og:image=og.png`, `twitter:card=summary`.
- [ ] **Step 3:** Download Share Tech Mono Regular and Outfit (Regular/Medium/SemiBold/Bold) `.ttf` from Google Fonts into `assets/google_fonts/` with filenames `ShareTechMono-Regular.ttf`, `Outfit-<Weight>.ttf`; register under `assets:` (`- assets/google_fonts/`). google_fonts matches bundled files by family-weight names, so keep those names.
- [ ] **Step 4:** In `main()` add `GoogleFonts.config.allowRuntimeFetching = false;` after `ensureInitialized()`.
- [ ] **Step 5:** `flutter analyze` clean; `flutter build web` succeeds; open the app and confirm via browser network log that no request goes to `fonts.gstatic.com`.
- [ ] **Step 6:** Commit `chore: bundle fonts, add OG meta, allow zoom, remove dead deps`.

### Task 3: Section navigation and deep links

**Files:**
- Create: `lib/core/sections.dart`
- Delete: `lib/core/project_keys.dart`
- Modify: `lib/screens/home/home_screen.dart`, `lib/core/app_route.dart`, `lib/screens/home/components/highlights.dart:405-420`
- Test: `test/sections_test.dart`

**Interfaces:**
- Produces: `enum Section { home, stats, terminal, projects, about }` with `GlobalKey key` and `String label`; `static Section? Section.tryParse(String? name)`; `Future<void> scrollToSection(Section s)`.
- `HomeScreen({Section? initialSection})`.

- [ ] **Step 1:** Write `test/sections_test.dart`: `Section.tryParse('projects') == Section.projects`; `tryParse('nope') == null`; `tryParse(null) == null`.
- [ ] **Step 2:** Run `flutter test test/sections_test.dart` → FAIL (undefined).
- [ ] **Step 3:** Implement `sections.dart`. `scrollToSection` calls `Scrollable.ensureVisible` (600 ms, `Curves.easeInOutCubic`) when `key.currentContext != null`, then `SystemNavigator.routeInformationUpdated(uri: Uri(path: '/${s.name}'), replace: true)`.
- [ ] **Step 4:** In `HomeScreen`, wrap each child in `KeyedSubtree(key: section.key)` for sections home/stats/projects/about (`terminal` is added in Task 5); in `initState` store `initialSection`; scroll to it with `addPostFrameCallback` once `MyInfoBloc` state is `loaded` (use a `BlocListener`).
- [ ] **Step 5:** `app_route.dart`: add `GoRoute(path: '/:section', builder: → HomeScreen(initialSection: Section.tryParse(state.pathParameters['section'])))`. Replace `ProjectKeys.projectsKey` use in `highlights.dart` with `scrollToSection(Section.projects)`.
- [ ] **Step 6:** Run `flutter test` → PASS; manually open `/#/projects` → page scrolls to Projects after load; `/#/does-not-exist` renders with no scroll.
- [ ] **Step 7:** Commit `feat: section navigation and deep links`.

### Task 4: Terminal command engine (TDD)

**Files:**
- Create: `lib/components/terminal/terminal_commands.dart`
- Test: `test/terminal_commands_test.dart`

**Interfaces:**
- Produces:
  - `class TerminalContext { const TerminalContext({this.user, this.moreInfos = const [], this.projects = const []}); final UserInfo? user; final List<MoreInfo> moreInfos; final List<MyProject> projects; }`
  - `class TerminalResult { const TerminalResult({this.lines = const [], this.navigateTo, this.openUrl, this.clear = false}); final List<String> lines; final Section? navigateTo; final String? openUrl; final bool clear; }`
  - `const List<String> terminalCommandNames` (`help, whoami, about, skills, projects, contact, social, cv, clear`)
  - `TerminalResult runCommand(String input, TerminalContext ctx)`
  - `String? completeCommand(String prefix)`

- [ ] **Step 1:** Write tests (build `UserInfo`/`MyProject` with their `fromJson` using minimal maps): `help` lines contain every name in `terminalCommandNames`; `projects` returns one line per project name and `navigateTo == Section.projects`; `about` → `navigateTo == Section.about`; `skills` prints each coding name with a bar of `round(percent*10)` `█` characters (Flutter 0.95 → `██████████` capped at 10); `contact` includes `mailto` and `githubURL`; `cv` sets `openUrl == user.cvURL`; `social` lists linkedin/github/facebook URLs that are non-null; `clear` → `clear == true`; `sudo hire-me` → `openUrl` starts with `mailto:`; `"  HELP  "` behaves like `help`; `""` and `"   "` → empty result; `foo` → lines `['command not found: foo. Type \'help\'.']`; with `ctx.user == null`, `whoami`/`skills`/`contact`/`cv`/`social` → `['data not loaded yet']`; a 5000-char input → single not-found line (no throw); `completeCommand('pro') == 'projects'`, `completeCommand('x') == null`, `completeCommand('') == null`.
- [ ] **Step 2:** Run `flutter test test/terminal_commands_test.dart` → FAIL.
- [ ] **Step 3:** Implement `terminal_commands.dart` (no Flutter widget imports; import `sections.dart` and models only). Truncate echoed unknown-command text to 40 chars.
- [ ] **Step 4:** Run the test file → PASS; `flutter analyze` clean.
- [ ] **Step 5:** Commit `feat: terminal command engine with tests`.

### Task 5: Terminal panel UI

**Files:**
- Create: `lib/components/terminal/terminal_panel.dart`
- Modify: `lib/core/sections.dart` (already has `terminal`), `lib/screens/home/home_screen.dart`
- Test: `test/terminal_panel_test.dart`

**Interfaces:**
- Consumes: `runCommand`, `completeCommand`, `terminalCommandNames`, `scrollToSection`, `MyInfoBloc` state (`userInfo`, `moreInfos`, `myProjects`).
- Produces: `class TerminalPanel extends StatefulWidget` (no params; reads bloc via `BlocBuilder`).

- [ ] **Step 1:** Write widget test: pump `TerminalPanel` inside `MaterialApp` + `BlocProvider<MyInfoBloc>` (set `HydratedBloc.storage` to an in-memory fake in `setUp`); enter `help` via `tester.enterText` + `testTextInput.receiveAction(TextInputAction.done)`; expect `find.textContaining('whoami')` found. Another test: tapping the `projects` suggestion chip adds a `projects` echo line.
- [ ] **Step 2:** Run it → FAIL.
- [ ] **Step 3:** Implement panel: `GlassContainer` with header `guest@thangpn:~$` and three dots, fixed height 260 (desktop) / 220 (mobile, via `ResponsiveBreakpoints`); output `ListView` auto-scrolling to the end; `TextField` without autofocus; suggestion `ActionChip`s for `help, projects, skills, contact, cv`; ↑/↓ history via `Focus.onKeyEvent`; Tab completes via `completeCommand`; on result: apply `clear`, call `scrollToSection(navigateTo)`, `launchUrl(Uri.parse(openUrl))` (for `cv` resolve relative path the same way `lib/screens/main/components/side_menu.dart:95-112` does). Intro line on mount: `Type 'help' to explore — or tap a command below.`
- [ ] **Step 4:** Insert `TerminalPanel()` after `HomeBanner` in `HomeScreen` children, keyed with `Section.terminal.key`.
- [ ] **Step 5:** `flutter test` → PASS; browser: run `projects` → page scrolls; `cv` opens the PDF.
- [ ] **Step 6:** Commit `feat: interactive terminal panel`.

### Task 6: Cursor spotlight

**Files:**
- Modify: `lib/components/tech_grid_background.dart`, `lib/screens/main/main_screen.dart`

**Interfaces:**
- Produces: `TechGridBackground({required ValueListenable<Offset?> pointer})`; `GridPainter(double animationValue, Offset? pointer)`.

- [ ] **Step 1:** `MainScreen` owns `ValueNotifier<Offset?> _pointer`; wrap the body `Stack` in `MouseRegion(onHover: set, onExit: set null)`.
- [ ] **Step 2:** `TechGridBackground` builds with `AnimatedBuilder(animation: Listenable.merge([_controller, pointer]))`. `GridPainter.paint`, when `pointer != null`: draw radial gradient (primary α0.08 → transparent, radius 250) and re-stroke grid lines inside the radius at α0.18 (clip to circle). `shouldRepaint` compares both fields.
- [ ] **Step 3:** Pass `ValueNotifier(null)` (never updated) when not desktop or `disableAnimationsOf` is true.
- [ ] **Step 4:** `flutter analyze`; browser: moving the mouse lights the grid, mobile viewport shows none.
- [ ] **Step 5:** Commit `feat: cursor spotlight on grid background`.

### Task 7: Scroll reveal, counters, glitch headings

**Files:**
- Create: `lib/components/reveal_on_scroll.dart`, `lib/components/glitch_text.dart`
- Modify: `lib/components/animated_counter.dart`, `lib/screens/main/main_screen.dart:219-224`, `lib/screens/home/components/{highlights,my_projects,recommendations}.dart`
- Test: `test/reveal_on_scroll_test.dart`

**Interfaces:**
- Produces: `RevealOnScroll({required Widget child, Duration delay = Duration.zero})`; `RevealScope.of(BuildContext) -> bool` (false when no scope); `GlitchText(String text, {required TextStyle style})`.

- [ ] **Step 1:** Test: in a `SingleChildScrollView` with a 2000 px spacer above, a `RevealOnScroll` child reports `RevealScope.of == false` initially, and `true` after `tester.drag` scrolls it into view; with no ancestor Scrollable it is revealed immediately.
- [ ] **Step 2:** Run → FAIL.
- [ ] **Step 3:** Implement `RevealOnScroll` (listen to `Scrollable.maybeOf(context)?.position`, check `RenderBox` top < viewport bottom − 40 on first frame and each scroll; reveal once; render child via `.animate(target: …).fadeIn().slideY(begin: .08)` honoring `delay`; reduced-motion → revealed immediately) and `RevealScope` inherited widget.
- [ ] **Step 4:** `AnimatedCounter` reads `RevealScope.of(context)`: tween end = revealed ? `value` : 0. Wrap highlight counters block, each `ProjectCard` (delay `index * 60ms`) and `AboutMe` in `RevealOnScroll`. Remove the `.animate().fadeIn().slideY()` on the `MainScreen` column children.
- [ ] **Step 5:** `GlitchText`: three stacked `Text` (red/cyan offset ±2 px, α0.7) visible only during a 400 ms jitter run on first build and on desktop hover; otherwise plain `Text`; plain `Text` under reduced motion. Use it for `PROJECT_LOGS` (`my_projects.dart:45`) and `CORE_IDENTITY` (`recommendations.dart:44`).
- [ ] **Step 6:** `flutter test` → PASS; browser: counters count when scrolled into view.
- [ ] **Step 7:** Commit `feat: scroll reveal, counter trigger, glitch headings`.

### Task 8: 3D tilt, command palette, Konami rain

**Files:**
- Create: `lib/components/command_palette.dart`, `lib/components/matrix_rain_overlay.dart`
- Modify: `lib/screens/home/components/project_card.dart`, `lib/screens/main/main_screen.dart`
- Test: `test/command_palette_test.dart`

**Interfaces:**
- Produces: `Future<void> showCommandPalette(BuildContext context, TerminalContext ctx)`; `class MatrixRainOverlay extends StatefulWidget { const MatrixRainOverlay({super.key, required this.onDone}); final VoidCallback onDone; }`.
- Consumes: `runCommand`, `scrollToSection`, `Section.values`.

- [ ] **Step 1:** Test: pumping a palette, entering `proj` leaves only entries containing `proj` (case-insensitive) visible; empty filter shows all `Section` labels plus `cv` and `contact`.
- [ ] **Step 2:** Run → FAIL.
- [ ] **Step 3:** Implement palette (dialog, autofocused filter field, list; Enter/tap runs `scrollToSection` for sections, or `runCommand` for `cv`/`contact` and applies `openUrl`; Esc closes).
- [ ] **Step 4:** `MainScreen`: wrap in `CallbackShortcuts` with `SingleActivator(LogicalKeyboardKey.keyK, meta: true)` and `control: true` → `showCommandPalette`. Register a `HardwareKeyboard.instance.addHandler` Konami matcher (↑↑↓↓←→←→ B A); return false always; skip when `FocusManager.instance.primaryFocus?.context?.widget is EditableText` (or ancestor); on match insert `MatrixRainOverlay` into `Overlay`, removed by `onDone` after 5 s; skip under reduced motion. Remove handler in `dispose`.
- [ ] **Step 5:** `ProjectCard`: track hover position → `dx, dy ∈ [-1,1]`; apply `Transform(alignment: Alignment.center, transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateX(-dy * 0.14)..rotateY(dx * 0.14))` via `TweenAnimationBuilder` (150 ms) returning to 0 on exit; desktop only.
- [ ] **Step 6:** `flutter test` → PASS; browser: Cmd+K opens palette (also while terminal field focused); Konami on the page shows rain; typing arrows in terminal does not.
- [ ] **Step 7:** Commit `feat: tilt cards, command palette, konami rain`.

### Task 9: Verification, LinkedIn, wrap-up

**Files:**
- Modify: `assets/data/raw_data.json` (`linkinURL`, only if user supplies it)
- Test: `test/home_smoke_test.dart`

- [ ] **Step 1:** Smoke test: pump `MyApp` with in-memory `HydratedBloc.storage`; `await tester.pumpAndSettle(const Duration(seconds: 2))`; expect `find.byType(TerminalPanel)` found and no exception.
- [ ] **Step 2:** Run `flutter test` → all PASS; `flutter analyze` → no issues.
- [ ] **Step 3:** Run `flutter run -d web-server --web-port 5050`, open in browser at 1440×900 and 375×812 and walk the spec §7 manual list (boot < 1.5 s, terminal, spotlight, reveal, glitch, tilt, Cmd+K, `/#/projects`, Konami, zoom allowed). Fix defects found, recommit under their task's area.
- [ ] **Step 4:** Ask the user for the correct LinkedIn URL; if supplied, update `linkinURL` and verify the sidebar icon opens it.
- [ ] **Step 5:** Commit `chore: verification fixes` if anything changed; do not push or open a PR without the user's go-ahead.
