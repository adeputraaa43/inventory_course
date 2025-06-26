import 'package:get/get.dart';
import '../../data/model/product.dart';
import '../../data/source/source_product.dart';

class CProduct extends GetxController {
  final RxBool _loading = false.obs;
  bool get loading => _loading.value;
  set loading(bool newData) {
    _loading.value = newData;
  }

  final RxList<Product> _list = <Product>[].obs;
  List<Product> get list => _list.value;

  final RxString _selectedKategori = ''.obs;
  String get selectedKategori => _selectedKategori.value;
  set selectedKategori(String newData) {
    _selectedKategori.value = newData;
  }

  setList() async {
    loading = true;
    List<Product> result = await SourceProduct.gets();

    if (selectedKategori != '') {
      result = result
          .where((e) =>
              (e.kategori ?? '').toLowerCase() ==
              selectedKategori.toLowerCase())
          .toList();
    }

    _list.value = result;
    loading = false;
  }

  @override
  void onInit() {
    setList();
    super.onInit();
  }
}
