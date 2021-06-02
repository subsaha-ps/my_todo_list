import 'package:intl/intl.dart';

class Utility {
  static String getFormattedDateString(DateTime? date) {
    if (date != null) return DateFormat.yMEd().add_jms().format(date);
    return '';
  }
}
