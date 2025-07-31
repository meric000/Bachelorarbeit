import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'buttonstyle.dart';

Future<CardDeck> fetchCardById(String setCode, String number) async {
  final url = 'https://api.swu-db.com/cards/$setCode/$number';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Serverfehler: ${response.statusCode}');
  }

  final Map<String, dynamic> json = jsonDecode(response.body);
  return CardDeck.fromJson(json);
}

class CardDeck {
  final String cardId;
  final String name;
  final String image;

  const CardDeck({
    required this.cardId,
    required this.name,
    required this.image,
  });

  factory CardDeck.fromJson(Map<String, dynamic> json) {
    // Kombiniere Set und Number zu einer ID
    final id = "${json['Set']}-${json['Number']}";
    // Setze Name und Subtitle zusammen
    final fullName =
        json['Subtitle'] != null
            ? "${json['Name']} – ${json['Subtitle']}"
            : json['Name'];

    return CardDeck(
      cardId: id,
      name: fullName,
      image: json['FrontArt'], // genau wie im JSON
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'SWU Cardfinder',
    home: CollectionScreen(), // oder Scaffold mit BottomNav
  )
  );
}


class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {

  late Future<CardDeck> futureCardDeck;


  @override
  Widget build(BuildContext context) {
    futureCardDeck = fetchCardById('TWI', '147');
    return Center(
      child: FutureBuilder<CardDeck>(
        future: futureCardDeck,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final card = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(card.image, height: 160),
                const SizedBox(height: 16),
                Text(card.name, style: const TextStyle(fontSize: 10)),
                Text("ID: ${card.cardId}"),
                Expanded(
                  child:
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {
                        // Aktion hier
                      },
                      child: const Text('Add Card to Collection'),
                    ),
                  ),
                ),

              ],

            );
          } else {
            return const Center(child: Text('Karte nicht gefunden.'));
          }
        },
      ),
    );
  }


}
