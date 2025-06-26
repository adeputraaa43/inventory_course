import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/model/kategori.dart';

Future<List<Kategori>> fetchKategori() async {
  final response = await http.get(
    Uri.parse(
        'http://10.0.2.2/inventory_course/api_inventory_course/kategori/get.php'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => Kategori.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}
