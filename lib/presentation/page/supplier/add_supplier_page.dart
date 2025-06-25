import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_color.dart';
import '../../../data/model/supplier.dart';
import 'add_supplier_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddSupplierPage extends StatefulWidget {
  final Supplier? supplier;
  const AddSupplierPage({this.supplier, Key? key}) : super(key: key);

  @override
  State<AddSupplierPage> createState() => _AddSupplierPageState();
}

class _AddSupplierPageState extends State<AddSupplierPage> {
  final controllerName = TextEditingController();
  final controllerProduct = TextEditingController();
  final controllerTelp = TextEditingController();
  final controllerJumlah = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      controllerName.text = widget.supplier!.namaSupplier ?? '';
      controllerProduct.text = widget.supplier!.namaProduk ?? '';
      controllerTelp.text = widget.supplier!.noTelp ?? '';
      controllerJumlah.text = widget.supplier!.jumlahProduk ?? '';
    }
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerProduct.dispose();
    controllerTelp.dispose();
    controllerJumlah.dispose();
    super.dispose();
  }

  void saveSupplier() {
    String name = controllerName.text.trim();
    String product = controllerProduct.text.trim();
    String telp = controllerTelp.text.trim();
    String jumlah = controllerJumlah.text.trim();

    if (name.isEmpty || product.isEmpty || telp.isEmpty || jumlah.isEmpty) {
      Get.snackbar('Error', 'Semua field wajib diisi');
      return;
    }

    String url = widget.supplier == null
        ? "http://10.0.2.2/inventory_course/api_inventory_course/supplier/add.php"
        : "http://10.0.2.2/inventory_course/api_inventory_course/supplier/update.php";

    Map<String, String> body = {
      "nama_supplier": name,
      "nama_produk": product,
      "no_telp": telp,
      "jumlah_produk": jumlah,
    };

    // tambahkan id jika edit
    if (widget.supplier != null) {
      body["id_supplier"] = widget.supplier!.idSupplier?.toString() ?? '';
    }

    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: widget.supplier == null
          ? "Yakin ingin menambahkan supplier?"
          : "Yakin ingin mengupdate supplier?",
      textCancel: "Tidak",
      textConfirm: "Ya",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Navigator.of(context).pop();

        try {
          final response = await http.post(Uri.parse(url), body: body);

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['success'] == true) {
              Get.snackbar(
                  'Berhasil',
                  widget.supplier == null
                      ? 'Data supplier ditambahkan'
                      : 'Data supplier diperbarui');
              await Future.delayed(Duration(milliseconds: 500));
              Get.back(result: true);
            } else {
              Get.snackbar('Gagal', data['message'] ?? 'Gagal memproses');
            }
          } else {
            Get.snackbar('Error', 'Server error: ${response.statusCode}');
          }
        } catch (e) {
          Get.snackbar('Exception', 'Terjadi kesalahan: $e');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.supplier == null ? 'Tambah Supplier' : 'Edit Supplier'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: controllerName,
            decoration: const InputDecoration(
              labelText: 'Nama Supplier',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controllerProduct,
            decoration: const InputDecoration(
              labelText: 'Produk Supplier',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controllerTelp,
            decoration: const InputDecoration(
              labelText: 'No. Telepon',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controllerJumlah,
            decoration: const InputDecoration(
              labelText: 'Jumlah Produk',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: saveSupplier,
            style: ElevatedButton.styleFrom(
              primary: AppColor.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
