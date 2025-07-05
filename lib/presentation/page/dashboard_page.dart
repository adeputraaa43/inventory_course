import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_course/presentation/page/employee/employee_page.dart';
import '../../config/app_color.dart';
import '../../config/session.dart';
import '../controller/c_dashboard.dart';
import '../controller/c_supplier.dart';
import '../controller/theme_controller.dart';
import '../controller/c_user.dart';
import 'history/history_page.dart';
import 'inout/inout_page.dart';
import 'login_page.dart';
import 'product/product_page.dart';
import 'supplier/supplier_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final cUser = Get.put(CUser());
  final cDashboard = Get.put(CDashboard());
  final cSupplier = Get.put(CSupplier());
  final themeController = Get.find<ThemeController>();

  logout() async {
    bool yes = await DInfo.dialogConfirmation(
      context,
      'Keluar',
      'Apakah Kamu Yakin ingin Keluar?',
    );
    if (yes) {
      Session.clearUser();
      Get.off(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dasbor'),
        actions: [
          Obx(() => IconButton(
                onPressed: () => themeController.toggleTheme(),
                icon: Icon(
                  themeController.isDark.value
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              )),
          IconButton(
            onPressed: () => logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        children: [
          profileCard(textTheme, colorScheme),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DView.textTitle('Menu'),
          ),
          GridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 130,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            children: [
              menuProduct(textTheme, colorScheme, isDark),
              menuHistory(textTheme, colorScheme, isDark),
              menuIn(textTheme, colorScheme, isDark),
              menuOut(textTheme, colorScheme, isDark),
              Obx(() {
                if (cUser.data.level == 'Admin') {
                  return menuEmployee(textTheme, colorScheme, isDark);
                } else {
                  return const SizedBox();
                }
              }),
              Obx(() {
                if (cUser.data.level == 'Admin') {
                  return menuSupplier(textTheme, colorScheme, isDark);
                } else {
                  return const SizedBox();
                }
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget menuProduct(
      TextTheme textTheme, ColorScheme colorScheme, bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ProductPage())
            ?.then((value) => cDashboard.setProduct());
      },
      child: menuCard(
        icon: Icons.shopping_bag,
        iconColor: Colors.blue,
        title: 'Produk',
        value: Obx(() => Text(
              cDashboard.product.toString(),
              style:
                  textTheme.headline4?.copyWith(color: colorScheme.onSurface),
            )),
        suffix: Text(
          'Item',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 18,
          ),
        ),
        textTheme: textTheme,
        isDark: isDark,
      ),
    );
  }

  Widget menuHistory(
      TextTheme textTheme, ColorScheme colorScheme, bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const HistoryPage())
            ?.then((value) => cDashboard.setHistory());
      },
      child: menuCard(
        icon: Icons.history,
        iconColor: Colors.orange,
        title: 'Riwayat',
        value: Obx(() => Text(
              cDashboard.history.toString(),
              style:
                  textTheme.headline4?.copyWith(color: colorScheme.onSurface),
            )),
        suffix: Text(
          'Item',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 18,
          ),
        ),
        textTheme: textTheme,
        isDark: isDark,
      ),
    );
  }

  Widget menuIn(TextTheme textTheme, ColorScheme colorScheme, bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const InOutPage(type: 'IN'))?.then((value) {
          cDashboard.setIn();
          cDashboard.setHistory();
        });
      },
      child: menuCard(
        icon: Icons.arrow_downward,
        iconColor: Colors.green,
        title: 'Masuk',
        value: Obx(() => Text(
              cDashboard.ins.toString(),
              style:
                  textTheme.headline4?.copyWith(color: colorScheme.onSurface),
            )),
        suffix: Text(
          'Item',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 18,
          ),
        ),
        textTheme: textTheme,
        isDark: isDark,
      ),
    );
  }

  Widget menuOut(TextTheme textTheme, ColorScheme colorScheme, bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const InOutPage(type: 'OUT'))?.then((value) {
          cDashboard.setOut();
          cDashboard.setHistory();
        });
      },
      child: menuCard(
        icon: Icons.arrow_upward,
        iconColor: Colors.red,
        title: 'Keluar',
        value: Obx(() => Text(
              cDashboard.outs.toString(),
              style:
                  textTheme.headline4?.copyWith(color: colorScheme.onSurface),
            )),
        suffix: Text(
          'Item',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 18,
          ),
        ),
        textTheme: textTheme,
        isDark: isDark,
      ),
    );
  }

  Widget menuEmployee(
      TextTheme textTheme, ColorScheme colorScheme, bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const EmployeePage())?.then((value) {
          cDashboard.setEmployee();
        });
      },
      child: menuCard(
        icon: Icons.people,
        iconColor: Colors.teal,
        title: 'Karyawan',
        value: Obx(() => Text(
              cDashboard.employee.toString(),
              style:
                  textTheme.headline4?.copyWith(color: colorScheme.onSurface),
            )),
        suffix: Text(
          'Item',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 18,
          ),
        ),
        textTheme: textTheme,
        isDark: isDark,
      ),
    );
  }

  Widget menuSupplier(
      TextTheme textTheme, ColorScheme colorScheme, bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const SupplierPage())?.then((value) {
          cSupplier.setList();
        });
      },
      child: menuCard(
        icon: Icons.local_shipping,
        iconColor: Colors.indigo,
        title: 'Supplier',
        value: Obx(() => Text(
              cSupplier.list.length.toString(),
              style:
                  textTheme.headline4?.copyWith(color: colorScheme.onSurface),
            )),
        suffix: Text(
          'Item',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 18,
          ),
        ),
        textTheme: textTheme,
        isDark: isDark,
      ),
    );
  }

  Widget menuCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget value,
    Widget? suffix,
    required TextTheme textTheme,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 32,
            color: iconColor,
          ),
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Row(
            children: [
              value,
              if (suffix != null) ...[
                DView.spaceWidth(8),
                suffix,
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget profileCard(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(cUser.data.name ?? '',
              style: textTheme.titleMedium
                  ?.copyWith(color: colorScheme.onPrimary))),
          DView.spaceHeight(4),
          Obx(() => Text(cUser.data.email ?? '',
              style: textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onPrimary))),
          DView.spaceHeight(8),
          Obx(() => Text('(${cUser.data.level})',
              style:
                  textTheme.bodySmall?.copyWith(color: colorScheme.onPrimary))),
        ],
      ),
    );
  }
}
