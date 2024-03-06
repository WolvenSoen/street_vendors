import 'package:intl/intl.dart';

class Formatters{
  static String formatDate(DateTime date){
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatCurrency(double value){
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(value);
  }

  static String formatPhoneNumber(String value){
    return value.replaceAllMapped(RegExp(r'(\d{2})(\d{5})(\d{4})'), (match){
      return '(${match[1]}) ${match[2]}-${match[3]}';
    });
  }
}