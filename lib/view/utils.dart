import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }
}
