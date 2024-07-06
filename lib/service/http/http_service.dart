import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://www.eczaneler.gen.tr/nobetci-erzincan';

class HttpService {
  static Future<String?> get() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint('HttpService $e');
    }
    return null;
  }
}
