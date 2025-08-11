import 'package:inventory_course/data/model/supplier.dart';

class Api {
  static const _baseUrl = 'https://inventoryku.shop/api_inventory_course';
  static const user = '$_baseUrl/user';
  static const product = '$_baseUrl/product';
  static const history = '$_baseUrl/history';
  static const inout = '$_baseUrl/inout';
  static const supplier = '$_baseUrl/supplier';

  static const add = 'add.php';
  static const update = 'update.php';
  static const delete = 'delete.php';
  static const gets = 'get.php';
  static const search = 'search.php';
  static const count = 'count.php';
}
