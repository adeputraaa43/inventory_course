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
        context, 'Add Product', 'You sure to add new product?');
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
        DInfo.dialogSuccess('Success Add New Product');
        DInfo.closeDialog(actionAfterClose: () {
          Get.back(result: true);
        });
      } else {
        DInfo.dialogError('Failed Add New Product');
        DInfo.closeDialog();
      }
    }
  }

  updateProduct() async {
    bool yes = await DInfo.dialogConfirmation(
        context, 'Update Product', 'You sure to update product?');
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
        DInfo.dialogSuccess('Success Update Product');
        DInfo.closeDialog(actionAfterClose: () {
          Get.back(result: true);
        });
      } else {
        DInfo.dialogError('Failed Update Product');
        DInfo.closeDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft(
          widget.product == null ? 'Add Product' : 'Update Product'),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DInput(
              controller: controllerCode,
              hint: 'JAGS676',
              title: 'Code',
              validator: (value) => value == '' ? "Don't Empty" : null,
              isRequired: true,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerName,
              hint: 'Your Name',
              title: 'Name',
              validator: (value) => value == '' ? "Don't Empty" : null,
              isRequired: true,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerPrice,
              hint: '2000000',
              title: 'Price',
              validator: (value) => value == '' ? "Don't Empty" : null,
              isRequired: true,
              inputType: TextInputType.number,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerStock,
              hint: '50',
              title: 'Stock',
              validator: (value) => value == '' ? "Don't Empty" : null,
              isRequired: true,
              inputType: TextInputType.number,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerUnit,
              hint: 'Item',
              title: 'Unit',
              validator: (value) => value == '' ? "Don't Empty" : null,
              isRequired: true,
            ),
            DView.spaceHeight(),
            isLoadingKategori
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<Kategori>(
                    value: selectedKategori,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Category',
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
                  widget.product == null ? 'Add Product' : 'Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
