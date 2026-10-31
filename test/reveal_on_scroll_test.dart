import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_profile/components/animated_counter.dart';
import 'package:my_profile/components/reveal_on_scroll.dart';

class _Probe extends StatelessWidget {
  const _Probe(this.sink);
  final List<bool> sink;
  @override
  Widget build(BuildContext context) {
    sink.add(RevealScope.of(context));
    return const SizedBox(height: 100, width: 100);
  }
}

void main() {
  regressionTests();
  testWidgets('reveals after scrolling into view', (tester) async {
    final seen = <bool>[];
    await tester.pumpWidget(MaterialApp(
      home: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 2000),
          RevealOnScroll(child: _Probe(seen)),
          const SizedBox(height: 600),
        ]),
      ),
    ));
    await tester.pump();
    expect(seen.last, false);
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -1900));
    await tester.pumpAndSettle();
    expect(seen.last, true);
  });

  testWidgets('revealed immediately without Scrollable', (tester) async {
    final seen = <bool>[];
    await tester
        .pumpWidget(MaterialApp(home: RevealOnScroll(child: _Probe(seen))));
    await tester.pumpAndSettle();
    expect(seen.last, true);
  });

  testWidgets('counter outside any scope counts up', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: AnimatedCounter(value: 5, text: '+'))));
    await tester.pumpAndSettle();
    expect(find.text('5+'), findsOneWidget);
  });
}

void regressionTests() {
  testWidgets('items in nested non-scrollable grid reveal on outer scroll',
      (tester) async {
    final seen = <bool>[];
    await tester.pumpWidget(MaterialApp(
      home: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 2000),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, mainAxisExtent: 100),
            itemBuilder: (_, __) => RevealOnScroll(child: _Probe(seen)),
          ),
          const SizedBox(height: 600),
        ]),
      ),
    ));
    await tester.pump();
    expect(seen.last, false);
    await tester.drag(
        find.byType(SingleChildScrollView).first, const Offset(0, -1900));
    await tester.pumpAndSettle();
    expect(seen.last, true);
  });
}
