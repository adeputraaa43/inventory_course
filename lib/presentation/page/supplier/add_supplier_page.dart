import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../config/app_color.dart';
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

    List<String> errors = [];

    if (name.isEmpty) errors.add('Nama Supplier wajib diisi.');
    if (product.isEmpty) errors.add('Produk Supplier wajib diisi.');
    if (telp.isEmpty) {
      errors.add('No. Telepon wajib diisi.');
    } else if (!RegExp(r'^\d+$').hasMatch(telp)) {
      errors.add('No. Telepon harus angka.');
    }

    if (jumlah.isEmpty) {
      errors.add('Jumlah Produk wajib diisi.');
    } else if (!RegExp(r'^\d+$').hasMatch(jumlah)) {
      errors.add('Jumlah Produk harus angka.');
    }

    if (harga.isEmpty) {
      errors.add('Harga per Unit wajib diisi.');
    } else if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(harga)) {
      errors.add('Harga per Unit harus angka.');
    }

    if (widget.supplier != null) {
      if (terjual.isEmpty) {
        errors.add('Produk Terjual wajib diisi.');
      } else if (!RegExp(r'^\d+$').hasMatch(terjual)) {
        errors.add('Produk Terjual harus angka.');
      } else {
        int jumlahInt = int.tryParse(jumlah) ?? 0;
        int terjualInt = int.tryParse(terjual) ?? 0;
        if (terjualInt > jumlahInt) {
          errors.add('Produk Terjual tidak boleh lebih dari Jumlah Produk.');
        }
      }
    }

    if (errors.isNotEmpty) {
      Get.defaultDialog(
        title: 'Validasi Gagal',
        titleStyle: const TextStyle(
            color: Color(0xFF6200EE),
            fontWeight: FontWeight.bold,
            fontSize: 18),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors.map((e) => Text("• $e")).toList(),
        ),
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        buttonColor: Color(0xFF6200EE),
        onConfirm: () => Get.back(),
      );
      return;
    }

    String url = widget.supplier == null
        ? "https://inventoryku.shop/api_inventory_course/supplier/add.php"
        : "https://inventoryku.shop/api_inventory_course/supplier/update.php";

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
              child: const Text("Tidak")),
          TextButton(
              onPressed: () => Get.back(result: true), child: const Text("Ya")),
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
                  Get.back();
                  Get.back(result: true);
                },
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        Get.defaultDialog(
          title: 'Gagal',
          content: Text(data['message'] ?? 'Gagal memproses'),
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          buttonColor: Color(0xFF6200EE),
          onConfirm: () => Get.back(),
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Error',
        content: Text('Terjadi kesalahan: $e'),
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        buttonColor: Color(0xFF6200EE),
        onConfirm: () => Get.back(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controllerHarga,
            decoration: const InputDecoration(
              labelText: 'Harga per Unit',
              border: OutlineInputBorder(),
              prefixText: 'Rp ',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
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
            ),
            const SizedBox(height: 16),
          ],
          ElevatedButton(
            onPressed: saveSupplier,
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF6200EE),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
