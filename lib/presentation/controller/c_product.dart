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
  setList() async {
    loading = true;
    _list.value = await SourceProduct.gets();
    Future.delayed(const Duration(seconds: 1), () {
      loading = false;
    });
  }

  @override
  void onInit() {
    setList();
    super.onInit();
  }
}
