# PROFILE_OS Upgrade — Design Spec

Date: 2026-10-31 · Branch: `feat/profile-os-upgrade`

## Goal

Make the existing terminal-style (black/yellow) Flutter Web profile faster and more interactive without changing its visual identity. Audience: recruiters and engineers opening the link; success = page usable in < 1.5 s after Flutter boots, and at least one "memorable" interaction (terminal) that also showcases Flutter skill.

Out of scope: redesign, light theme, i18n, content rewrite, skill-percentage removal (Hướng C), URL sync on manual scroll.

## 1. Foundation fixes

| # | Change | Where |
|---|--------|-------|
| F1 | Remove fake `Future.delayed(5s)`; remove `finally` that overwrites `err` with `initial` so the error overlay can show | `lib/bloc/my_info_bloc.dart` |
| F2 | Stop `setState` on every scroll tick. Parallax offset goes into a `ValueNotifier<double>`; only the background layer listens (`ValueListenableBuilder`) | `lib/screens/main/main_screen.dart` |
| F3 | Delete dead parallax in `HomeBanner` (`NotificationListener` never receives the ancestor's scroll; `_scrollOffset` is always 0). Banner becomes `StatelessWidget` | `lib/screens/home/components/home_banner.dart` |
| F4 | Viewport meta → `width=device-width, initial-scale=1.0` (allow zoom). Add Open Graph + Twitter card meta (title, description, `og:image` = `avatar_cv.png` copied to `web/og.png`) | `web/index.html` |
| F5 | Bundle Share Tech Mono + Outfit `.ttf` under `assets/google_fonts/`, set `GoogleFonts.config.allowRuntimeFetching = false` in `main()`. **Gated:** needs user approval to download the font files; if not approved, this item is skipped and runtime fetching stays | `pubspec.yaml`, `main.dart` |
| F6 | Remove unused deps: `lottie`, `gif`, `image_network`, `cached_network_image`, `http`, `dio`, `pretty_dio_logger`; delete `lib/service/api.dart` and unreferenced assets (`animation_bg.json`, `gifs/loading.gif`, `check.svg`, `download.svg`, `dribble.svg`) after a grep confirms no reference | `pubspec.yaml`, `lib/`, `assets/` |
| F7 | Replace stale counter-template `test/widget_test.dart` with the tests in §7 | `test/` |

Data issue noted, not part of code work: `linkinURL` in `assets/data/raw_data.json` ends with a stray `α`. Fixed only when the user supplies the correct URL.

## 2. Section navigation (shared by terminal, Cmd+K, highlights button)

- `lib/core/sections.dart`: `enum Section { home, stats, terminal, projects, about }`, each with a `GlobalKey` and a display label. Replaces `ProjectKeys` (its two keys move here; `highlights.dart:410` switches to the new helper).
- `void scrollToSection(Section s)` → `Scrollable.ensureVisible(key.currentContext!, duration: 600ms, curve: easeInOutCubic)`, no-op if context is null; then replaces the browser URL to `/#/<section>` via `SystemNavigator.routeInformationUpdated(uri: ..., replace: true)`.
- `HomeScreen` wraps each child with `KeyedSubtree(key: section.key)`.
- `app_route.dart`: add `GoRoute(path: '/:section')` → `HomeScreen(initialSection: Section.values.byName(...))` (unknown name → no scroll). `HomeScreen` scrolls to `initialSection` after data loads (first frame where `loadingState == loaded`).

## 3. Interactive terminal

Placement: new `TerminalPanel` section directly below `HomeBanner` (before highlights), `GlassContainer`, fixed height ~260 px desktop / ~220 px mobile, header bar `guest@thangpn:~$` with three dots.

Files (`lib/components/terminal/`):
- `terminal_commands.dart` — pure Dart, no Flutter imports beyond what models need. `TerminalResult run(String input, TerminalContext ctx)` where `TerminalContext` holds `UserInfo`, `MoreInfo` list, `MyProject` list. `TerminalResult { List<String> lines; Section? navigateTo; String? openUrl; bool clear; }`. Also exports `List<String> commandNames` and `String? complete(String prefix)`.
- `terminal_panel.dart` — widget: scrollable output `ListView`, `TextField` input (no autofocus), suggestion chips (`help`, `projects`, `skills`, `contact`, `cv`) that run on tap. ↑/↓ history, Tab autocompletes. Executes `navigateTo` via `scrollToSection`, `openUrl` via `url_launcher`.

Commands: `help`, `whoami`, `about` (prints MoreInfo details + navigates about), `skills` (prints coding list with ASCII bars), `projects` (prints project names + navigates projects), `contact` (mail/phone/github), `social`, `cv` (opens `cvURL`), `clear`, `sudo hire-me` (joke line + opens mailto). Unknown → `command not found: <x>. Type 'help'.` Input is trimmed and lower-cased; empty input prints nothing.

Intro on mount: types one line `Type 'help' to explore — or tap a command below.`

## 4. Cursor spotlight

- `MainScreen` wraps the stack in `MouseRegion(onHover)` writing to `ValueNotifier<Offset?> pointer` (null on exit).
- `GridPainter` gains `Offset? pointer`; `TechGridBackground` takes the notifier and merges it with the controller via `Listenable.merge`. Painter additionally draws: a radial gradient (primary @ 0.08 → transparent, radius 250) at pointer, and grid lines within the radius re-stroked at alpha 0.18.
- Disabled when not desktop or `MediaQuery.disableAnimationsOf(context)`.

## 5. Scroll reveal + glitch

- `lib/components/reveal_on_scroll.dart`: `RevealOnScroll({child, delay})`. Listens to `Scrollable.maybeOf(context)?.position`; on each notification checks its `RenderBox` top < viewport bottom − 40; once true, sets `revealed` and removes listener. Renders `child.animate(target: revealed ? 1 : 0).fadeIn().slideY(begin: .08)`. If no ancestor Scrollable or reduced motion → shows child immediately.
- Applied to: highlights counters, `MyProjects` cards (staggered delay `index * 60ms`), `AboutMe`. `RevealOnScroll` exposes its state through an `InheritedWidget` (`RevealScope.of(context)` → bool); `AnimatedCounter` reads it and tweens to its value only once revealed (shows 0 before). Sidebar skill bars are unchanged (sidebar is visible on load).
- The existing per-child `.animate().fadeIn()` in `MainScreen` column is removed (replaced by reveal) to avoid double animation.
- `lib/components/glitch_text.dart`: `GlitchText(text, style)`. Stack of 3 `Text` (red/cyan offsets ±2 px, alpha .7) visible during a 400 ms jitter played on first build and on hover (desktop). Reduced motion → plain `Text`. Used for `PROJECT_LOGS` and `CORE_IDENTITY` headings.

## 6. 3D cards, command palette, Konami

- **Tilt:** `ProjectCard` stores local hover position; wraps card in `Transform(alignment: center, transform: Matrix4.identity()..setEntry(3,2,0.001)..rotateX(-dy*0.14)..rotateY(dx*0.14))` with dx,dy ∈ [-1,1] (≈ 8°), animated back to 0 on exit via `TweenAnimationBuilder`. Desktop only.
- **Cmd/Ctrl+K:** `CallbackShortcuts` at `MainScreen` (`SingleActivator(K, meta: true)` and `control: true`) opens `CommandPalette` dialog: autofocused filter `TextField` + list of `Section` entries + `cv`, `contact`. Enter/tap → close and run (`scrollToSection` or terminal command result). Esc closes.
- **Konami:** `HardwareKeyboard.instance.addHandler` in `MainScreen` state matches ↑↑↓↓←→←→BA sequence; triggers `MatrixRainOverlay` (CustomPainter, yellow glyphs, 5 s, `IgnorePointer`) inserted via `OverlayEntry`. Skipped under reduced motion.

## 7. Testing

- `test/terminal_commands_test.dart`: help lists all commands; `projects` returns names + `navigateTo: Section.projects`; unknown command message; `clear` sets clear; `complete('pro') == 'projects'`; whitespace/case handling.
- `test/home_smoke_test.dart`: pump app with `MyInfoBloc` seeded (HydratedBloc storage mocked via in-memory `Storage`), verify `TerminalPanel` renders and entering `help` shows a known line.
- `flutter analyze` clean (no new warnings).
- Manual: `flutter run -d web-server`, verify in browser at 1440×900 and 375×812: boot < 1.5 s, terminal commands, spotlight, reveal, glitch, tilt, Cmd+K, `/#/projects` deep link, Konami.

## Risks

- `BackdropFilter` (GlassContainer) + extra repainting could drop frames on low-end GPUs → spotlight repaint is isolated by `RepaintBoundary` already on the grid.
- Keyboard handlers must not fire while typing in the terminal: Konami handler ignores events when `FocusManager.instance.primaryFocus` is an `EditableText`.
