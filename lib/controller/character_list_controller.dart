import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/character.dart';

Future<List<CharactersMarvel>> fetchMarvelCharacters() async {
  final response = await http.get(Uri.parse(
      'https://gateway.marvel.com:443/v1/public/characters?ts=1678935285&apikey=3fbc7b5a8759b09e370711a5f8e7c053&hash=61addd1b3eb55435c8fb02ea5aa340c6'));
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final data = json['data'];
    final List<dynamic> results = data['results'];
    final characters = results
        .map((characterJson) => CharactersMarvel.fromJson(characterJson))
        .toList();
    return characters;
  } else {
    throw Exception('Falha ao carregar lista de super-heróis');
  }
}
