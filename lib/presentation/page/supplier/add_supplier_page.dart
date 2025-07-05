import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_color.dart';
import '../../../config/app_format.dart';
import '../../../data/model/supplier.dart';
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
  final controllerHarga = TextEditingController();
  final controllerTerjual = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      controllerName.text = widget.supplier!.namaSupplier ?? '';
      controllerProduct.text = widget.supplier!.namaProduk ?? '';
      controllerTelp.text = widget.supplier!.noTelp ?? '';
      controllerJumlah.text = widget.supplier!.jumlahProduk ?? '';
      controllerHarga.text = widget.supplier!.harga?.toString() ?? '';
      controllerTerjual.text = widget.supplier!.produkTerjual ?? '';
    }
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerProduct.dispose();
    controllerTelp.dispose();
    controllerJumlah.dispose();
    controllerHarga.dispose();
    controllerTerjual.dispose();
    super.dispose();
  }

  Future<void> saveSupplier() async {
    String name = controllerName.text.trim();
    String product = controllerProduct.text.trim();
    String telp = controllerTelp.text.trim();
    String jumlah = controllerJumlah.text.trim();
    String harga = controllerHarga.text.trim();
    String terjual = controllerTerjual.text.trim();

    if (name.isEmpty ||
        product.isEmpty ||
        telp.isEmpty ||
        jumlah.isEmpty ||
        harga.isEmpty) {
      Get.snackbar('Error', 'Semua field wajib diisi');
      return;
    }

    int jumlahInt = int.tryParse(jumlah) ?? 0;
    double hargaD = double.tryParse(harga) ?? 0.0;
    int terjualInt = int.tryParse(terjual) ?? 0;

    if (widget.supplier != null) {
      if (terjual.isEmpty) {
        Get.snackbar('Error', 'Produk terjual wajib diisi');
        return;
      }
      if (terjualInt > jumlahInt) {
        await Get.dialog(
          AlertDialog(
            title: const Text('Gagal'),
            content: const Text(
                'Produk terjual tidak boleh lebih dari jumlah produk.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
        return;
      }
    }
    String url = widget.supplier == null
        ? "http://10.0.2.2/inventory_course/api_inventory_course/supplier/add.php"
        : "http://10.0.2.2/inventory_course/api_inventory_course/supplier/update.php";

    Map<String, String> body = {
      "nama_supplier": name,
      "nama_produk": product,
      "no_telp": telp,
      "jumlah_produk": jumlah,
      "harga": harga,
    };
    if (widget.supplier != null) {
      body["id_supplier"] = widget.supplier!.idSupplier.toString();
      body["produk_terjual"] = terjual;
    }

    final yes = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Konfirmasi"),
        content: Text(widget.supplier == null
            ? "Yakin ingin menambahkan supplier?"
            : "Yakin ingin mengupdate supplier?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Ya"),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (yes != true) return;

    try {
      final response = await http.post(Uri.parse(url), body: body);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        await Get.dialog(
          AlertDialog(
            title: Text(
                widget.supplier == null ? 'Berhasil' : 'Berhasil Diperbarui'),
            content: Text(widget.supplier == null
                ? 'Supplier berhasil ditambahkan.'
                : 'Supplier berhasil diperbarui.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // close dialog
                  Get.back(result: true); // return to previous page
                },
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Gagal memproses');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int j = int.tryParse(controllerJumlah.text) ?? 0;
    int t = int.tryParse(controllerTerjual.text) ?? 0;
    double h = double.tryParse(controllerHarga.text) ?? 0.0;
    double bayar = t * h;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.supplier == null ? 'Tambah Supplier' : 'Ubah Supplier'),
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
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controllerHarga,
            decoration: const InputDecoration(
              labelText: 'Harga per Unit',
              border: OutlineInputBorder(),
              prefixText: 'Rp ',
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          if (widget.supplier != null) ...[
            TextField(
              controller: controllerTerjual,
              decoration: const InputDecoration(
                labelText: 'Produk Terjual',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
          ],
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
