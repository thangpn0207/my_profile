import 'package:intl/intl.dart';

final DateFormat dateFormatterMDY = DateFormat('MM/dd/yyyy');

extension ExtString on String? {
  DateTime? convertToDateTime() {
    if (this?.isEmpty ?? true) {
      return null;
    }
    return DateTime.tryParse(this!);
  }

  String formatStringToDOB() {
    DateTime? converted = convertToDateTime();
    if (converted == null) {
      return '';
    }
    return dateFormatterMDY.format(converted);
  }

  int formatStringToExp() {
    DateTime? converted = convertToDateTime();
    if (converted == null) {
      return 0;
    }
    final days = converted.difference(DateTime.now()).inDays;
    return (days ~/ 365).abs();
  }
}
