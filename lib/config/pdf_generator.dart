import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../data/model/history.dart';
import '../data/source/source_history.dart';

class PdfGenerator {
  static Future<pw.Document> generateHistoryPdf(List<History> riwayat) async {
    final pdf = pw.Document();
    final List<History> riwayatLengkap = [];

    // Ambil detail lengkap setiap riwayat
    for (var h in riwayat) {
      if (h.idHistory != null) {
        final detail = await SourceHistory.getWhereId(h.idHistory.toString());
        riwayatLengkap.add(detail);
      }
    }

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Table.fromTextArray(
              headers: [
                'Kode Produk',
                'Nama Produk',
                'Quantity',
                'Total Harga',
                'Jenis',
                'Tanggal'
              ],
              data: riwayatLengkap.expand((item) {
                if (item.listProduct != null && item.listProduct!.isNotEmpty) {
                  final List<dynamic> listProduct =
                      jsonDecode(item.listProduct!);
                  return listProduct.map((p) {
                    final kode = p['code']?.toString() ?? '';
                    final namaProduk = p['name']?.toString() ?? '';
                    final qty =
                        '${p['quantity'] ?? ''} ${p['unit'] ?? ''}'.trim();
                    final totalHarga = NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(
                        double.tryParse(item.totalPrice?.toString() ?? '0') ??
                            0);

                    final jenis = item.type ?? '';
                    final tanggal =
                        (item.createdAt != null && item.createdAt!.isNotEmpty)
                            ? DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(item.createdAt!))
                            : '';

                    return [kode, namaProduk, qty, totalHarga, jenis, tanggal];
                  }).toList();
                }
                return <List<String>>[];
              }).toList(),
            ),
          ];
        },
      ),
    );

    return pdf;
  }
}
