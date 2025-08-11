import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/model/kategori.dart';

Future<List<Kategori>> fetchKategori() async {
  final response = await http.get(
    Uri.parse('http://inventoryku.shop/api_inventory_course/kategori/get.php'),
  );

  if (response.statusCode == 200) {
    final jsonMap = json.decode(response.body);
    final List<dynamic> jsonData = jsonMap['data'];
    return jsonData.map((item) => Kategori.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}
