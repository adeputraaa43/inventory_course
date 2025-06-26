import 'dart:convert';
import '../../config/api.dart';
import '../../config/app_request.dart';
import '../model/history.dart';
import '../model/history_rekap.dart';
import 'package:get/get.dart';
import '../../../presentation/controller/c_user.dart';

class SourceHistory {
  static Future<int> count() async {
    String url = '${Api.history}/${Api.count}';
    String? responseBody = await AppRequest.gets(url);
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      return result['data'];
    }
    return 0;
  }

  static Future<List<History>> gets(int page) async {
    String url = '${Api.history}/${Api.gets}';
    String? responseBody = await AppRequest.post(url, {'page': '$page'});
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      if (result['success']) {
        List list = result['data'];
        return list.map((e) => History.fromJson(e)).toList();
      }
      return [];
    }
    return [];
  }

  static Future<List<History>> search(String query) async {
    String url = '${Api.history}/${Api.search}';
    String? responseBody = await AppRequest.post(url, {'date': query});
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      if (result['success']) {
        List list = result['data'];
        return list.map((e) => History.fromJson(e)).toList();
      }
      return [];
    }
    return [];
  }

  static Future<History> getWhereId(String id) async {
    String url = '${Api.history}/where_id.php';
    String? responseBody = await AppRequest.post(url, {'id_history': id});
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      if (result['success']) {
        return History.fromJson(result['data']);
      }
      return History();
    }
    return History();
  }

  static Future<bool> deleteWhereId(String idHistory) async {
    String url = '${Api.history}/delete_where_id.php';
    String? responseBody = await AppRequest.post(url, {
      'id_history': idHistory,
    });
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      return result['success'];
    }
    return false;
  }

  static Future<bool> deleteAllBeforeDate(String date) async {
    String url = '${Api.history}/delete_all_before_date.php';
    String? responseBody = await AppRequest.post(url, {'date': date});
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      return result['success'];
    }
    return false;
  }

  static Future<List<HistoryRekap>> getRekapPerBulan() async {
    final idUser = Get.find<CUser>().data.idUser;
    String url = '${Api.history}/rekap_bulanan.php?id_user=$idUser';

    String? responseBody = await AppRequest.gets(url);

    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      if (result['success']) {
        List list = result['data'];
        return list.map((e) => HistoryRekap.fromJson(e)).toList();
      }
    }
    return [];
  }
}
