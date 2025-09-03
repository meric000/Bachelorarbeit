import 'dart:convert';

import 'package:http/http.dart' as http;

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

//The filter is further explained in the ComplexFilterExplained.txt
//Todo finish ts
Future<List<StarWarsUnlimitedCard>?> fetchbyComplexFilter(String? aspects,
    String? aspectCondition, String? rarity, String? name,
    String? arena, String? category, String? type, String? text, String? stats,
    String? statManipulator, String? statNum, String? sortAspect,
    String? sortOrder) async {

  String urlbase = 'https://api.swu-db.com/cards/search?q=';

  if (aspectCondition != null) {
    urlbase += "a${aspectCondition}%3D${aspects!}+";
  }
  else {
    urlbase += "a%3D${aspects!}+";
  }
  if (rarity != null) {
    urlbase += "%28r%3${rarity}+%29+";
  }
  if (name != null) {
    urlbase += "${name}+";
  }
  if (arena != null) {
    urlbase += "arena%3A${arena}+";
  }
  if (category != null) {
    urlbase += "tr%3A${category}+";
  }
  if (type != null) {
    urlbase += "type%3A${type}+";
  }
  if (text != null) {
    urlbase += "t%3A${text}+";
  }
  if (statNum != null) {
    urlbase += "${stats}${statManipulator}${statNum}+";
  }
  if (sortAspect != null) {
    urlbase += "sort=${sortAspect}+";
  }
  if (sortOrder != null) {
    urlbase += "sort_order=${sortOrder}";
  }

  urlbase += "+and+variant%3Aall&display_mode=checklist&variants=all";
  final response = await http.get(Uri.parse(urlbase));


  if (response.statusCode != 200) {
    print("Fetching URL: $urlbase");
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

Future<List<StarWarsUnlimitedCard>?> fetchbyComplexerFilter(
    String? aspects,
    String? aspectCondition,
    String? rarity,
    String? name,
    String? arena,
    String? category,
    String? type,
    String? text,
    String? stats,
    String? statManipulator,
    String? statNum,
    String? sortAspect,
    String? sortOrder,
    ) async {
  // Basis-URL
  String urlbase = 'https://api.swu-db.com/cards/search?q=';

  // Aspects mit Condition
  if (aspects != null && aspects.isNotEmpty) {
    if (aspectCondition != null) {
      urlbase += "a${aspectCondition}%3D$aspects+"; // z. B. "a=bw"
    } else {
      urlbase += "a%3D$aspects+";
    }
  }

  // Rarity
  if (rarity != null && rarity.isNotEmpty) {
    urlbase += "%28r%3$rarity+%29+"; // z. B. "%28r%3DAc+%29+"
  }

  // Name
  if (name != null && name.isNotEmpty) {
    urlbase += "$name+";
  }

  // Arena
  if (arena != null && arena.isNotEmpty) {
    urlbase += "arena%3A$arena+";
  }

  // Kategorie
  if (category != null && category.isNotEmpty) {
    urlbase += "tr%3A$category+";
  }

  // Typ
  if (type != null && type.isNotEmpty) {
    urlbase += "type%3A$type+";
  }

  // Text
  if (text != null && text.isNotEmpty) {
    urlbase += "t%3A$text+";
  }

  // Stats
  if (statNum != null && statNum.isNotEmpty && stats != null && statManipulator != null) {
    urlbase += "$stats$statManipulator$statNum+";
  }

  // Sortierung
  if (sortAspect != null && sortAspect.isNotEmpty) urlbase += "+and+variant%3Aall&sort=$sortAspect+";

  if (sortOrder != null && sortOrder.isNotEmpty) urlbase += "&sort_order=$sortOrder";

  // Feste Parameter
  urlbase += "display_mode=checklist&variants=all";

  print("Fetching URL: $urlbase");

  // HTTP-Request
  final response = await http.get(Uri.parse(urlbase));

  if (response.statusCode != 200) {
    throw Exception('Serverfehler: ${response.statusCode}');
  }

  final decoded = jsonDecode(response.body);

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


