import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:inventory_course/presentation/page/inout/inout_history_page.dart';
import '../../../config/app_color.dart';
import '../../../config/app_format.dart';
import '../../../data/model/history.dart';
import '../history/detail_history_page.dart';
import 'add_inout_page.dart';

import '../../controller/c_in_out.dart';

class InOutPage extends StatefulWidget {
  const InOutPage({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<InOutPage> createState() => _InOutPageState();
}

class _InOutPageState extends State<InOutPage> {
  final cInOut = Get.put(CInOut());
  @override
  void initState() {
    cInOut.getAnalysis(widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(widget.type),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AddInOutPage(type: widget.type))?.then((value) {
                if (value ?? false) {
                  cInOut.getAnalysis(widget.type);
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          DChartPie(
                            data: [
                              {
                                'domain': 'Yesterday',
                                'measure': cInOut.listTotal[5],
                              },
                              {
                                'domain': 'Today',
                                'measure': cInOut.listTotal[6],
                              },
                              if (cInOut.listTotal[6] == 0 &&
                                  cInOut.listTotal[5] == 0)
                                {
                                  'domain': 'Nol',
                                  'measure': 1,
                                },
                            ],
                            fillColor: (pieData, index) {
                              switch (pieData['domain']) {
                                case 'Today':
                                  return widget.type == 'IN'
                                      ? AppColor.historyIn
                                      : AppColor.historyOut;
                                case 'Yesterday':
                                  return AppColor.primary;
                                default:
                                  return Colors.white.withOpacity(0.3);
                              }
                            },
                            labelColor: Colors.transparent,
                            donutWidth: 20,
                          ),
                          Center(
                            child: Obx(() {
                              return Text(
                                '${cInOut.percentToday.toStringAsFixed(1)}%',
                                style: Theme.of(context).textTheme.headline4,
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  }),
                  DView.spaceWidth(40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DView.spaceHeight(20),
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              color: widget.type == 'IN'
                                  ? AppColor.historyIn
                                  : AppColor.historyOut,
                            ),
                            DView.spaceWidth(8),
                            Text(
                              'Today',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        DView.spaceHeight(),
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              color: AppColor.primary,
                            ),
                            DView.spaceWidth(8),
                            Text(
                              'Yesterday',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        DView.spaceHeight(30),
                        Obx(() {
                          String percent =
                              cInOut.percentDifferent.toStringAsFixed(1);
                          return Text(
                            '$percent% ${cInOut.textDifferent}\nthan yesterday\nor equal to',
                            maxLines: 5,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w300,
                                ),
                          );
                        }),
                        DView.spaceHeight(8),
                        Obx(() {
                          return Text(
                            'Rp ${AppFormat.currency(cInOut.different.toString())}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: widget.type == 'IN'
                                      ? AppColor.historyIn
                                      : AppColor.historyOut,
                                  fontWeight: FontWeight.bold,
                                ),
                          );
                        }),
                      ],
                    ),
                  ),
                  DView.spaceWidth(16),
                ],
              ),
            ),
          ),
          GetBuilder<CInOut>(builder: (_) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: DChartBar(
                data: [
                  {
                    'id': 'Bar',
                    'data': List.generate(cInOut.listTotal.length, (index) {
                      return {
                        'domain': cInOut.week()[index],
                        'measure': cInOut.listTotal[index],
                      };
                    }),
                  },
                ],
                showDomainLine: false,
                showMeasureLine: false,
                showBarValue: false,
                barColor: (barData, index, id) => widget.type == 'IN'
                    ? AppColor.historyIn
                    : AppColor.historyOut,
                measureLabelColor: Colors.white,
                domainLabelColor: Colors.white,
                axisLineColor: Colors.transparent,
              ),
            );
          }),
          DView.spaceHeight(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                DView.textTitle('History ${widget.type}', color: Colors.white),
                const Spacer(),
                DView.textAction(
                  () {
                    Get.to(() => InOutHistoryPage(type: widget.type));
                  },
                  color: AppColor.primary,
                  iconRight: Icons.navigate_next,
                  iconRightColor: AppColor.primary,
                ),
              ],
            ),
          ),
          GetBuilder<CInOut>(builder: (_) {
            if (cInOut.list.isEmpty) return DView.empty();
            return ListView.separated(
              itemCount: cInOut.list.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Colors.white54,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                History history = cInOut.list[index];
                return ListTile(
                  onTap: () {
                    Get.to(() => DetailHistoryPage(
                        idHistory: '${history.idHistory}'))?.then((value) {
                      if (value ?? false) {
                        cInOut.getAnalysis(widget.type);
                      }
                    });
                  },
                  leading: widget.type == 'IN'
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
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
