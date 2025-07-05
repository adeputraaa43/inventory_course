import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_course/presentation/page/employee/add_employee_page.dart';

import '../../../data/model/user.dart';
import '../../../data/source/source_user.dart';
import '../../controller/c_employee.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final cEmployee = Get.put(CEmployee());

  delete(String idUser) async {
    bool yes = await DInfo.dialogConfirmation(
        context, 'Delete Employee', 'Yes to confirm');
    if (yes) {
      bool success = await SourceUser.delete(idUser);
      if (success) {
        DInfo.dialogSuccess('Success Delete Employee');
        DInfo.closeDialog(
          actionAfterClose: () => cEmployee.setList(),
        );
      } else {
        DInfo.dialogError('Failed Delete Employee');
        DInfo.closeDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Employee'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const AddEmployeePage())?.then((value) {
                if (value ?? false) {
                  cEmployee.setList();
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: GetBuilder<CEmployee>(builder: (_) {
        if (cEmployee.loading) return DView.loadingCircle();
        if (cEmployee.list.isEmpty) return DView.empty();
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: cEmployee.list.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            User user = cEmployee.list[index];
            return Card(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[100]
                  : Theme.of(context).cardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    user.name ?? '',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: Text(
                    user.email ?? '',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        delete(user.idUser.toString());
                      }
                    },
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
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
