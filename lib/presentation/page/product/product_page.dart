import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_course/config/app_format.dart';
import '../../../data/model/product.dart';
import '../../controller/c_product.dart';
import '../../controller/c_user.dart';
import 'add_update_product_page.dart';
import '../../../data/source/source_product.dart';
import '../../../services/kategori_service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  final cProduct = Get.put(CProduct());
  final cUser = Get.put(CUser());

  List<String> kategoriList = ['Semua'];
  late TabController tabController;
  bool isKategoriReady = false;

  deleteProduct(String code) async {
    bool yes = await DInfo.dialogConfirmation(
        context, 'Delete Product', 'You sure to delete product?');
    if (yes) {
      bool success = await SourceProduct.delete(code);
      if (success) {
        DInfo.dialogSuccess('Success Delete Product');
        DInfo.closeDialog(actionAfterClose: () {
          cProduct.setList();
        });
      } else {
        DInfo.dialogError('Failed Delete Product');
        DInfo.closeDialog();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchKategori().then((data) {
      kategoriList.addAll(data.map((e) => e.name!).toList());
      tabController = TabController(length: kategoriList.length, vsync: this);
      isKategoriReady = true;

      tabController.addListener(() {
        if (tabController.indexIsChanging) return;
        String selected = kategoriList[tabController.index];
        cProduct.selectedKategori = selected == 'Semua' ? '' : selected;
        cProduct.setList();
      });

      cProduct.setList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    TextTheme textTheme = Theme.of(context).textTheme;

    if (!isKategoriReady) return DView.loadingCircle();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        titleSpacing: 0,
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: kategoriList.map((e) => Tab(text: e)).toList(),
        ),
        actions: [
          if (cUser.data.level == 'Admin')
            IconButton(
              onPressed: () {
                Get.to(() => const AddUpdateProductPage())!.then((value) {
                  if (value ?? false) {
                    cProduct.setList();
                  }
                });
              },
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: Obx(() {
        if (cProduct.loading) return DView.loadingCircle();
        if (cProduct.list.isEmpty) return DView.empty();
        return ListView.separated(
          itemCount: cProduct.list.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: isDark ? Colors.white60 : Colors.black26,
            indent: 16,
            endIndent: 16,
          ),
          itemBuilder: (context, index) {
            Product product = cProduct.list[index];
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                index == 0 ? 16 : 8,
                0,
                index == cProduct.list.length - 1 ? 16 : 0,
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
                        DView.spaceHeight(4),
                        Text(
                          product.kategori ?? '-',
                          style: textTheme.bodySmall!.copyWith(
                            color: isDark
                                ? Colors.amber.shade200
                                : Colors.orange.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        DView.spaceHeight(16),
                        Text(
                          'Rp ${AppFormat.currency(product.price ?? '0')}',
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
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                      PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'update') {
                            Get.to(() =>
                                    AddUpdateProductPage(product: product))!
                                .then((value) {
                              if (value ?? false) cProduct.setList();
                            });
                          } else if (value == 'delete') {
                            deleteProduct(product.code!);
                          }
                        },
                        icon: const Icon(Icons.more_horiz),
                        itemBuilder: (context) {
                          final List<PopupMenuEntry<String>> items = [
                            const PopupMenuItem(
                              value: 'update',
                              child: Text('Update'),
                            ),
                          ];
                          if (cUser.data.level == 'Admin') {
                            items.add(
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            );
                          }
                          return items;
                        },
                      ),
                      DView.spaceHeight(4),
                      if (product.createdAt != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            AppFormat.dateTime(product.createdAt!),
                            style: textTheme.bodySmall!.copyWith(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
