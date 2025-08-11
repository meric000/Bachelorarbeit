import 'dart:convert';

import 'package:http/http.dart' as http;

import 'StarwarsUnlimitedCard.dart';

/**
 *  This Method fetches all the Card(s) from the swu-DB mathing the given String and puts in a List
 */
Future<List<StarWarsUnlimitedCard>> fetchbyName(String name) async {
  final url = 'https://api.swu-db.com/cards/search?q=$name';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Serverfehler: ${response.statusCode}');
  }
  final decoded = jsonDecode(response.body);

  // Zugriff auf die Kartenliste im "data"-Feld
  if (decoded is Map && decoded.containsKey('data')) {
    final List<dynamic> cardsList = decoded['data'];
    print("Gefundene Karten: ${cardsList.length}");
    return createSWUCardListFromJson(cardsList);
  } else {
    throw Exception('Unerwartetes JSON-Format');
  }
}

/**
 * fetches a Card from the swu-DB matching the ID (Setcode+Number)
 */
Future<StarWarsUnlimitedCard> fetchCardById(String setCode, String number,) async {
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

/**
 * crates a swu-card from a Json body and adds them into a list to display them
 */
Future<List<StarWarsUnlimitedCard>> createSWUCardListFromJson(List<dynamic> sCardsList,) async {
  List<StarWarsUnlimitedCard> cardList = [];

  for (int i = 0; i < sCardsList.length; i++) {
    final id = "${sCardsList[i]['Set']} ${sCardsList[i]['Number']}";
    final name =
        sCardsList[i]['Subtitle'] != null
            ? "${sCardsList[i]['Name']} – ${sCardsList[i]['Subtitle']}"
            : sCardsList[i]['Name'] ?? 'Unbekannte Karte';
    final imageUrl =
        sCardsList[i]['FrontArt'] ??
        'https://via.placeholder.com/300x420?text=No+Image';

    final cost = int.tryParse(sCardsList[i]['Cost'].toString()) ?? 0;
    final power = int.tryParse(sCardsList[i]['Power'].toString()) ?? 0;
    final hp = int.tryParse(sCardsList[i]['HP'].toString()) ?? 0;
    final bool doubleSided = sCardsList[i]['DoubleSided'] as bool;
    final rarity = "${sCardsList[i]['Rarity']}";
    final bool unique = sCardsList[i]['Unique'] as bool;
    final artist = "${sCardsList[i]['Artist']}";
    final variantType = "${sCardsList[i]['VariantType']}";
    final marketPrice = double.tryParse(sCardsList[i]['MarketPrice'].toString()) ?? 0.0;
    final foilPrice = double.tryParse(sCardsList[i]['FoilPrice'].toString()) ?? 0.0;
    final arena = "${sCardsList[i]['Arenas']}";
    final type = "${sCardsList[i]['Type']}";
    final aspects = (sCardsList[i]['Aspects'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final traits  = (sCardsList[i]['Traits'] as List?)?.map((e) => e.toString()).toList() ?? [];
    String backArt = "This Card has no Back";
    String backText = "";
    if (doubleSided) {
      backArt = "${sCardsList[i]['BackArt']}";
      backText = "${sCardsList[i]['BackText']}";
    }

    cardList.add(
      StarWarsUnlimitedCard(cardId: id, name: name, image: imageUrl,
        cost: cost,
        power: power,
        hp: hp,
        rarity: rarity,
        unique: unique,
        artist: artist,
        variantType: variantType,
        marktPrice: marketPrice,
        foilPrice: foilPrice,
        arena: arena,
        type: type,
        aspects: aspects,
        traits: traits,
        backArt: backArt,
        backtext: backText,),
    );
  }

  return cardList;
}
