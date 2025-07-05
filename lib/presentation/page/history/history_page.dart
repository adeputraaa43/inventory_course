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
        title: const Text('Pilih Tanggal Yang Ingin Dihapus'),
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
              child: const Text('Pilih Tanggal'),
            ),
            DView.spaceHeight(8),
            TextField(
              controller: controller,
              enabled: false,
              decoration: const InputDecoration(hintText: 'Masukkan Tanggal'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (controller.text == '') {
                DInfo.toastError('Tanggal tidak boleh kosong');
              } else {
                Get.back(result: true);
              }
            },
            child: const Text('Hapus'),
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
    bool yes = await DInfo.dialogConfirmation(context, 'Hapus Riwayat',
        'Apakah kamu ingin menghapus seluruh riwayat dari tanggal yang dipilih?');
    if (yes) {
      bool success = await SourceHistory.deleteAllBeforeDate(date);
      if (success) {
        DInfo.dialogSuccess(
            'Berhasil Hapus Seluruh Riwayat Dari Tanggal Yang Dipilih');
        DInfo.closeDialog(actionAfterClose: () {
          cHistory.refreshList();
        });
      } else {
        DInfo.dialogError('Gagal Hapus Seluruh Riwayat');
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
            const Text('Riwayat'),
            search(),
          ],
        ),
      ),
      floatingActionButton: cuser.data.level == 'Admin'
          ? FloatingActionButton(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              onPressed: showInputDate,
              child: const Icon(Icons.delete),
            )
          : null,
      body: GetBuilder<CHistory>(builder: (_) {
        if (cHistory.list.isEmpty) return DView.empty();
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return ListView(
          children: [
            buildRekapBulanan(),
            Builder(builder: (context) {
              double totalMasukKeluar = 0;
              for (var h in cHistory.list) {
                double total = double.tryParse(h.totalPrice ?? '0') ?? 0;
                totalMasukKeluar += total;
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[100]
                      : colorScheme.surfaceVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.swap_vert, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          'Total Barang Masuk & Keluar:',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Rp ${AppFormat.currency(totalMasukKeluar.toString())}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            ...List.generate(cHistory.list.length, (index) {
              History history = cHistory.list[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[100]
                      : colorScheme.surfaceVariant,
                  child: ListTile(
                    onTap: () {
                      Get.to(() => DetailHistoryPage(
                          idHistory: '${history.idHistory}'))?.then((value) {
                        if (value ?? false) {
                          cHistory.refreshList();
                        }
                      });
                    },
                    leading: Icon(
                      history.type == 'IN'
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: history.type == 'IN' ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      AppFormat.date(history.createdAt!),
                      style: textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      history.type == 'IN' ? 'Barang Masuk' : 'Barang Keluar',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Text(
                      'Rp ${AppFormat.currency(history.totalPrice ?? '0')}',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            fillColor: isDark ? AppColor.input : Colors.white,
            hintText: 'Cari Tanggal...',
            hintStyle: TextStyle(
              color: isDark ? Colors.white70 : Colors.black45,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                if (controllerSearch.text != '') {
                  cHistory.search(controllerSearch.text);
                }
              },
              icon: Icon(
                Icons.search,
                color: isDark ? Colors.white : Colors.black54,
              ),
            ),
          ),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
