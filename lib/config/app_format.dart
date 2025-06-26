import 'package:intl/intl.dart';

class AppFormat {
  static String currency(String number) {
    return NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 2)
        .format(double.parse(number));
  }

  static String date(String date) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    return DateFormat('EEE, d MMMM yyyy').format(dateTime);
  }

  static String dateTime(String rawDateTime) {
    try {
      DateTime dt = DateTime.parse(rawDateTime).toLocal();
      return DateFormat('dd MMM yyyy • HH:mm').format(dt);
    } catch (e) {
      return rawDateTime;
    }
  }

  static String bulan(int bulan) {
    List<String> namaBulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return namaBulan[bulan];
  }
}
