import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/kategori_service.dart';
import '../../../data/model/kategori.dart';
import '../../../data/model/product.dart';
import '../../../data/source/source_product.dart';

class AddUpdateProductPage extends StatefulWidget {
  const AddUpdateProductPage({Key? key, this.product}) : super(key: key);
  final Product? product;

  @override
  State<AddUpdateProductPage> createState() => _AddUpdateProductPageState();
}

class _AddUpdateProductPageState extends State<AddUpdateProductPage> {
  final controllerCode = TextEditingController();
  final controllerName = TextEditingController();
  final controllerPrice = TextEditingController();
  final controllerStock = TextEditingController();
  final controllerUnit = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<Kategori> kategoriList = [];
  Kategori? selectedKategori;
  bool isLoadingKategori = true;

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      controllerCode.text = widget.product!.code!;
      controllerName.text = widget.product!.name!;
      controllerStock.text = widget.product!.stock.toString();
      controllerUnit.text = widget.product!.unit!;
      controllerPrice.text = widget.product!.price!;
    }

    fetchKategori().then((data) {
      kategoriList = data;
      isLoadingKategori = false;

      if (widget.product != null) {
        selectedKategori = kategoriList.firstWhere(
          (k) => k.id == widget.product!.idKategori,
          orElse: () => kategoriList.first,
        );
      }
      setState(() {});
    });
  }

  addProduct() async {
    bool yes = await DInfo.dialogConfirmation(
        context, 'Tambah Produk', 'Apakah Kamu Yakin Ingin Menambah Produk?');
    if (yes) {
      bool success = await SourceProduct.add(Product(
        code: controllerCode.text,
        name: controllerName.text,
        price: controllerPrice.text,
        stock: int.parse(controllerStock.text),
        unit: controllerUnit.text,
        idKategori: selectedKategori!.id!,
      ));
      if (success) {
        DInfo.dialogSuccess('Produk Berhasil Ditambahkan');
        DInfo.closeDialog(actionAfterClose: () {
          Get.back(result: true);
        });
      } else {
        DInfo.dialogError('Produk Gagal Ditambahkan');
        DInfo.closeDialog();
      }
    }
  }

  updateProduct() async {
    bool yes = await DInfo.dialogConfirmation(
        context, 'Ubah Produk', 'Apakah Kamu Yakin Ingin Mengubah Produk?');
    if (yes) {
      bool success = await SourceProduct.update(
        widget.product!.code!,
        Product(
          code: controllerCode.text,
          name: controllerName.text,
          price: controllerPrice.text,
          stock: int.parse(controllerStock.text),
          unit: controllerUnit.text,
          idKategori: selectedKategori!.id!,
        ),
      );
      if (success) {
        DInfo.dialogSuccess('Produk Berhasil Diubah');
        DInfo.closeDialog(actionAfterClose: () {
          Get.back(result: true);
        });
      } else {
        DInfo.dialogError('Produk Gagal Diubah');
        DInfo.closeDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft(
          widget.product == null ? 'Tambah Produk' : 'Ubah Produk'),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DInput(
              controller: controllerCode,
              hint: 'JAGS676',
              title: 'Kode',
              validator: (value) => value == '' ? "Wajib diisi" : null,
              isRequired: true,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerName,
              hint: 'Indomie',
              title: 'Nama Produk',
              validator: (value) => value == '' ? "Wajib diisi" : null,
              isRequired: true,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerPrice,
              hint: '2000000',
              title: 'Harga',
              validator: (value) => value == '' ? "Wajib diisi" : null,
              isRequired: true,
              inputType: TextInputType.number,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerStock,
              hint: '50',
              title: 'Stok',
              validator: (value) => value == '' ? "Wajib diisi" : null,
              isRequired: true,
              inputType: TextInputType.number,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerUnit,
              hint: 'pcs',
              title: 'Satuan',
              validator: (value) => value == '' ? "Wajib diisi" : null,
              isRequired: true,
            ),
            DView.spaceHeight(),
            isLoadingKategori
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<Kategori>(
                    value: selectedKategori,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    items: kategoriList.map((kategori) {
                      return DropdownMenuItem<Kategori>(
                        value: kategori,
                        child: Text(kategori.name ?? '-'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedKategori = value!;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Category must be selected' : null,
                  ),
            DView.spaceHeight(),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (widget.product == null) {
                    addProduct();
                  } else {
                    updateProduct();
                  }
                }
              },
              child: Text(
                  widget.product == null ? 'Tambah Produk' : 'Ubah Produk'),
            ),
          ],
        ),
      ),
    );
  }
}
