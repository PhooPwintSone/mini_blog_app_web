import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  //using simple datetime without dependencies
  // return "${date.day}/${date.month}/${date.year}";

  return DateFormat("d MMM, yyyy").format(date);
}
