import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/word_category.dart';

class WordRepository {
  static const String _assetPath = 'assets/words.json';

  static List<WordCategory>? _cache;

  /// Loads and caches all categories from the asset bundle.
  static Future<List<WordCategory>> loadCategories() async {
    if (_cache != null) return _cache!;

    final jsonString = await rootBundle.loadString(_assetPath);
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final categoriesJson = data['categories'] as List;

    _cache = categoriesJson
        .map((e) => WordCategory.fromJson(e as Map<String, dynamic>))
        .toList();

    return _cache!;
  }

  /// Returns the category matching [id], or null if not found.
  static Future<WordCategory?> getCategoryById(String id) async {
    final categories = await loadCategories();
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Picks a random word from the given category id.
  static Future<String> pickRandomWord(String categoryId) async {
    final category = await getCategoryById(categoryId);
    if (category == null || category.words.isEmpty) return 'Injera';
    final random = Random();
    return category.words[random.nextInt(category.words.length)];
  }

  /// Returns all category names for display in the UI.
  static Future<List<WordCategory>> getAllCategories() => loadCategories();
}
