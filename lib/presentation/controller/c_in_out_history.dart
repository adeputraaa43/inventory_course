import 'package:get/get.dart';
import 'package:inventory_course/data/source/source_inout.dart';
import '../../data/model/history.dart';
import '../../data/source/source_history.dart';

class CInOutHistory extends GetxController {
  final RxBool _fetchData = false.obs;
  bool get fetchData => _fetchData.value;

  final RxBool _hasNext = true.obs;
  bool get hasNext => _hasNext.value;

  final RxInt _page = 1.obs;
  int get page => _page.value;

  final RxList<History> _list = <History>[].obs;
  List<History> get list => _list.value;
  getList(String type) async {
    _fetchData.value = true;
    update();

    List<History> newList = await SourceInOut.gets(page, type);
    _list.value.addAll(newList);

    if (newList.length < 10) _hasNext.value = false;
    _page.value = page + 1;

    _fetchData.value = false;
    update();
  }

  search(String query, String type) async {
    _list.value = await SourceInOut.search(query, type);
    update();
  }

  refreshData(String type) {
    _list.value.clear();
    _page.value = 1;
    _hasNext.value = true;
    getList(type);
  }
}
