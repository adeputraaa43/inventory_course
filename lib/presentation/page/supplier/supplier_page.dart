import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../config/app_color.dart';
import '../../../config/app_format.dart';
import '../../../data/model/supplier.dart';
import 'add_supplier_page.dart';
import 'package:d_info/d_info.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({Key? key}) : super(key: key);

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  List<Supplier> suppliers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndSetSuppliers();
  }

  Future<void> fetchAndSetSuppliers() async {
    setState(() => isLoading = true);
    try {
      final resp = await http.get(Uri.parse(
        "http://10.0.2.2/inventory_course/api_inventory_course/supplier/get.php",
      ));
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        if (data['success']) {
          suppliers =
              (data['data'] as List).map((e) => Supplier.fromJson(e)).toList();
        }
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteSupplier(String id) async {
    final confirm = await DInfo.dialogConfirmation(
      context,
      'Hapus Supplier',
      'Yakin ingin menghapus supplier ini?',
      textNo: 'Tidak',
      textYes: 'Iya',
    );
    if (!confirm) return;
    try {
      final resp = await http.post(
        Uri.parse(
            "http://10.0.2.2/inventory_course/api_inventory_course/supplier/delete.php"),
        body: {'id_supplier': id},
      );
      final data = json.decode(resp.body);
      if (data['success']) {
        DInfo.toastSuccess('Supplier dihapus');
        await fetchAndSetSuppliers();
      } else {
        DInfo.toastError(data['message'] ?? 'Gagal menghapus');
      }
    } catch (e) {
      DInfo.toastError('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Supplier')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : suppliers.isEmpty
              ? const Center(child: Text("Belum ada data supplier."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: suppliers.length,
                  itemBuilder: (ctx, i) {
                    final s = suppliers[i];

                    final int j = int.tryParse(s.jumlahProduk ?? '0') ?? 0;
                    final int t = int.tryParse(s.produkTerjual ?? '0') ?? 0;
                    final double h = (s.harga ?? 0).toDouble();
                    final int sisa = j - t;
                    final double totalBayar = t * h;

                    return Card(
                      color: isDark ? Colors.grey[850] : Colors.grey[200],
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.namaSupplier ?? '-',
                              style: tt.titleMedium?.copyWith(
                                color: cs.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _row(Icons.shopping_bag, Colors.orangeAccent,
                                'Produk: ${s.namaProduk}', cs, tt),
                            _row(Icons.phone, Colors.greenAccent,
                                'No. Telepon: ${s.noTelp}', cs, tt),
                            _row(Icons.confirmation_number, Colors.amberAccent,
                                'Jumlah Produk: $j', cs, tt),
                            _row(Icons.sell, Colors.lightBlueAccent,
                                'Produk Terjual: $t', cs, tt),
                            _row(Icons.inventory_2, Colors.purpleAccent,
                                'Sisa Produk: $sisa', cs, tt),
                            const Divider(height: 8, color: Colors.white24),
                            _row(
                              Icons.attach_money,
                              AppColor.primary,
                              'Total Bayar Ke Supplier: Rp ${AppFormat.currency(totalBayar.toString())}',
                              cs,
                              tt,
                            ),
                            const Divider(height: 8, color: Colors.white24),
                            _row(Icons.calendar_today, Colors.cyan,
                                'Tanggal: ${s.createdAt}', cs, tt),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.amber),
                                  onPressed: () async {
                                    final res = await Get.to(
                                        () => AddSupplierPage(supplier: s));
                                    if (res == true) fetchAndSetSuppliers();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () =>
                                      deleteSupplier(s.idSupplier.toString()),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primary,
        child: const Icon(Icons.add),
        onPressed: () async {
          final res = await Get.to(() => const AddSupplierPage());
          if (res == true) fetchAndSetSuppliers();
        },
      ),
    );
  }

  Widget _row(
      IconData icon, Color col, String text, ColorScheme cs, TextTheme tt) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: col, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child:
                Text(text, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
          ),
        ],
      ),
    );
  }
}
