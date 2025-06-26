import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventory_course/presentation/controller/c_user.dart';
import '../../../config/app_color.dart';

import '../../../config/app_format.dart';
import '../../../data/model/history.dart';
import '../../../data/model/history_rekap.dart';
import '../../../data/source/source_history.dart';
import '../../controller/c_history.dart';
import 'detail_history_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final cHistory = Get.put(CHistory());
  final cuser = Get.put(CUser());
  final controllerSearch = TextEditingController();

  showInputDate() async {
    final controller = TextEditingController();
    bool? dateExist = await Get.dialog(
      AlertDialog(
        title: const Text('Pick Date Before Delete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                DateTime? result = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (result != null) {
                  controller.text = result.toIso8601String();
                }
              },
              child: const Text('Pick Date'),
            ),
            DView.spaceHeight(8),
            TextField(
              controller: controller,
              enabled: false,
              decoration: const InputDecoration(hintText: 'Date'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text == '') {
                DInfo.toastError('Input cannot be null');
              } else {
                Get.back(result: true);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    if (dateExist ?? false) {
      delete(controller.text);
    }
  }

  delete(String date) async {
    bool yes = await DInfo.dialogConfirmation(
        context, 'Delete History', 'You sure to delete history?');
    if (yes) {
      bool success = await SourceHistory.deleteAllBeforeDate(date);
      if (success) {
        DInfo.dialogSuccess('Success Delete History Before Date');
        DInfo.closeDialog(actionAfterClose: () {
          cHistory.refreshList();
        });
      } else {
        DInfo.dialogError('Failed Delete History Before Date');
        DInfo.closeDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const Text('History'),
            search(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        onPressed: () {
          if (cuser.data.level == 'Admin') {
            showInputDate();
          } else {
            DInfo.toastError('You are have no access');
          }
        },
        child: const Icon(Icons.delete),
      ),
      body: GetBuilder<CHistory>(builder: (_) {
        if (cHistory.list.isEmpty) return DView.empty();
        return ListView(
          children: [
            buildRekapBulanan(),

            // ✅ Tambahan: Total Barang Masuk & Keluar
            Builder(builder: (context) {
              double totalMasukKeluar = 0;
              for (var h in cHistory.list) {
                double total = double.tryParse(h.totalPrice ?? '0') ?? 0;
                totalMasukKeluar += total;
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.swap_vert, color: Colors.amber),
                      const SizedBox(width: 8),
                      const Text(
                        'Total Barang Masuk & Keluar:',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        'Rp ${AppFormat.currency(totalMasukKeluar.toString())}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            ...List.generate(cHistory.list.length, (index) {
              History history = cHistory.list[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.to(() => DetailHistoryPage(
                          idHistory: '${history.idHistory}'))?.then((value) {
                        if (value ?? false) {
                          cHistory.refreshList();
                        }
                      });
                    },
                    leading: history.type == 'IN'
                        ? const Icon(Icons.south_west, color: Colors.green)
                        : const Icon(Icons.north_east, color: Colors.red),
                    horizontalTitleGap: 0,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppFormat.date(history.createdAt!),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          'Rp ${AppFormat.currency(history.totalPrice ?? '0')}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.white54,
                    indent: 16,
                    endIndent: 16,
                  ),
                ],
              );
            }),
            if (cHistory.hasNext)
              cHistory.fetchData
                  ? DView.loadingCircle()
                  : Center(
                      child: IconButton(
                        onPressed: () => cHistory.getList(),
                        icon: const Icon(Icons.refresh),
                      ),
                    ),
            DView.spaceHeight(80),
          ],
        );
      }),
    );
  }

  Widget buildRekapBulanan() {
    return GetBuilder<CHistory>(
      builder: (_) {
        if (cHistory.listRekap.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Rekap Penjualan per Bulan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...cHistory.listRekap.map((e) {
              return ListTile(
                title: Text(AppFormat.bulan(e.bulan)),
                trailing: Text('Rp ${AppFormat.currency(e.total.toString())}'),
              );
            }).toList(),
            const Divider(thickness: 1),
          ],
        );
      },
    );
  }

  Expanded search() {
    return Expanded(
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: controllerSearch,
          onTap: () async {
            DateTime? result = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(
                DateTime.now().year,
                DateTime.now().add(const Duration(days: 30)).month,
              ),
            );
            if (result != null) {
              controllerSearch.text = DateFormat('yyyy-MM-dd').format(result);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            isDense: true,
            filled: true,
            fillColor: AppColor.input,
            hintText: 'Search...',
            suffixIcon: IconButton(
              onPressed: () {
                if (controllerSearch.text != '') {
                  cHistory.search(controllerSearch.text);
                }
              },
              icon: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
