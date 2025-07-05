import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_format.dart';
import '../../../data/model/history.dart';
import '../../controller/c_in_out_history.dart';
import '../history/detail_history_page.dart';

class InOutHistoryPage extends StatefulWidget {
  const InOutHistoryPage({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<InOutHistoryPage> createState() => _InOutHistoryPageState();
}

class _InOutHistoryPageState extends State<InOutHistoryPage> {
  final cInOutHistory = Get.put(CInOutHistory());
  final controllerSearch = TextEditingController();

  @override
  void initState() {
    cInOutHistory.getList(widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String title =
        widget.type == 'IN' ? 'Riwayat Barang Masuk' : 'Riwayat Barang Keluar';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Text(title),
            search(),
          ],
        ),
      ),
      body: GetBuilder<CInOutHistory>(builder: (_) {
        if (cInOutHistory.list.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada data',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...List.generate(cInOutHistory.list.length, (index) {
              History history = cInOutHistory.list[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  color: Theme.of(context).cardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isDark
                          ? Colors.white12
                          : Colors.grey.shade300, // terlihat di light mode
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Get.to(() => DetailHistoryPage(
                          idHistory: '${history.idHistory}'))?.then((value) {
                        if (value ?? false) {
                          cInOutHistory.refreshData(widget.type);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            widget.type == 'IN'
                                ? Icons.south_west
                                : Icons.north_east,
                            color:
                                widget.type == 'IN' ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppFormat.date(history.createdAt!),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp ${AppFormat.currency(history.totalPrice ?? '0')}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (cInOutHistory.hasNext)
              cInOutHistory.fetchData
                  ? DView.loadingCircle()
                  : Center(
                      child: IconButton(
                        onPressed: () => cInOutHistory.getList(widget.type),
                        icon: const Icon(Icons.refresh),
                      ),
                    ),
          ],
        );
      }),
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
            fillColor: Theme.of(context).cardColor,
            hintText: 'Cari tanggal...',
            hintStyle: TextStyle(color: Theme.of(context).hintColor),
            suffixIcon: IconButton(
              onPressed: () {
                if (controllerSearch.text != '') {
                  cInOutHistory.search(controllerSearch.text, widget.type);
                }
              },
              icon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}
