import 'package:flutter_test/flutter_test.dart';
import 'package:my_profile/core/sections.dart';

void main() {
  test('Section.tryParse', () {
    expect(Section.tryParse('projects'), Section.projects);
    expect(Section.tryParse('nope'), isNull);
    expect(Section.tryParse(null), isNull);
  });
}
