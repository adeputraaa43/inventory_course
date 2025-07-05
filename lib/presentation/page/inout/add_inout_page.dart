import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_color.dart';
import '../../../data/source/source_inout.dart';
import 'pick_product_page.dart';

import '../../../data/model/product.dart';
import '../../controller/c_add_inout.dart';

class AddInOutPage extends StatefulWidget {
  const AddInOutPage({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<AddInOutPage> createState() => _AddInOutPageState();
}

class _AddInOutPageState extends State<AddInOutPage> {
  final cAddInOut = Get.put(CAddInOut());

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title:
            Text('Tambah Barang ${widget.type == 'IN' ? 'Masuk' : 'Keluar'}'),
        actions: [
          IconButton(
            onPressed: () async {
              bool yes = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Konfirmasi Tambah'),
                    content: const Text('Klik Iya untuk menambahkan'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Tidak'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Iya'),
                      ),
                    ],
                  );
                },
              );
              if (yes) {
                cAddInOut.addInOut(widget.type);
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => PickProductPage(type: widget.type))?.then((value) {
                  if (value != null) {
                    cAddInOut.add(value);
                  }
                });
              },
              child: const Text('Pilih Produk'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: DView.textTitle('Daftar Produk'),
          ),
          const Divider(indent: 16, endIndent: 16),
          GetBuilder<CAddInOut>(builder: (_) {
            if (cAddInOut.list.isEmpty) {
              return const Center(
                child: Text(
                  'Tidak ada data',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cAddInOut.list.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  color: Colors.white60,
                  indent: 16,
                  endIndent: 16,
                );
              },
              itemBuilder: (context, index) {
                Map product = cAddInOut.list[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    0,
                    index == 9 ? 16 : 0,
                  ),
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
                              product['name'],
                              style: textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DView.spaceHeight(4),
                            Text(
                              product['code'],
                              style: textTheme.subtitle2!.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            DView.spaceHeight(16),
                            Text(
                              product['price'],
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
                              product['quantity'],
                              style: textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          DView.spaceHeight(4),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Text(
                              product['unit'],
                              style: textTheme.subtitle2!.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          PopupMenuButton(
                            onSelected: (value) {
                              if (value == 'delete') {
                                cAddInOut.delete(product);
                              }
                            },
                            icon: const Icon(Icons.more_horiz),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Hapus'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
          DView.spaceHeight(30),
          Center(
            child: Text(
              'Total:',
              style: textTheme.headline5,
            ),
          ),
          Center(
            child: Obx(() {
              return Text(
                'Rp ${cAddInOut.totalPrice.toStringAsFixed(2)}',
                style: textTheme.headline3!.copyWith(
                  color: Colors.green,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
