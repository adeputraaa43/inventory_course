import 'package:get/get.dart';
import 'package:inventory_course/data/source/source_supplier.dart';
import '../../data/model/supplier.dart';

class CSupplier extends GetxController {
  final RxBool _loading = false.obs;
  bool get loading => _loading.value;
  set loading(bool newData) {
    _loading.value = newData;
  }

  final RxList<Supplier> _list = <Supplier>[].obs;
  List<Supplier> get list => _list.value;

  setList() async {
    loading = true;
    _list.value = await SourceSupplier.gets();
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
