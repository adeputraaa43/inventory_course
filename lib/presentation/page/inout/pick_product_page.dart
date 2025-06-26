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
    bool yes = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Konfirmasi Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Kode: ${product.code ?? '-'}'),
                  Text('Kategori: ${product.kategori ?? '-'}'),
                  Text('Harga: Rp ${product.price ?? '-'}'),
                  Text('Stok: ${product.stock} ${product.unit ?? ''}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Jumlah Masuk/Keluar:', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            TextField(
              controller: controllerQuantity,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 50',
                filled: true,
                fillColor: Colors.grey[800],
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purpleAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text('Tekan "Yes" untuk konfirmasi'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              if (controllerQuantity.text == '') {
                DInfo.toastError("Quantity don't empty");
              } else {
                Get.back(result: true);
              }
            },
            child: const Text('Yes'),
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
          DInfo.toastError('Quantity is bigger than stock');
        } else {
          Get.back(result: data);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Product ${widget.type}'),
        titleSpacing: 0,
      ),
      body: Obx(() {
        if (cProduct.loading) return DView.loadingCircle();
        if (cProduct.list.isEmpty) return DView.empty();
        return ListView.separated(
          itemCount: cProduct.list.length,
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              color: Colors.white60,
              indent: 16,
              endIndent: 16,
            );
          },
          itemBuilder: (context, index) {
            Product product = cProduct.list[index];
            return GestureDetector(
              onTap: () {
                pick(product);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  16,
                  index == 0 ? 16 : 8,
                  0,
                  index == cProduct.list.length - 1 ? 16 : 0,
                ),
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Text('${index + 1}'),
                    ),
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
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            product.kategori ?? '',
                            style: textTheme.bodySmall!.copyWith(
                              color: Color.fromARGB(255, 191, 223, 30),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          DView.spaceHeight(12),
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
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            product.stock.toString(),
                            style: textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        DView.spaceHeight(4),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            product.unit ?? '',
                            style: textTheme.subtitle2!.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
