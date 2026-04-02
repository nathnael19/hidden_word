import 'package:equatable/equatable.dart';

class WordCategory extends Equatable {
  final String id;
  final String name;
  final String nameAm;
  final List<String> words;

  const WordCategory({
    required this.id,
    required this.name,
    required this.nameAm,
    required this.words,
  });

  factory WordCategory.fromJson(Map<String, dynamic> json) {
    return WordCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAm: json['nameAm'] as String,
      words: List<String>.from(json['words'] as List),
    );
  }

  @override
  List<Object?> get props => [id, name, words];
}
