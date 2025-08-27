import 'dart:convert';

import 'package:http/http.dart' as http;
import 'StarwarsUnlimitedCard.dart';
import 'StarwarsUnlimitedCard.dart';

/**
 *  This Method fetches all the Card(s) from the swu-DB mathing the given String and puts in a List
 */
Future<List<StarWarsUnlimitedCard>> fetchbyName(String name) async {
  final url = 'https://api.swu-db.com/cards/search?q=$name''+and+variant%3Aall&display_mode=checklist&variants=all';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Serverfehler: ${response.statusCode}');
  }
  final decoded = jsonDecode(response.body);

  // Zugriff auf die Kartenliste im "data"-Feld
  if (decoded is Map && decoded.containsKey('data')) {
    final List<dynamic> cardsList = decoded['data'];
    print("Gefundene Karten: ${cardsList.length}");
    return StarWarsUnlimitedCard.createSWUCardListFromJson(cardsList);
  } else {
    throw Exception('Unerwartetes JSON-Format');
  }
}

/**
 * fetches a Card from the swu-DB matching the ID (Setcode+Number)
 */
Future<StarWarsUnlimitedCard> fetchCardById(
  String setCode,
  String number,
) async {
  final url = 'https://api.swu-db.com/cards/$setCode/$number';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Serverfehler: ${response.statusCode}');
  }

  final Map<String, dynamic> json = jsonDecode(response.body);
  return StarWarsUnlimitedCard.fromJson(json);
}

Future<StarWarsUnlimitedCard> fetchCardIDFromTextfield(String input) async {
  final cleaned = input.replaceAll('-', ' ').replaceAll('_', ' ').trim();
  final parts = cleaned.split(RegExp(r'\s+')); // trennt nach Leerzeichen

  if (parts.length != 2) {
    throw FormatException(
      'Ungültiges Kartenformat. Nutze z. B. "TWI 147" oder "TWI-147".',
    );
  }
  return fetchCardById(parts[0].toUpperCase(), parts[1]);
}

/**
 * uses fetches the input from a Textfield and calls the fetching Method
 */
Future<List<StarWarsUnlimitedCard>> fetchCardsFromTF(String input) async {
  return fetchbyName(input);
}


