import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_course/data/source/source_user.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({Key? key}) : super(key: key);

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  add() async {
    if (formKey.currentState!.validate()) {
      bool yes = await DInfo.dialogConfirmation(
        context,
        'Tambah Karyawan',
        'Pilih Iya untuk konfirmasi',
        textNo: 'Tidak',
        textYes: 'Iya',
      );
      if (yes) {
        bool success = await SourceUser.add(
          controllerName.text,
          controllerEmail.text,
          controllerPassword.text,
        );
        if (success) {
          DInfo.dialogSuccess('Berhasil Menambahkan Karyawan');
          DInfo.closeDialog(
            actionAfterClose: () => Get.back(result: true),
          );
        } else {
          DInfo.dialogError('Gagal Menambahkan Karyawan');
          DInfo.closeDialog();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft('Tambah Karyawan'),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DInput(
              title: 'Nama',
              controller: controllerName,
              validator: (value) => value == '' ? 'Jangan kosong' : null,
            ),
            DView.spaceHeight(),
            DInput(
              title: 'Email',
              controller: controllerEmail,
              validator: (value) => value == '' ? 'Jangan kosong' : null,
            ),
            DView.spaceHeight(),
            DInput(
              title: 'Kata Sandi',
              controller: controllerPassword,
              validator: (value) => value == '' ? 'Jangan kosong' : null,
            ),
            DView.spaceHeight(),
            ElevatedButton(
              onPressed: () => add(),
              child: const Text('Tambah Karyawan'),
            ),
          ],
        ),
      ),
    );
  }
}
