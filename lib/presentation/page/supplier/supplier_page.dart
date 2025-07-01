import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/app_color.dart';
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
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            "http://10.0.2.2/inventory_course/api_inventory_course/supplier/get.php"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          List<Supplier> loadedSuppliers =
              (data['data'] as List).map((e) => Supplier.fromJson(e)).toList();

          setState(() {
            suppliers = loadedSuppliers;
          });
        }
      }
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteSupplier(String id) async {
    final confirm = await DInfo.dialogConfirmation(
      context,
      'Hapus Supplier',
      'Yakin ingin menghapus supplier ini?',
    );

    if (!confirm) return;

    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/inventory_course/api_inventory_course/supplier/delete.php"),
        body: {'id_supplier': id},
      );

      final data = json.decode(response.body);
      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil dihapus')),
        );
        await fetchAndSetSuppliers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal menghapus')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : suppliers.isEmpty
              ? const Center(child: Text("Belum ada data supplier."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: suppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = suppliers[index];
                    return Card(
                      color: colorScheme.surface,
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
                              supplier.namaSupplier ?? '-',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            supplierInfoRow(
                              Icons.shopping_bag,
                              Colors.orangeAccent,
                              'Produk: ${supplier.namaProduk ?? '-'}',
                              colorScheme,
                            ),
                            supplierInfoRow(
                              Icons.phone,
                              Colors.greenAccent,
                              'No. Telepon: ${supplier.noTelp ?? '-'}',
                              colorScheme,
                            ),
                            supplierInfoRow(
                              Icons.confirmation_number,
                              Colors.amberAccent,
                              'Jumlah Produk: ${supplier.jumlahProduk ?? '-'}',
                              colorScheme,
                            ),
                            supplierInfoRow(
                              Icons.sell,
                              Colors.lightBlueAccent,
                              'Produk Terjual: ${supplier.produkTerjual ?? '-'}',
                              colorScheme,
                            ),
                            supplierInfoRow(
                              Icons.inventory_2,
                              Colors.purpleAccent,
                              'Sisa Produk: ${supplier.sisaProduk ?? '-'}',
                              colorScheme,
                            ),
                            supplierInfoRow(
                              Icons.calendar_today,
                              Colors.cyan,
                              'Tanggal: ${supplier.createdAt ?? '-'}',
                              colorScheme,
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.amber),
                                  onPressed: () async {
                                    final result = await Get.to(() =>
                                        AddSupplierPage(supplier: supplier));
                                    if (result == true) {
                                      await fetchAndSetSuppliers();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    deleteSupplier(
                                        supplier.idSupplier?.toString() ?? '');
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to(() => const AddSupplierPage());
          if (result == true) {
            await fetchAndSetSuppliers();
          }
        },
        backgroundColor: AppColor.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget supplierInfoRow(
    IconData icon,
    Color iconColor,
    String text,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
