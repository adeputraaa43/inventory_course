import 'dart:convert';

import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/product.dart';
import '../../../data/source/source_inout.dart';
import '../../controller/c_product.dart';
import '../product/add_update_product_page.dart';
import '../../../data/source/source_product.dart';

class PickProductPage extends StatefulWidget {
  const PickProductPage({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<PickProductPage> createState() => _PickProductPageState();
}

class _PickProductPageState extends State<PickProductPage> {
  final cProduct = Get.put(CProduct());

  pick(Product product) async {
    final controllerQuantity = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    bool yes = await Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Konfirmasi Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Kode: ${product.code ?? '-'}',
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87)),
                  Text('Kategori: ${product.kategori ?? '-'}',
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87)),
                  Text('Harga: Rp ${product.price ?? '-'}',
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87)),
                  Text('Stok: ${product.stock} ${product.unit ?? ''}',
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Jumlah Masuk/Keluar:',
                style: TextStyle(
                    fontSize: 14, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 6),
            TextField(
              controller: controllerQuantity,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 50',
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purpleAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              'Tekan "Ya" untuk konfirmasi',
              style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Tidak',
                style: TextStyle(color: isDark ? Colors.pink : Colors.pink)),
          ),
          TextButton(
            onPressed: () {
              if (controllerQuantity.text == '') {
                DInfo.toastError("Jumlah tidak boleh kosong");
              } else {
                Get.back(result: true);
              }
            },
            child: Text('Ya',
                style:
                    TextStyle(color: isDark ? Colors.cyanAccent : Colors.blue)),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (yes) {
      int stock = await SourceProduct.stock(product.code!);
      Map<String, dynamic> data = {
        'code': product.code,
        'name': product.name,
        'price': product.price,
        'stock': stock,
        'unit': product.unit,
        'quantity': controllerQuantity.text,
        'category': product.kategori,
      };
      if (widget.type == 'IN') {
        Get.back(result: data);
      } else {
        if (int.parse(controllerQuantity.text) > stock) {
          DInfo.toastError('Jumlah melebihi stok tersedia');
        } else {
          Get.back(result: data);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kategoriColor =
        isDark ? Colors.lightGreenAccent.shade400 : Colors.green.shade700;

    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Produk ${widget.type == 'IN' ? 'Masuk' : 'Keluar'}'),
        titleSpacing: 0,
      ),
      body: Obx(() {
        if (cProduct.loading) return DView.loadingCircle();
        if (cProduct.list.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada data',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cProduct.list.length,
          itemBuilder: (context, index) {
            Product product = cProduct.list[index];
            return GestureDetector(
              onTap: () => pick(product),
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: isDark ? Colors.grey[900] : Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name ?? '',
                              style: textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DView.spaceHeight(4),
                            Text(
                              product.code ?? '',
                              style: textTheme.bodySmall!.copyWith(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            Text(
                              product.kategori ?? '-',
                              style: textTheme.bodySmall!.copyWith(
                                color: kategoriColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            DView.spaceHeight(8),
                            Text(
                              'Rp ${product.price ?? ''}',
                              style: textTheme.subtitle1!.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            product.stock.toString(),
                            style: textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          DView.spaceHeight(4),
                          Text(
                            product.unit ?? '',
                            style: textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
