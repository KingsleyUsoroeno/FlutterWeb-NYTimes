import 'dart:convert';

import 'package:flutter_web_new_york_times/models/article_dto.dart';
import 'package:http/http.dart' as http;

const String apiKey = String.fromEnvironment("API_KEY", defaultValue: "");

class ApiService {
  final String _baseUrl = "api.nytimes.com";

  Future<List<ArticleDto>> fetchArticlesBySection(String section) async {
    try {
      final Uri uri = Uri.https(
          _baseUrl, '/svc/topstories/v2/$section.json', {"api-key": apiKey});

      final response = await http.get(uri);
      final data = jsonDecode(response.body);

      return List.from(data["results"])
          .map((json) => ArticleDto.fromJson(json))
          .toList();
    } catch (err) {
      throw err.toString();
    }
  }
}
