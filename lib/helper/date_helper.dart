import 'package:intl/intl.dart';

class DateHelper {
  static String formatHHmm(DateTime? dateTime) {
    if (dateTime == null) return '-';

    return DateFormat('HH:mm').format(dateTime);
  }
}
