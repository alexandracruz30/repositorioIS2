import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:healthyfoodscan/model.dart';

class ApiHandler {
  final String baseUri = "http:// 192.168.153.170:5179/api";

  Future<Producto?> getProductoData(String text) async {
    try {
      final uri = Uri.parse('$baseUri/Productoes/definition?word=$text');
      print('Requesting: $uri');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response data: $data');
        return Producto.fromJson(data);
      } else {
        print('Failed to load product data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      ('Error: $e');
      return null;
    }
  }
}
