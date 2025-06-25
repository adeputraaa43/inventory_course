import 'dart:convert';
import 'package:d_info/d_info.dart';
import '../../config/api.dart';
import '../../config/app_request.dart';
import '../model/supplier.dart';

class SourceSupplier {
  static Future<int> count() async {
    String url = '${Api.supplier}/${Api.count}';
    String? responseBody = await AppRequest.gets(url);
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      return result['data'];
    }
    return 0;
  }

  static Future<List<Supplier>> gets() async {
    String url = '${Api.supplier}/${Api.gets}';
    String? responseBody = await AppRequest.gets(url);
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      if (result['success']) {
        List list = result['data'];
        return list.map((e) => Supplier.fromJson(e)).toList();
      }
    }
    return [];
  }

  static Future<bool> add(Supplier supplier) async {
    String url = '${Api.supplier}/${Api.add}';
    String? responseBody = await AppRequest.post(url, {
      'id_supplier': supplier.idSupplier.toString(),
      'nama_supplier': supplier.namaSupplier,
      'nama_produk': supplier.namaProduk,
      'created_at': supplier.createdAt,
    });
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      String message = result['message'] ?? '';
      if (message == 'code') {
        DInfo.toastError('Code already used');
      }
      return result['success'];
    }
    return false;
  }

  static Future<bool> update(String oldId, Supplier supplier) async {
    String url = '${Api.supplier}/${Api.update}';
    String? responseBody = await AppRequest.post(url, {
      'old_id': oldId,
      'id_supplier': supplier.idSupplier.toString(),
      'nama_supplier': supplier.namaSupplier,
      'nama_produk': supplier.namaProduk,
      'created_at': supplier.createdAt,
    });
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      String message = result['message'] ?? '';
      if (message == 'code') {
        DInfo.toastError('Code already used');
      }
      return result['success'];
    }
    return false;
  }

  static Future<bool> delete(String id) async {
    String url = '${Api.supplier}/${Api.delete}';
    String? responseBody = await AppRequest.post(url, {
      'id_supplier': id,
    });
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      return result['success'];
    }
    return false;
  }
}
