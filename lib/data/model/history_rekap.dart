class HistoryRekap {
  final int bulan;
  final int total;

  HistoryRekap({required this.bulan, required this.total});

  factory HistoryRekap.fromJson(Map<String, dynamic> json) {
    return HistoryRekap(
      bulan: int.parse(json['bulan'].toString()),
      total: int.parse(json['total_penjualan'].toString()),
    );
  }
}
